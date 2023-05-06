import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/bloc/category/category_bloc.dart';
import 'package:naqsh_agent/src/model/category/upadate_category.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';

import '../../bloc/agent/agent_bloc.dart';
import '../../dialog/add_agent_type/agent_type_dialog.dart';
import '../../model/category/category_model.dart';
import '../../model/http_result.dart';
import '../../provider/repository.dart';
import '../../utils/utils.dart';
import '../../widget/button/ontap_widget.dart';
import '../../widget/textfield/textfield_widget.dart';

class AddAgentScreen extends StatefulWidget {
  const AddAgentScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddAgentScreen> createState() => _AddAgentScreenState();
}

class _AddAgentScreenState extends State<AddAgentScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController sumUzsController = TextEditingController();
  TextEditingController usdController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  TextEditingController controller = TextEditingController();

  var data = DateTime.now();
  bool _loading = false;
  bool type = false;
  bool button = false;
  bool button1 = false;
  bool buttonUsd = false;
  bool buttonUsd1 = false;
  String agentType = 'agentType'.tr();
  String balanceTypeSum = '';
  String balanceTypeUsd = '';
  int agentId = 0;
  bool sumType = true;
  bool usdType = true;

  @override
  void initState() {
    super.initState();
    sumUzsController.addListener(() {
      if (sumUzsController.text.length > 1) {
        setState(() {
          sumType = false;
        });
      } else {
        setState(() {
          sumType = true;
        });
      }
    });
    usdController.addListener(() {
      if (usdController.text.length > 1) {
        setState(() {
          usdType = false;
        });
      } else {
        setState(() {
          usdType = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double h = Utils.getHeight(context);
    double w = Utils.getWidth(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                AgentTypeDialog.showAddAgentTypeDialog(context);
              },
              icon: Icon(Icons.add_circle_outline_rounded)),
        ],
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
                    'kontrAgent'.tr(),
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
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
                    },
                    child: TextFieldWidget(
                      controller: dateController,
                      icon: 'assets/icons/calendar.svg',
                      hint: '${data.year}/${data.month}/${data.day}',
                      enables: false,
                    )),
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
                    inputFormatter: true,
                    controller: sumUzsController,
                    icon: 'assets/icons/sum.svg',
                    hint: 'Summa uzs',
                    type: true),
                if(sumType)const SizedBox()
                else Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20 * w, vertical: 10 * h),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              balanceTypeSum = 'debt';
                              button = true;
                              button1 = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(16 * h),
                            decoration: BoxDecoration(
                              color: button ? AppTheme.purple : AppTheme.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Text(
                                  'debtOfSoum'.tr(),
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
                          onTap: (){
                            setState(() {
                              balanceTypeSum = 'loan';
                              button = false;
                              button1 = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(16 * h),
                            decoration: BoxDecoration(
                              color: button1 ? AppTheme.purple : AppTheme.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Text(
                                  'loanOfSoum'.tr(),
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
                    inputFormatter: true,
                    controller: usdController,
                    icon: 'assets/icons/sum.svg',
                    hint: 'Summa usd',
                    type: true),
                if(usdType)const SizedBox()
                else Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 20 * w, vertical: 10 * h),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              balanceTypeUsd = 'debt';
                              buttonUsd = true;
                              buttonUsd1 = false;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(16 * h),
                            decoration: BoxDecoration(
                              color: buttonUsd ? AppTheme.purple : AppTheme.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Text(
                                  'dollarsForDebt'.tr(),
                                  style: TextStyle(
                                      color: buttonUsd
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
                          onTap: (){
                            setState(() {
                              balanceTypeUsd = 'loan';
                              buttonUsd = false;
                              buttonUsd1 = true;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(16 * h),
                            decoration: BoxDecoration(
                              color: buttonUsd1 ? AppTheme.purple : AppTheme.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                                child: Text(
                                  'loanForDebt'.tr(),
                                  style: TextStyle(
                                      color: buttonUsd1
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
                GestureDetector(
                    onTap: () {
                      setState(() => type = !type);
                      categoryBloc.getCategories();
                    },
                    child: TextFieldWidget(
                      controller: controller,
                      icon: 'assets/icons/category.svg',
                      hint: agentType,
                      enables: false,
                    )),
                if (type)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20 * w),
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    decoration: BoxDecoration(
                        color: AppTheme.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: StreamBuilder<List<CategoryModel>>(
                        stream: categoryBloc.getCategory,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return snapshot.data!.isEmpty
                                ? TextButton(
                                    onPressed: () {
                                      AgentTypeDialog.showAddAgentTypeDialog(context);
                                    },
                                    child: Text('noAgent'.tr()))
                                : ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                          onTap: () {
                                            agentType =
                                                snapshot.data![index].name;
                                            agentId = snapshot.data![index].id;
                                            setState(() => type = false);
                                          },
                                          title:
                                              Text(snapshot.data![index].name),
                                          trailing: Wrap(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  UpdateCategoryDialog
                                                      .showUpdateCategoryDialog(
                                                          context,
                                                          snapshot
                                                              .data![index]);
                                                },
                                                icon: const Icon(
                                                  Icons.mode_edit_outlined,
                                                  color: AppTheme.purple,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Repository r = Repository();
                                                  r.categoryDelete(agentId =
                                                      snapshot.data![index].id);
                                                  setState(() => type = false);
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ));
                                    });
                          }
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
                        }),
                  )
                else
                  const SizedBox(),
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
                title: 'loginOnTap'.tr(),
                onTap: () async {
                  setState(() => _loading = true);
                  Repository repository = Repository();
                  HttpResult response = await repository.addClients(
                    nameController.text,
                    surnameController.text,
                    phoneController.text,
                    sumUzsController.text.isEmpty?0:sumUzsController.text.replaceAll(",", ""),
                    usdController.text.isEmpty?0:usdController.text.replaceAll(",", ""),
                    '${data.year}/${data.month}/${data.day}',
                    commentController.text,
                    agentId,
                    balanceTypeSum,
                    balanceTypeUsd
                  );
                  if (response.result["status"] == "ok") {
                    setState(() => _loading = false);
                    agentBloc.getClients('');
                    Navigator.pop(context);
                  }
                  else if(response.result["error_status"] == -9){
                    setState(() => _loading = false);
                    final snackBar = SnackBar(
                      /// need to set following properties for best effect of awesome_snackbar_content
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      behavior: SnackBarBehavior.floating,
                      dismissDirection: DismissDirection.down,
                      content: AwesomeSnackbarContent(
                        title: "Xatolik",
                        message: "Bu agentni raqami avval qoshilgan",
                        contentType: ContentType.failure,
                        inMaterialBanner: false,
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context)
                      ..hideCurrentMaterialBanner()
                      ..showSnackBar(snackBar);
                  }
                  else {
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
