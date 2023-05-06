import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:naqsh_agent/src/bloc/debt/debt_bloc.dart';

import '../../bloc/agent/agent_bloc.dart';
import '../../bloc/banner/banner_bloc.dart';
import '../../bloc/wallet/wallet_bloc.dart';
import '../../model/client/client_model.dart';
import '../../model/http_result.dart';
import '../../model/wallet/wallet_model.dart';
import '../../provider/repository.dart';
import '../../theme/app_theme.dart';
import '../../utils/utils.dart';
import '../../widget/button/ontap_widget.dart';
import '../../widget/textfield/textfield_widget.dart';
import '../bottom_menu/bottom_menu_screen.dart';

class AddDebtScreen extends StatefulWidget {
  const AddDebtScreen({Key? key}) : super(key: key);

  @override
  State<AddDebtScreen> createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends State<AddDebtScreen> {
  TextEditingController controller = TextEditingController();
  TextEditingController controllerComment = TextEditingController();
  TextEditingController sumController = TextEditingController();
  TextEditingController agentController = TextEditingController();
  var data = DateTime.now();
  String value = 'Agent';
  String wallet = 'Hamyon *';
  bool agent = false;
  bool wal = false;
  bool clientId = false;
  bool button = false;
  bool button1 = false;
  int summa_uzs = 0;
  int summa_usd = 0;
  int idClient = 1;
  int idWallet = 1;
  num res = 0;
  num summa = 0;
  num doll = 11225;
  String? walletType;
  int balans = 0;
  final Repository _repository = Repository();


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
            'Chiqim qo\'shish',
            style: TextStyle(
                fontSize: 25, fontWeight: FontWeight.w700, color: Colors.black),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20))),
        ),
        body: Column(
          children: [
            Expanded(child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20,),
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
                      enables: false,
                        controller: controller,
                        icon: 'assets/icons/calendar.svg',
                        hint: '${data.year}/${data.month}/${data.day}'),
                  ),
                  GestureDetector(
                    onTap: () {
                      agentBloc.getClients('');
                      setState(() {
                        agent = !agent;
                      });
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
                            return Scrollbar(
                              child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(bottom: BorderSide(width: 0.5,color: Colors.grey))
                                    ),
                                    child: InkWell(
                                        onTap: () async {
                                          HttpResult res = await _repository
                                              .clientId(snapshot.data![index].id);
                                          summa_uzs =
                                          res.result["client"]["summa_uzs"];
                                          summa_usd =
                                          res.result["client"]["summa_usd"];
                                          value = snapshot.data![index].name;
                                          idClient = snapshot.data![index].id;
                                          agent = false;
                                          clientId = true;
                                          setState(() {

                                          });
                                        },
                                        child: ListTile(
                                          title: Text(snapshot.data![index].name,),style: ListTileStyle.list,)
                                    ),
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
                              Text('${priceFormat.format(summa_uzs)} som',style: TextStyle(color: summa_uzs.toString().startsWith('-')?Colors.green:Colors.red)),
                            ],
                          ),
                          SizedBox(
                            height: 10 * h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(''),
                              Text('${priceFormat.format(summa_usd)} \$',style: TextStyle(color: summa_usd.toString().startsWith('-')?Colors.green:Colors.red)),
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
                                                wallet = snapshot.data![index].name;
                                                balans = snapshot.data![index].balans;
                                                walletType = snapshot.data![index].valyuteType;
                                                idWallet = snapshot.data![index].id;
                                              });
                                              wal = false;
                                            },
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Text(
                                                snapshot.data![index].name,
                                                style:
                                                TextStyle(fontSize: 16),
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
                  TextFieldWidget(
                    inputFormatter: true,
                    type: true,
                      controller: sumController,
                      icon: 'assets/icons/coin.svg',
                      hint: 'Summa *'),
                  TextFieldWidget(
                      controller: controllerComment,
                      icon: 'assets/icons/message.svg',
                      hint: 'Izoh (majburiy emas)'),

                ],
              ),
            ),),
            Row(
              children: [
                Expanded(child:OnTapWidget(title: 'Bekor qilish', onTap: () => Navigator.pop(context),color: false,),),
                Expanded(
                  child: OnTapWidget(
                      title: "Qo'\shish",
                      onTap: () async {
                        if(int.parse(Platform.isAndroid?sumController.text.replaceAll(",", ""):sumController.text.replaceAll(",", "")) < balans){
                          HttpResult result = await _repository.addOperation(
                              'chiqim',
                              '${data.year}-${data.month}-${data.day}',
                              idClient,
                              idWallet,
                              walletType == 'sum'?int.parse(Platform.isAndroid?sumController.text.replaceAll(",", ""):sumController.text.replaceAll(",", "")):0,
                              walletType == 'dollar'?int.parse(Platform.isAndroid?sumController.text.replaceAll(",", ""):sumController.text.replaceAll(",", "")):0,
                              'non',
                              controllerComment.text,0
                          );
                          if(result.result["status"] == 'Ok'){
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            debtBloc.getDebt(date,'');
                            bannerBloc.getBanner();
                            walletBloc.getWallet();
                          }
                          else{
                            final snackBar = SnackBar(
                              /// need to set following properties for best effect of awesome_snackbar_content
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              behavior: SnackBarBehavior.floating,
                              dismissDirection: DismissDirection.down,
                              content: AwesomeSnackbarContent(
                                title: "Xatolik",
                                message: result.result["status"],
                                contentType: ContentType.failure,
                                inMaterialBanner: false,
                              ),
                            );
                            ScaffoldMessenger.of(context)..hideCurrentMaterialBanner()..showSnackBar(snackBar);
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
                              title: "Xatolik",
                              message: "Xamyonda mablag yetarli emas",
                              contentType: ContentType.failure,
                              inMaterialBanner: false,
                            ),
                          );
                          ScaffoldMessenger.of(context)..hideCurrentMaterialBanner()..showSnackBar(snackBar);
                        }
                      }),
                )
              ],
            ),
            const SizedBox(height: 32,),
          ],
        )
    );
  }
  var date = DateFormat('yyyy-MM').format(DateTime.now());

}
