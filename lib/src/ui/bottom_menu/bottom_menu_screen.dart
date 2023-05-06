import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:naqsh_agent/src/ui/bottom_menu/home/home_screen.dart';
import 'package:naqsh_agent/src/ui/bottom_menu/profile/profile.dart';
import 'package:naqsh_agent/src/ui/debt/debt_screen.dart';
import 'package:naqsh_agent/src/ui/income/income_screen.dart';

import '../expense/expense_screen.dart';
final priceFormat = NumberFormat("#,##0", "ru");

class BottomMenuScreen extends StatefulWidget {
  const BottomMenuScreen({Key? key}) : super(key: key);

  @override
  State<BottomMenuScreen> createState() => _BottomMenuScreenState();
}
int _selectedIndex = 2;
// final LocalAuthentication auth = LocalAuthentication();

class _BottomMenuScreenState extends State<BottomMenuScreen> {
  @override
  void initState() {
// bio();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
         setState(() {
           _selectedIndex = index;
         });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.purple,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/profile.svg',color: _selectedIndex == 0?AppTheme.purple:null,),label: 'profile'.tr()),
          BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/receipt.svg',color: _selectedIndex == 1?AppTheme.purple:null,),label: 'expense'.tr()),
          BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/home.svg'),label: 'home'.tr()),
          BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/money.svg',color: _selectedIndex == 3?AppTheme.purple:null,),label: 'income'.tr()),
          BottomNavigationBarItem(icon: SvgPicture.asset('assets/icons/money_send.svg',color: _selectedIndex == 4?AppTheme.purple:null,),label: 'debt'.tr()),
        ],
      ),
      body:IndexedStack(
        index: _selectedIndex,
        children: const [
           ProfileScreen(),
           ExpenseScreen(),
           HomeScreen(),
           IncomeScreen(),
           DebtScreen(),
        ],
      )
    );
  }
  // bio()async{
  //   final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
  //   final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
  //
  //   final List<BiometricType> availableBiometrics =
  //   await auth.getAvailableBiometrics();
  //
  //   if (availableBiometrics.isNotEmpty) {
  //     // Some biometrics are enrolled.
  //   }
  //
  //   if (availableBiometrics.contains(BiometricType.strong) ||
  //       availableBiometrics.contains(BiometricType.face)) {
  //     // Specific types of biometrics are available.
  //     // Use checks like this with caution!
  //   }
  //   try {
  //     final bool didAuthenticate = await auth.authenticate(
  //         localizedReason: 'Please authenticate to show account balance');
  //     if(didAuthenticate == true){
  //       Navigator.pushNamed(context, '/login');
  //     }
  //     // ···
  //   } on PlatformException {
  //     // ...
  //   }
  // }

}
