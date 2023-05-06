import 'package:flutter/material.dart';

class ShowAlertDialog{
  static void showAlertDialog(BuildContext context,String title ,body,Function() onTap){
    showDialog(context: context, builder: (BuildContext context) {
      return  AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),),
        title: Text(title),           // To display the title it is optional
        content: Text(body),   // Message which will be pop up on the screen
        // Action widget which will provide the user to acknowledge the choice
        actions: [
          TextButton(                     // FlatButton widget is used to make a text to work like a button
            onPressed: () {
              Navigator.pop(context);
            },             // function used to perform after pressing the button
            child: Text('Yoq'),
          ),
          TextButton(
            onPressed: onTap,
            child: Text('Ha'),
          ),
        ],
      );
    });
  }
}