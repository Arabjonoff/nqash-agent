import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/bloc/wallet/wallet_bloc.dart';
import 'package:naqsh_agent/src/dialog/alert/alert_dialog.dart';
import 'package:naqsh_agent/src/model/http_result.dart';
import 'package:naqsh_agent/src/model/wallet/wallet_model.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:naqsh_agent/src/ui/wallet/wallet_add/add_wallet.dart';
import 'package:naqsh_agent/src/widget/button/ontap_widget.dart';
import 'package:naqsh_agent/src/widget/card/wallet_card/wallet_card_widget.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {


  @override
  void initState() {
    walletBloc.getWallet();
    super.initState();
  }
  @override
  void dispose() {
    walletBloc.getWallet();
    super.dispose();
  }
  final Repository _repository = Repository();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        foregroundColor: AppTheme.black24,
        backgroundColor: AppTheme.white,
        centerTitle: true,
        title: const Text(
          'Hamyonlar',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
      ),
      backgroundColor: AppTheme.background,
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<WalletModel>>(
              stream: walletBloc.getWalletInfo,
              builder: (context, snapshot) {
               if(snapshot.hasData){
                 List<WalletModel> data = snapshot.data!;
                 return data.isNotEmpty? ListView.builder(
                   itemCount: data.length,
                   itemBuilder: (context, index) {
                     return WalletCardWidget(
                       onTap: () async{
                         Navigator.pushNamed(context, '/wallet_history',arguments: data[index]);
                       }, data: data[index], bg: data[index].bg,
                       delete: ()  async{

                         ShowAlertDialog.showAlertDialog(context,'Ogohlantirish','Rostanham ochirmoqchimisz', ()async{
                           HttpResult res = await _repository.deleteWallet(data[index].id);
                           if(res.result["status"] == "ok"){
                             // ignore: use_build_context_synchronously
                             Navigator.pop(context);
                             walletBloc.getWallet();
                           }
                         });
                       },
                     );
                   },
                 ):const Center(child: Text('Sizda hamyonlar yoq'));
               }
               return  Container(
                 width: MediaQuery.of(context).size.width,
                 height: MediaQuery.of(context).size.height,
                 child: Center(
                   child: Container(
                     width: 100,
                     height: 100,
                     decoration: BoxDecoration(
                         color: Colors.white,
                         borderRadius: BorderRadius.circular(10)
                     ),
                     child: const Center(
                       child: CircularProgressIndicator.adaptive(),
                     ),
                   ),
                 ),
               );
              }
            ),
          ),
          OnTapWidget(
              title: 'Hamyon qo‘shish',
              onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context){
               return WalletAddScreen();
             }));
              }),
          SizedBox(
            height: 32,
          )
        ],
      ),
    );
  }
}

