
import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';

import '../../utils/utils.dart';

class KeyboardNumberWidget extends StatelessWidget {
  final int n;
  final Function() onPressed;
  const KeyboardNumberWidget({Key? key, required this.n, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = Utils.getHeight(context);
    double w = Utils.getWidth(context);
    return Container(
      width: 100*h,
      height: 100*h,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: MaterialButton(
        padding: EdgeInsets.all(8*w),
        onPressed: onPressed,
        height: 90*h,
        child: Text("$n",textAlign: TextAlign.center,style: TextStyle(
          fontSize: 30*MediaQuery.of(context).textScaleFactor,
          color: AppTheme.black24,
          fontWeight: FontWeight.bold,
        ),),
      ),
    );
  }
}
