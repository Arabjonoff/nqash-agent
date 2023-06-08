import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/bloc/cost/cost_bloc.dart';
import 'package:naqsh_agent/src/bloc/expense/expense_bloc.dart';
import 'package:naqsh_agent/src/dialog/add_expense/add_expense_dialog.dart';
import 'package:naqsh_agent/src/dialog/add_expense/update_expense_dialog.dart';
import 'package:naqsh_agent/src/dialog/loading/loading_dialog.dart';
import 'package:naqsh_agent/src/model/http_result.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:naqsh_agent/src/widget/button/ontap_widget.dart';

import '../../bloc/banner/banner_bloc.dart';
import '../../bloc/wallet/wallet_bloc.dart';
import '../../model/cost/cost_model.dart';
import '../../model/wallet/wallet_model.dart';
import '../../utils/utils.dart';
import '../../widget/textfield/textfield_widget.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({Key? key}) : super(key: key);

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final Repository _repository = Repository();
  TextEditingController controller = TextEditingController();
  TextEditingController usdController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  var data = DateTime.now();
  bool wal = false;
  bool cost = false;
  bool success = true;
  bool warning = false;
  bool loading = false;
  int costId = 0;
  String wallet = 'wallet'.tr();
  String costs = 'typeExpense'.tr();
  String? walletType;
  int idWallet = 1;

  @override
  Widget build(BuildContext context) {
    double h = Utils.getHeight(context);
    double w = Utils.getWidth(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppTheme.black24,
        elevation: 0,
        backgroundColor: AppTheme.background,
        title: Text('addExpense'.tr()),
        actions: [
          IconButton(
              onPressed: () {
                AddExpenseDialog.addExpenseDialog(context);
              },
              icon: const Icon(Icons.add_circle_outline))
        ],
      ),
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                GestureDetector(
                    onTap: ()async{
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
                      if(newDate == null)return;
                      setState(() => data = newDate);
                    },
                    child: TextFieldWidget(
                      controller: dateController,
                      icon: 'assets/icons/calendar.svg',
                      hint: '${data.year}/${data.month}/${data.day}',
                      enables: false,
                    )),
                GestureDetector(
                    onTap: () {
                      costBloc.getCosts();
                      cost = !cost;
                      setState(() {});
                    },
                    child: TextFieldWidget(
                      controller: controller,
                      enables: false,
                      icon: 'assets/icons/category.svg',
                      hint: costs,
                    )),
                if (cost)
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 20 * w),
                      width: MediaQuery.of(context).size.width,
                      height: 120 * h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppTheme.white,
                      ),
                      child: StreamBuilder<CostGetModel>(
                          stream: costBloc.getCost,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<Datum> data = snapshot.data!.data;
                              return data.isEmpty?TextButton(onPressed: (){
                                AddExpenseDialog.addExpenseDialog(context);
                              }, child:  Text('add'.tr())):Scrollbar(
                                child: ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                          onTap: () {
                                            costs = data[index].name;
                                            costId = data[index].id;
                                            cost = false;
                                            setState(() {});
                                          },
                                          child:ListTile(
                                            title: Text(
                                              data[index].name,
                                              style:
                                              const TextStyle(fontSize: 16),
                                            ),
                                            trailing: Wrap(
                                              children: [
                                                IconButton(onPressed: (){
                                                  UpdateExpenseDialog.updateExpenseDialog(context,data[index]);
                                                }, icon: const Icon(Icons.mode_edit_outline_outlined,color: AppTheme.purple)),
                                                IconButton(onPressed: ()async{
                                                  Repository r = Repository();
                                                  HttpResult res = await r.deleteCost(data[index].id);
                                                  if(res.result["status"] == "ok"){
                                                    final snackBar = SnackBar(
                                                      /// need to set following properties for best effect of awesome_snackbar_content
                                                      elevation: 0,
                                                      backgroundColor: Colors.transparent,
                                                      behavior: SnackBarBehavior.floating,
                                                      dismissDirection: DismissDirection.down,
                                                      content: AwesomeSnackbarContent(
                                                        title: "OK",
                                                        message: "Successfully",
                                                        contentType: ContentType.success,
                                                        inMaterialBanner: false,
                                                      ),
                                                    );
                                                    // ignore: use_build_context_synchronously
                                                    ScaffoldMessenger.of(context)..hideCurrentMaterialBanner()..showSnackBar(snackBar);
                                                    costBloc.getCosts();
                                                  }
                                                }, icon: const Icon(Icons.delete,color: Colors.red))
                                              ],
                                            ),
                                          ),
                                      );
                                    }),
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator.adaptive());
                          }))
                else
                  const SizedBox(),
                GestureDetector(
                  onTap: () {
                    walletBloc.getWallet();
                    setState(() {
                      wal = !wal;
                    });
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
                              return Scrollbar(
                                child: ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                          onTap: () {
                                            setState(() {
                                              balans =
                                                  snapshot.data![index].balans;
                                              wallet =
                                                  snapshot.data![index].name;
                                              walletType = snapshot
                                                  .data![index].valyuteType;
                                              idWallet =
                                                  snapshot.data![index].id;
                                            });
                                            wal = false;
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              snapshot.data![index].name,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ));
                                    }),
                              );
                            }
                            return const Center(
                                child: CircularProgressIndicator.adaptive());
                          }))
                else
                  const SizedBox(),
                TextFieldWidget(
                  inputFormatter: true,
                  type: true,
                    controller: usdController,
                    icon: 'assets/icons/coin.svg',
                    hint: 'summa'.tr()),
                TextFieldWidget(
                    controller: commentController,
                    icon: 'assets/icons/message.svg',
                    hint: 'comment'.tr()),

              ],
            ),
          ),
          OnTapWidget(
            loading: loading,
              title: 'add'.tr(),
              onTap: () async {
              try{
               if(int.parse(Platform.isAndroid?usdController.text.replaceAll(",", ""):usdController.text.replaceAll(",", ""))< balans ){
                 setState(() =>loading = true);
                 HttpResult res = await _repository.addExpense(
                   '${data.year}-${data.month}-${data.month}',
                   idWallet,
                   walletType == 'sum'?int.parse(Platform.isAndroid?usdController.text.replaceAll(",", ""):usdController.text.replaceAll(",", "")):0,
                   walletType == 'dollar'?int.parse(Platform.isAndroid?usdController.text.replaceAll(",", ""):usdController.text.replaceAll(",", "")):0,
                   costId,
                   commentController.text,
                 );
                 if(res.result["status"] == 'Ok'){
                   setState(() =>loading = false);
                   expenseBloc.getExpenses(data, '','');
                   bannerBloc.getBanner();
                   walletBloc.getWallet();
                   Navigator.pop(context);

                 }
                 else{
                   final snackBar = SnackBar(
                     /// need to set following properties for best effect of awesome_snackbar_content
                     elevation: 0,
                     backgroundColor: Colors.transparent,
                     behavior: SnackBarBehavior.floating,
                     dismissDirection: DismissDirection.down,
                     content: AwesomeSnackbarContent(
                       title: "Error",
                       message: res.result['error_message'],
                       contentType: ContentType.failure,
                       inMaterialBanner: false,
                     ),
                   );
                   // ignore: use_build_context_synchronously
                   ScaffoldMessenger.of(context)..hideCurrentMaterialBanner()..showSnackBar(snackBar);
                   setState(() =>loading = false);
                 }
               }
               else{
                 final snackBar = SnackBar(
                   /// need to set following properties for best effect of awesome_snackbar_content
                   elevation: 0,
                   backgroundColor: Colors.transparent,
                   behavior: SnackBarBehavior.floating,
                   dismissDirection: DismissDirection.down,
                   content: AwesomeSnackbarContent(
                     title: "Error",
                     message: "Xamyonda mablag yetarli emas",
                     contentType: ContentType.failure,
                     inMaterialBanner: false,
                   ),
                 );
                 ScaffoldMessenger.of(context)..hideCurrentMaterialBanner()..showSnackBar(snackBar);
               }
              }catch(_){
                final snackBar = SnackBar(
                  /// need to set following properties for best effect of awesome_snackbar_content
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  behavior: SnackBarBehavior.floating,
                  dismissDirection: DismissDirection.down,
                  content: AwesomeSnackbarContent(
                    title: "Error",
                    message: "Nimadur xato qaytadan urinib koring",
                    contentType: ContentType.failure,
                    inMaterialBanner: false,
                  ),
                );
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context)..hideCurrentMaterialBanner()..showSnackBar(snackBar);
                setState(() =>loading = false);
              }

              }),
          SizedBox(
            height: 32 * h,
          )
        ],
      ),
    );
  }

  dialog(){
    LoadingDialog.showLoadingDialog(context, 'body', success);
  }
  int balans = 0;

}
