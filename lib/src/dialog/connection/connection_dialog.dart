import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/bloc/income/income_bloc.dart';

class ConnectionDialog{
  static void showConnectionDialog(BuildContext context,String msg){
    showDialog(context: context, builder: (context){

      return CupertinoAlertDialog(
        title: Text('Xatolik'),
        content: Text(msg),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Ok'))
        ],
      );
    });
  }
}