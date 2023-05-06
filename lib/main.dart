import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:naqsh_agent/src/router/routers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token = preferences.getString('token')??"";
  runApp(
    EasyLocalization(
      saveLocale: true,
      supportedLocales: const [
        Locale('uz'),
        Locale('en'),
        Locale('ru'),
      ],
      path: 'assets/i18n',child:  NaqshApp(token: token,),
      startLocale: Locale('uz'),
    ),);
}

class NaqshApp extends StatelessWidget {
  final String token;
   NaqshApp({super.key, required this.token});
  final _route = RouterGenerator();


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Naqsh Agent',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: token.isEmpty?'/lang':'/bottomMenu',
      // initialRoute:'/register',
      onGenerateRoute: _route.onGenerator,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // home: BottomMenuScreen(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
          child: child!,
        );
      },
    );
  }
}

