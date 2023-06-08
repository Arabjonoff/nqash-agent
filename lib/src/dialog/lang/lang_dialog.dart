import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';

class ShowBottomLanguageDialog{
  static void showLangDialog(BuildContext context){
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context, builder: (context){
      return Card(
        color: AppTheme.background,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20))
        ),
        child: SizedBox(
          height: 450,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  width: MediaQuery.of(context).size.width /4,
                  height: 5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.grey
                  ),
                ),
                const SizedBox(height: 24,),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  elevation: 0,
                  child: ListTile(
                    onTap: (){
                      context.setLocale(const Locale('uz',));
                      Navigator.pop(context);
                    },
                    leading: Image.asset('assets/icons/uz.png'),
                    title: const Text("O'zbek (lotin)"),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  elevation: 0,
                  child: ListTile(
                    onTap: (){
                      context.setLocale(const Locale('en',));
                      Navigator.pop(context);
                    },
                    leading: Image.asset('assets/icons/uz.png'),
                    title: const Text("Ўзбек (Кирил)"),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  elevation: 0,
                  child: ListTile(
                    onTap: (){
                      context.setLocale(const Locale('ru',));
                      Navigator.pop(context);
                    },
                      leading: Image.asset('assets/icons/ru.png'),
                    title: const Text("Русский"),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  elevation: 0,
                  child: ListTile(
                    onTap: (){
                      // context.setLocale(const Locale('ru',));
                      Navigator.pop(context);
                    },
                    leading: Image.asset('assets/icons/en.png'),
                    title: const Text("English"),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  elevation: 0,
                  child: ListTile(
                    onTap: (){
                      // context.setLocale(const Locale('ru',));
                      Navigator.pop(context);
                    },
                    leading: Image.asset('assets/icons/turk.png'),
                    title: const Text("Turkey"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}