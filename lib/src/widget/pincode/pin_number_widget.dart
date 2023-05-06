import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:naqsh_agent/src/utils/utils.dart';

class PINumberWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final OutlineInputBorder outlineInputBorder;
  const PINumberWidget({Key? key, required this.textEditingController, required this.outlineInputBorder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = Utils.getWidth(context);
    double h = Utils.getHeight(context);
    return SizedBox(
      width: 50*w,
      child: TextField(
        controller: textEditingController,
        enabled: false,
        obscureText: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: outlineInputBorder,
          filled: true,
          fillColor: AppTheme.background
        ),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20*w,
          color: AppTheme.black24
        ),
      ),
    );
  }
}
