import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/bloc/category/category_bloc.dart';
import 'package:naqsh_agent/src/model/client/client_model.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';

import '../../bloc/agent/agent_bloc.dart';
import '../../model/category/category_model.dart';
import '../../model/http_result.dart';
import '../../provider/repository.dart';
import '../../utils/utils.dart';
import '../../widget/button/ontap_widget.dart';
import '../../widget/textfield/textfield_widget.dart';

class UpdateAgentScreen extends StatefulWidget {
  final ClientModel client;

  const UpdateAgentScreen({Key? key, required this.client}) : super(key: key);

  @override
  State<UpdateAgentScreen> createState() => _UpdateAgentScreenState();
}

class _UpdateAgentScreenState extends State<UpdateAgentScreen> {
  var data = DateTime.now();
  bool _loading = false;
  bool type = false;
  int agentId = 0;

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController =
        TextEditingController(text: widget.client.name);
        TextEditingController(text: widget.client.surname);
    TextEditingController phoneController =
        TextEditingController(text: widget.client.phone);
    TextEditingController sumUzsController =
        TextEditingController(text: widget.client.summaUzs.toString());
    TextEditingController usdController =
        TextEditingController(text: widget.client.summaUsd.toString());
    TextEditingController dateController =
        TextEditingController(text: DateFormat('yyy-MM-dd').format(widget.client.lastOperationDate));
    TextEditingController commentController =
        TextEditingController(text: widget.client.comment);
    TextEditingController controller =
        TextEditingController(text: widget.client.category.toString());
    double h = Utils.getHeight(context);
    double w = Utils.getWidth(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: AppTheme.black24,
        backgroundColor: AppTheme.background,
      ),
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20.0 * h, vertical: 10 * h),
                  child: Text(
                    'edit'.tr(),
                    style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ),
                TextFieldWidget(
                  controller: dateController,
                  icon: 'assets/icons/calendar.svg',
                  hint: '${data.year}/${data.month}/${data.day}',
                  enables: false,
                ),
                TextFieldWidget(
                    controller: nameController,
                    icon: 'assets/icons/profile.svg',
                    hint: 'name'.tr()),
                TextFieldWidget(
                  controller: phoneController,
                  icon: 'assets/icons/call.svg',
                  hint: 'phone'.tr(),
                  type: true,
                ),
                TextFieldWidget(
                    enables: false,
                    controller: sumUzsController,
                    icon: 'assets/icons/sum.svg',
                    hint: 'Summa uzs',
                    type: true),
                TextFieldWidget(
                    enables: false,
                    controller: usdController,
                    icon: 'assets/icons/sum.svg',
                    hint: 'Summa usd',
                    type: true),
                TextFieldWidget(
                  controller: controller,
                  icon: 'assets/icons/category.svg',
                  hint: controller.text,
                  enables: false,
                ),
                // if (type)
                //   Container(
                //     margin: EdgeInsets.symmetric(horizontal: 20 * w),
                //     width: MediaQuery.of(context).size.width,
                //     height: 100,
                //     decoration: BoxDecoration(
                //         color: AppTheme.white,
                //         borderRadius: BorderRadius.circular(10)),
                //     child: StreamBuilder<List<CategoryModel>>(
                //         stream: categoryBloc.getCategory,
                //         builder: (context, snapshot) {
                //           if (snapshot.hasData) {
                //             return ListView.builder(
                //                 itemCount: snapshot.data!.length,
                //                 itemBuilder: (context, index) {
                //                   return ListTile(
                //                       onTap: () {
                //                         widget.client.category =
                //                             snapshot.data![index].name;
                //                         agentId = snapshot.data![index].id;
                //                         setState(() => type = false);
                //                       },
                //                       title: Text(snapshot.data![index].name),
                //                       trailing: IconButton(
                //                         onPressed: () {
                //                           Repository r = Repository();
                //                           r.categoryDelete(agentId =
                //                               snapshot.data![index].id);
                //                           setState(() => type = false);
                //                         },
                //                         icon: const Icon(
                //                           Icons.delete,
                //                           color: Colors.red,
                //                         ),
                //                       ));
                //                 });
                //           }
                //           return const Center(
                //               child: CircularProgressIndicator.adaptive());
                //         }),
                //   )
                // else
                //   const SizedBox(),
                TextFieldWidget(
                    controller: commentController,
                    icon: 'assets/icons/message.svg',
                    hint: 'comment'.tr()),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 32.0 * w),
            child: OnTapWidget(
                loading: _loading,
                title: 'edit'.tr(),
                onTap: () async {
                  setState(() => _loading = true);
                  Repository repository = Repository();
                  HttpResult response = await repository.updateClient(
                    widget.client.id,
                    nameController.text,
                    phoneController.text,
                    int.parse(sumUzsController.text),
                    int.parse(usdController.text),
                    dateController.text,
                    commentController.text,
                    agentId
                  );

                  if (response.result["status"] == "ok") {
                    setState(() => _loading = false);
                    agentBloc.getClients('');
                    Navigator.pop(context);
                  } else {
                    setState(() => _loading = false);
                    final snackBar = SnackBar(
                      /// need to set following properties for best effect of awesome_snackbar_content
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      behavior: SnackBarBehavior.floating,
                      dismissDirection: DismissDirection.down,
                      content: AwesomeSnackbarContent(
                        title: "Xatolik",
                        message: "Nimadur xato qaytadan urinib koring",
                        contentType: ContentType.failure,
                        inMaterialBanner: false,
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context)
                      ..hideCurrentMaterialBanner()
                      ..showSnackBar(snackBar);
                  }
                }),
          )
        ],
      ),
    );
  }
}
