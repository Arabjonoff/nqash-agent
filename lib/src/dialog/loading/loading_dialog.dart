import 'package:flutter/material.dart';

class LoadingDialog{
  static void showLoadingDialog(BuildContext context,String body ,bool success){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Row(
          children:  [
            success?const Icon(Icons.done_rounded):const CircularProgressIndicator.adaptive(),
            const SizedBox(width: 20,),
            Text(body),
          ],
        ),
      );
    });
  }
}