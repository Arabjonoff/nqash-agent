import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/model/wallet/wallet_model.dart';
import 'package:naqsh_agent/src/ui/agent/agent_screen.dart';
import 'package:naqsh_agent/src/ui/auth/register/register_screen.dart';
import 'package:naqsh_agent/src/ui/auth/verification/verfication_screen.dart';
import 'package:naqsh_agent/src/ui/bottom_menu/bottom_menu_screen.dart';
import 'package:naqsh_agent/src/ui/bottom_menu/profile/profile.dart';
import 'package:naqsh_agent/src/ui/debt/debt_screen.dart';
import 'package:naqsh_agent/src/ui/expense/expense_screen.dart';
import 'package:naqsh_agent/src/ui/income/add_income_screen.dart';
import 'package:naqsh_agent/src/ui/income/income_screen.dart';
import 'package:naqsh_agent/src/ui/language/onboarding/onboarding_screen.dart';
import 'package:naqsh_agent/src/ui/wallet/wallet_history/wallet_history_screen.dart';
import 'package:naqsh_agent/src/ui/wallet/wallet_screen.dart';
import '../ui/auth/login/login_screen.dart';
import '../ui/debt/add_debt_screen.dart';
import '../ui/language/language_screen.dart';
import '../ui/lock/lock_screen.dart';

class RouterGenerator {
  Route? onGenerator(RouteSettings settings) {
    var args = settings.arguments;
    switch (settings.name) {
      case '/lang':
        return _navigate(const LanguageScreen());

      case '/login':
        return _navigate(LoginScreen());

      case '/boarding':
        return _navigate(const OnBoardingScreen());

      case '/register':
        return _navigate(RegisterScreen());

      case '/verfication':
        return _navigate(VerficationScreen(phone: args.toString(),));

      case '/bottomMenu':
        return _navigate(const BottomMenuScreen());

      case '/wallet':
        return _navigate( WalletScreen());

      case '/wallet_history':
        return _navigate( WalletHistoryScreen(datmodel: args as WalletModel,));

      case '/income':
        return _navigate(const IncomeScreen());

      case '/add_income':
        return _navigate(const AddIncomeScreen());

      case '/debt':
        return _navigate(const DebtScreen());

      case '/add_debt':
        return _navigate(const AddDebtScreen());

      case '/expense':
        return _navigate(const ExpenseScreen());

      case '/agent':
        return _navigate(const AgentScreen());

      case '/lock':
        return _navigate( LockScreen());


      case '/profile':
        return _navigate( ProfileScreen());
    }
  }
}

_navigate(Widget screen) {
  return MaterialPageRoute(builder: (context) => screen);
}
