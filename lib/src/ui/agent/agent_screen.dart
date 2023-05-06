import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:naqsh_agent/src/bloc/agent/agent_bloc.dart';
import 'package:naqsh_agent/src/model/client/client_model.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:naqsh_agent/src/ui/agent/add_agent_screen.dart';
import 'package:naqsh_agent/src/ui/agent/agent_history.dart';
import 'package:naqsh_agent/src/ui/agent/serach_screen.dart';
import 'package:naqsh_agent/src/ui/agent/update_agent.dart';
import 'package:naqsh_agent/src/utils/bus/rx_bus.dart';
import 'package:naqsh_agent/src/widget/button/ontap_widget.dart';
import '../../bloc/category/category_bloc.dart';
import '../../dialog/connection/connection_dialog.dart';
import '../../model/category/category_model.dart';
import '../../model/http_result.dart';
import '../../theme/app_theme.dart';
import '../../utils/utils.dart';
import '../bottom_menu/bottom_menu_screen.dart';

class AgentScreen extends StatefulWidget {
  const AgentScreen({Key? key}) : super(key: key);

  @override
  State<AgentScreen> createState() => _AgentScreenState();
}

class _AgentScreenState extends State<AgentScreen> {
  int agentId = 0;

  @override
  void initState() {
    agentBloc.getClients('');
    _initBus();
    super.initState();
  }

  @override
  void dispose() {
    agentBloc.getClients('');
    RxBus.destroy(tag: 'agent_bloc_get_clients');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Repository repository = Repository();
    double h = Utils.getHeight(context);
    double w = Utils.getWidth(context);
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        elevation: 5,
        foregroundColor: AppTheme.black24,
        backgroundColor: AppTheme.white,
        centerTitle: true,
        title:  Text(
          'agent'.tr(),
          style: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return SearchScreen();
                }));
              },
              icon: const Icon(Icons.search_rounded)),
          Builder(
            builder: (context) => IconButton(
              icon: SvgPicture.asset('assets/icons/filter.svg'),
              onPressed: () {
                categoryBloc.getCategories();
                Scaffold.of(context).openEndDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Text(
                'Filtr',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              )),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'agentType'.tr(),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 0 * w),
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: StreamBuilder<List<CategoryModel>>(
                    stream: categoryBloc.getCategory,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              onTap: () {
                                setState(() {
                                  agentId = snapshot.data![index].id;
                                });
                              },
                              title: Text(
                                snapshot.data![index].name,
                                style: TextStyle(
                                    color: agentId == snapshot.data![index].id
                                        ? AppTheme.purple
                                        : Colors.black),
                              ),
                            );
                          },
                        );
                      }
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }),
              ),
              Spacer(),
              TextButton(
                  onPressed: () {
                    setState(() {
                      agentId = 0;
                      Navigator.pop(context);
                      agentBloc.getClients('');
                    });
                  },
                  child: Center(child: Text('clean'.tr()))),
              Row(
                children: [
                  Expanded(
                      child: OnTapWidget(
                    title: 'back'.tr(),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    color: false,
                  )),
                  Expanded(
                      child: OnTapWidget(
                          title: 'apply'.tr(),
                          onTap: () {
                            agentBloc.getClients(agentId);
                            Navigator.pop(context);
                          })),
                ],
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ClientModel>>(
                stream: agentBloc.getClient,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<ClientModel> data = snapshot.data!;
                    return data.isNotEmpty
                        ? ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                  onDismissed: (direction) async {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      final bool res = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Text(
                                                  "Haqiqatan ham oʻchirib tashlamoqchimisiz ${data[index].name}?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text(
                                                    "Orqaga",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {});
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text(
                                                    "O'chirish",
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                  onPressed: () async {
                                                    HttpResult res =
                                                        await repository
                                                            .deleteClient(
                                                                data[index].id);
                                                    if (res.result["status"] ==
                                                        "ok") {
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.pop(context);
                                                      agentBloc.getClients('');
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    } else {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return UpdateAgentScreen(
                                            client: data[index]);
                                      }));
                                    }
                                  },
                                  secondaryBackground: slideLeftBackground(),
                                  background: slideRightBackground(),
                                  key: UniqueKey(),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return AgentHistoryScreen(
                                              id: data[index].id,
                                              name: data[index].name,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 20 * h, horizontal: 20 * h),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20 * w, vertical: 10),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: AppTheme.white,
                                        boxShadow: const [
                                          BoxShadow(
                                            offset: Offset(4, 15),
                                            blurRadius: 15,
                                            color: Color.fromRGBO(0, 0, 0, 0.1),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                data[index].name,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black
                                                        .withOpacity(0.7)),
                                              ),
                                              Text(
                                                data[index].phone,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black
                                                        .withOpacity(0.7)),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'agentType'.tr(),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black
                                                        .withOpacity(0.7)),
                                              ),
                                              Text(
                                                data[index].category,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black
                                                        .withOpacity(0.7)),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${priceFormat.format(data[index].summaUzs)} uzs",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: data[index]
                                                                    .summaUzs
                                                                    .toString()[
                                                                0] ==
                                                            '-'
                                                        ? Colors.green
                                                        : Colors.red),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${priceFormat.format(data[index].summaUsd)} \$",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w400,
                                                    color: data[index]
                                                                    .summaUsd
                                                                    .toString()[
                                                                0] ==
                                                            '-'
                                                        ? Colors.green
                                                        : Colors.red),
                                              ),
                                              Spacer(),
                                              Text(DateFormat("yyyy-MM-dd")
                                                  .format(data[index]
                                                      .lastOperationDate))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          data[index].comment.isEmpty
                                              ? const SizedBox()
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'comment'.tr(),
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.7)),
                                                    ),
                                                    Text(
                                                      data[index].comment,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.7)),
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                  ));
                            })
                        :  Center(
                            child: Text(
                                'agentEmpty'.tr()));
                  }
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: UniqueKey(),
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AddAgentScreen())),
        backgroundColor: AppTheme.purple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children:  [
            const Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              "delete".tr(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:  <Widget>[
            const SizedBox(
              width: 20,
            ),
            const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              "edit".tr(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  void _initBus() {
    RxBus.register<String>(tag: 'agent_bloc_get_clients').listen((event) {
      ConnectionDialog.showConnectionDialog(context, event);
    });
  }
}
