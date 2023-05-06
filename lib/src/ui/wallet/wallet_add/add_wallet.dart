import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naqsh_agent/src/bloc/wallet/wallet_bloc.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';

import '../../../model/http_result.dart';
import '../../../provider/repository.dart';
import '../../../utils/utils.dart';
import '../../../widget/button/ontap_widget.dart';
import '../../../widget/textfield/textfield_widget.dart';

class WalletAddScreen extends StatefulWidget {
  const WalletAddScreen({Key? key}) : super(key: key);

  @override
  State<WalletAddScreen> createState() => _WalletAddScreenState();
}

class _WalletAddScreenState extends State<WalletAddScreen> {
  TextEditingController cardController = TextEditingController();
  TextEditingController vayluteController = TextEditingController();
  TextEditingController balansController = TextEditingController();

  final List<String> items = [
    'sum',
    'dollar',
  ];
  String selectedValue = 'sum';

  List<String> bg = [
    'assets/icons/000.png',
    'assets/icons/001.png',
    'assets/icons/002.png',
    'assets/icons/004.png',
    'assets/icons/005.png',
    'assets/icons/006.png',
  ];
  String selectBg = 'assets/icons/002.png';
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    double h = Utils.getHeight(context);
    double w = Utils.getWidth(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        elevation: 5,
        foregroundColor: AppTheme.black24,
        backgroundColor: AppTheme.white,
        centerTitle: true,
        title:  Text(
          'addWallet'.tr(),
          style: const TextStyle(
              fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20))),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                SizedBox(height: 16*h,),
                TextFieldWidget(
                  controller: cardController,
                  icon: 'assets/icons/wallet.svg',
                  hint: 'walletName'.tr(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 25 * w),
                  height: 47,
                  margin: EdgeInsets.symmetric(horizontal: 16 * w, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/sum.svg'),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                              hint: Text('sum'),
                              isExpanded: true,
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                                  .toList(),
                              value: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value as String;
                                });
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
                TextFieldWidget(
                  inputFormatter: true,
                  type: true,
                  controller: balansController,
                  icon: 'assets/icons/receipt.svg',
                  hint: 'residual'.tr(),
                ),
                 Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text('walletView'.tr(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                      itemCount: bg.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              selectBg = bg[index];
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 16*w),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(bg[index],fit: BoxFit.cover,)),
                          ),
                        );
                      }),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30*h,vertical: 30*h),
                  margin: EdgeInsets.symmetric(horizontal: 16 * w, vertical: 16 * h),
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(selectBg)
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
          OnTapWidget(loading:_loading,title: 'addWallet'.tr(), onTap: () async{
            setState(() => _loading = true);

            try{
              Repository repository = Repository();
              HttpResult response = await repository.addWallet(cardController.text, selectedValue, balansController.text.isEmpty?0:int.parse(balansController.text.replaceAll(",", "")),selectBg);
              if(response.result["status"] == 'Ok'){
                setState(() => _loading = false);
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
                walletBloc.getWallet();
              }
              else{
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
                ScaffoldMessenger.of(context)..hideCurrentMaterialBanner()..showSnackBar(snackBar);
              }
            }catch(_){
              print(_);
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
              ScaffoldMessenger.of(context)..hideCurrentMaterialBanner()..showSnackBar(snackBar);
            }

          },),
          SizedBox(height: 32*h,)
        ],
      ),
    );
  }
}
