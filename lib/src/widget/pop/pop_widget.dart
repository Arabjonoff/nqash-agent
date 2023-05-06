import 'package:flutter/material.dart';

Widget NavigatorPop(context){
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0),),
    elevation: 4,
    child: IconButton(onPressed: () =>Navigator.pop(context),icon: const Icon(Icons.arrow_back_ios_new_outlined,color: Colors.black,),),
  );
}