// ignore_for_file: non_constant_identifier_names
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:naqsh_agent/src/bloc/agent/agent_bloc.dart';
import 'package:naqsh_agent/src/bloc/income/income_bloc.dart';
import 'package:naqsh_agent/src/bloc/wallet/wallet_bloc.dart';
import 'package:naqsh_agent/src/model/course/course_model.dart';
import 'package:naqsh_agent/src/model/http_result.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:naqsh_agent/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/banner/banner_bloc.dart';
import '../../bloc/course/course_bloc.dart';
import '../../dialog/add_valyute/add_valyute_dialog.dart';
import '../../model/client/client_model.dart';
import '../../model/wallet/wallet_model.dart';
import '../../theme/app_theme.dart';
import '../../widget/button/ontap_widget.dart';
import '../../widget/textfield/textfield_widget.dart';
import '../agent/add_agent_screen.dart';
import '../bottom_menu/bottom_menu_screen.dart';
import '../wallet/wallet_add/add_wallet.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({Key? key}) : super(key: key);

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final List<String> items = [
    'sum',
    'dollar',
  ];
  String? selectedValue;
  String value = 'Agent';
  String wallet = 'Hamyon';
  String? walletType;
  var data = DateTime.now();
  TextEditingController controller = TextEditingController();
  TextEditingController controllerComment = TextEditingController();
  TextEditingController sumController = TextEditingController();
  TextEditingController agentController = TextEditingController();
  bool agent = false;
  bool courseContainer = false;
  bool wal = false;
  bool clientId = false;
  bool button = false;
  bool button1 = false;
  String which_debt = '';
  num summa_uzs = 0;
  num summa_usd = 0;
  int idClient = 0;
  int idWallet = 1;
  num res = 0;
  int summaUzs = 0;
  int summaUsd = 0;
  int doll = 0;
  final Repository _repository = Repository();

  @override
  void initState() {
    super.initState();
    usd();
    courseBloc.getCourse();
  }

  @override
  void dispose() {
    super.dispose();
    courseBloc.getCourse();
  }

  @override
  Widget build(BuildContext context) {
    double w = Utils.getWidth(context);
    double h = Utils.getHeight(context);
    return Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          elevation: 5,
          foregroundColor: AppTheme.black24,
          backgroundColor: AppTheme.white,
          centerTitle: true,
          title: const Text(
            'Kirim qo\'shish',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  AddValyuteDialog.showAddValyuteDialog(context);
                },
                icon: const Icon(Icons.monetization_on_outlined))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () async {
                        DateTime? newDate = await showDatePicker(
                            context: context,
                            initialDate: data,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: ThemeData(
                                  dialogTheme: const DialogTheme(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                  primaryColor: Colors.blue,
                                  colorScheme: const ColorScheme.light(
                                      primary: AppTheme.purple),
                                  buttonTheme: const ButtonThemeData(
                                      textTheme: ButtonTextTheme
                                          .primary), // This will change to light theme.
                                ),
                                child: child!,
                              );
                            });
                        if (newDate == null) return;
                        setState(() => data = newDate);
                        // DatePicker.showDatePicker(
                        //   context,
                        //   showTitleActions: true,
                        //   minTime: DateTime(2022, 01, 01),
                        //   maxTime: DateTime.now(),
                        //   onConfirm: (date) {
                        //     print('confirm $date');
                        //     data = DateFormat('yyyy-MM-dd').format(date);
                        //     state();
                        //   },
                        // );
                      },
                      child: TextFieldWidget(
                        enables: false,
                        controller: controller,
                        icon: 'assets/icons/calendar.svg',
                        hint: '${data.year}/${data.month}/${data.day}',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        agentBloc.getClients('');
                        agent = !agent;
                        state();
                      },
                      child: TextFieldWidget(
                          enables: false,
                          controller: agentController,
                          icon: 'assets/icons/profile.svg',
                          hint: value.toString()),
                    ),
                    if (agent)
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 20 * w),
                        height: 200 * h,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: StreamBuilder<List<ClientModel>>(
                          stream: agentBloc.getClient,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data!.isEmpty
                                  ? TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AddAgentScreen()));
                                      },
                                      child: const Text(
                                          'Sizda hali agentlar yoq agent qoshish'))
                                  : Scrollbar(
                                      child: ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.white,
                                                border: Border(
                                                    bottom: BorderSide(
                                                        width: 0.5,
                                                        color: Colors.grey))),
                                            child: InkWell(
                                                onTap: () async {
                                                  HttpResult res =
                                                      await _repository
                                                          .clientId(snapshot
                                                              .data![index].id);
                                                  summa_uzs =
                                                      res.result["client"]
                                                          ["summa_uzs"];
                                                  summa_usd =
                                                      res.result["client"]
                                                          ["summa_usd"];
                                                  value = snapshot
                                                      .data![index].name;
                                                  idClient =
                                                      snapshot.data![index].id;
                                                  agent = false;
                                                  clientId = true;
                                                  state();
                                                },
                                                child: ListTile(
                                                  title: Text(
                                                    snapshot.data![index].name,
                                                  ),
                                                  style: ListTileStyle.list,
                                                )),
                                          );
                                        },
                                      ),
                                    );
                            }
                            return const Center(
                                child: CircularProgressIndicator.adaptive());
                          },
                        ),
                      )
                    else
                      const SizedBox(),
                    if (clientId)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16 * w, vertical: 5 * h),
                        margin: EdgeInsets.symmetric(horizontal: 20 * w),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppTheme.white,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Qarzi:',
                                ),
                                Text(
                                  '${priceFormat.format(summa_uzs)} som',
                                  style: TextStyle(
                                      color:
                                          summa_uzs.toString().startsWith('-')
                                              ? Colors.green
                                              : Colors.red),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10 * h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(''),
                                Text('${priceFormat.format(summa_usd)} \$',
                                    style: TextStyle(
                                        color:
                                            summa_usd.toString().startsWith('-')
                                                ? Colors.green
                                                : Colors.red)),
                              ],
                            ),
                          ],
                        ),
                      )
                    else
                      const SizedBox(),
                    GestureDetector(
                      onTap: () {
                        walletBloc.getWallet();
                        wal = !wal;
                        state();
                      },
                      child: TextFieldWidget(
                          controller: controller,
                          enables: false,
                          icon: 'assets/icons/wallet.svg',
                          hint: wallet.toString()),
                    ),
                    if (wal)
                      Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 20 * w),
                          height: 100 * h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: StreamBuilder<List<WalletModel>>(
                              stream: walletBloc.getWalletInfo,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return snapshot.data!.isEmpty
                                      ? TextButton(
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return const WalletAddScreen();
                                            }));
                                          },
                                          child: const Text(
                                              'Sizda hali hamyon yoq hamyon qoshinig'))
                                      : Scrollbar(
                                          child: ListView.builder(
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                    onTap: () async {
                                                      wallet = snapshot
                                                          .data![index].name;
                                                      walletType = snapshot
                                                          .data![index]
                                                          .valyuteType;
                                                      idWallet = snapshot
                                                          .data![index].id;
                                                      wal = false;
                                                      SharedPreferences pre =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      pre.setString(
                                                          'walletName',
                                                          snapshot.data![index]
                                                              .name);
                                                      pre.setInt(
                                                          'walletId',
                                                          snapshot
                                                              .data![index].id);
                                                      pre.setString(
                                                          'walletType',
                                                          snapshot.data![index]
                                                              .valyuteType);
                                                      state();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        snapshot
                                                            .data![index].name,
                                                        style: TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    ));
                                              }),
                                        );
                                }
                                return const Center(
                                    child:
                                        CircularProgressIndicator.adaptive());
                              }))
                    else
                      const SizedBox(),
                    if (value == 'Agent')
                      Container()
                    else
                      GestureDetector(
                        onTap: () async {
                          courseContainer = true;
                          courseBloc.getCourse();
                        },
                        child: TextFieldWidget(
                            enables: false,
                            currencyType: '${priceFormat.format(doll)} som',
                            controller: controller,
                            icon: 'assets/icons/sum.svg',
                            hint: 'Bugungi kurs'),
                      ),
                    StreamBuilder<CourseAllModel>(
                        stream: courseBloc.getCourses,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Datum> data = snapshot.data!.data;
                            return courseContainer
                                ? Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20 * w),
                                    width: MediaQuery.of(context).size.width,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: data.isEmpty
                                        ? TextButton(
                                            onPressed: () {
                                              AddValyuteDialog
                                                  .showAddValyuteDialog(
                                                      context);
                                            },
                                            child: Text(
                                                'sizda hali kurs yoq kurs qoshing'))
                                        : ListView.builder(
                                            itemCount: data.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  SharedPreferences pre =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  pre.setInt('dollar',
                                                      data[index].course);
                                                  doll = data[index].course;
                                                  courseContainer = false;
                                                  state();
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          '${data[index].course} sum'),
                                                      Text(DateFormat(
                                                              'yyyy-MM-dd')
                                                          .format(data[index]
                                                              .regDate)),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                  )
                                : SizedBox();
                          }
                          return Container();
                        }),
                    TextFieldWidget(
                      inputFormatter: true,
                      type: true,
                      controller: sumController,
                      icon: 'assets/icons/coin.svg',
                      hint: 'Summa',
                      currency: true,
                    ),
                    if (value == 'Agent')
                      Container()
                    else
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20 * w, vertical: 10 * h),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (walletType == 'sum') {
                                    summaUzs = int.parse(
                                        sumController.text.replaceAll(",", ""));
                                  } else  {
                                    summaUzs = int.parse(sumController.text
                                            .replaceAll(",", "")) *
                                        doll;
                                  }
                                  which_debt = 'sum';
                                  button = true;
                                  summaUsd = 0;
                                  button1 = false;
                                  state();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16 * h),
                                  decoration: BoxDecoration(
                                    color: button
                                        ? AppTheme.purple
                                        : AppTheme.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'So\'m qarzi uchun',
                                    style: TextStyle(
                                        color: button
                                            ? AppTheme.white
                                            : AppTheme.black24,
                                        fontSize: 15 * h,
                                        fontWeight: FontWeight.w600),
                                  )),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20 * w,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (walletType == 'sum') {
                                    summaUsd = int.parse(sumController.text
                                            .replaceAll(",", "")) ~/
                                        doll;

                                  } else {
                                    summaUsd = int.parse(
                                        sumController.text.replaceAll(",", ""));
                                  }
                                  state();
                                  which_debt = 'dollar';
                                  button = false;
                                  summaUzs = 0;
                                  button1 = true;
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16 * h),
                                  decoration: BoxDecoration(
                                    color: button1
                                        ? AppTheme.purple
                                        : AppTheme.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'Dollar qarzi uchun',
                                    style: TextStyle(
                                        color: button1
                                            ? AppTheme.white
                                            : AppTheme.black24,
                                        fontSize: 15 * h,
                                        fontWeight: FontWeight.w600),
                                  )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    TextFieldWidget(
                        controller: controllerComment,
                        icon: 'assets/icons/message.svg',
                        hint: 'Izoh'),
                    if (value == 'Agent')
                      Container()
                    else
                      Container(
                        padding: EdgeInsets.all(16 * h),
                        margin: EdgeInsets.symmetric(
                            horizontal: 20 * w, vertical: 10 * h),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.white),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Qabul qilinadi:'),
                            Text(which_debt == 'sum'
                                ? priceFormat.format(summaUzs).toString()
                                : priceFormat.format(summaUsd).toString()),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OnTapWidget(
                    title: 'Bekor qilish',
                    onTap: () => Navigator.pop(context),
                    color: false,
                  ),
                ),
                Expanded(
                  child: OnTapWidget(
                      title: "Qo'\shish",
                      onTap: () async {
                        if(value == 'Agent'){
                          HttpResult result = await _repository.addOperation(
                            "kirim",
                            '${data.year}-${data.month}-${data.day}',
                            idClient,
                            idWallet,
                            walletType=='sum'?int.parse(sumController.text.replaceAll(',', '')):0,
                            walletType=='dollar'?int.parse(sumController.text.replaceAll(',', '')):0,
                            which_debt,
                            controllerComment.text,
                              which_debt == 'sum'
                                  ? priceFormat.format(summaUzs).toString()
                                  : priceFormat.format(summaUsd).toString()
                          );
                          if (result.result["status"] == 'Ok') {
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            walletBloc.getWallet();
                            bannerBloc.getBanner();
                            incomeBloc.getIncome(
                                DateFormat('yyyy-MM').format(DateTime.now()), '');
                          } else {
                            final snackBar = SnackBar(
                              /// need to set following properties for best effect of awesome_snackbar_content
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              behavior: SnackBarBehavior.floating,
                              dismissDirection: DismissDirection.down,
                              content: AwesomeSnackbarContent(
                                title: "Xatolik",
                                message: result.result["error_message"],
                                contentType: ContentType.failure,
                                inMaterialBanner: false,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                              ..hideCurrentMaterialBanner()
                              ..showSnackBar(snackBar);
                          }
                        }
                        else{
                          HttpResult result = await _repository.addOperation(
                            "kirim",
                            '${data.year}-${data.month}-${data.day}',
                            idClient,
                            idWallet,
                            summaUzs==0?int.parse(sumController.text.replaceAll(',', '')):summaUzs,
                            summaUsd==0?int.parse(sumController.text.replaceAll(',', '')):summaUsd,
                            which_debt,
                            controllerComment.text,
                              which_debt == 'sum'
                                  ? "${priceFormat.format(summaUzs)} som"
                                  : '${priceFormat.format(summaUsd)} dollar'
                          );
                          if (result.result["status"] == 'Ok') {
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            incomeBloc.getIncome(
                                DateFormat('yyyy-MM').format(DateTime.now()), '');
                          } else {
                            final snackBar = SnackBar(
                              /// need to set following properties for best effect of awesome_snackbar_content
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              behavior: SnackBarBehavior.floating,
                              dismissDirection: DismissDirection.down,
                              content: AwesomeSnackbarContent(
                                title: "Xatolik",
                                message: result.result["error_message"],
                                contentType: ContentType.failure,
                                inMaterialBanner: false,
                              ),
                            );
                            ScaffoldMessenger.of(context)
                              ..hideCurrentMaterialBanner()
                              ..showSnackBar(snackBar);
                          }
                        }
                      },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ));
  }

  usd() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    doll = preferences.getInt('dollar') ?? 0;
    wallet = preferences.getString('walletName') ?? "Hamyon";
    walletType = preferences.getString('walletType') ?? "";
    idWallet = preferences.getInt('walletId') ?? 0;
    state();
  }

  void state() {
    setState(() {});
  }
}
