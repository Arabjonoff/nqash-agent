import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/model/wallet/wallet_model.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:naqsh_agent/src/ui/bottom_menu/bottom_menu_screen.dart';

class WalletCardWidget extends StatelessWidget {
  final WalletModel data;
  final Function() onTap;
  final Function() delete;
  final String bg;
  const WalletCardWidget({Key? key, required this.onTap, required this.data, required this.bg, required this.delete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 7.5),
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // gradient: const LinearGradient(
          //   colors: [ Color(0xFF885DF5),Color(0xFF5F6DF8),],
          //   begin: Alignment.bottomLeft,
          //   end: Alignment.topRight,
          // ),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: bg == ""?const AssetImage(
              'assets/icons/002.png',
            ):AssetImage(
              bg,
            )
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:   [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(data.name,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 20,color: AppTheme.white),),
                IconButton(onPressed: delete, icon: const Icon(Icons.delete_forever,color: Colors.red,))
              ],
            ),
            const SizedBox(height: 35,),
            Text('allBalanceWallet'.tr(),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 10,color: AppTheme.white),),
            const SizedBox(height: 5,),
            Text(priceFormat.format(data.balans).toString() ,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 30,color: AppTheme.white),),
            const SizedBox(height: 15,),
            Text("walletType".tr() +': ${data.valyuteType}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12,color: AppTheme.white),),
          ],
        ),
      ),
    );
  }
}
