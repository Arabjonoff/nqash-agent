import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:naqsh_agent/src/utils/utils.dart';

class MenuCardWidget extends StatelessWidget {
  final String image;
  final String name;
  final Function() onTap;
  final EdgeInsets margin;

  const MenuCardWidget({Key? key, required this.image, required this.onTap, required this.margin, required this.name,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = Utils.getHeight(context);
    double w = Utils.getWidth(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppTheme.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 15,
              offset: Offset(4, 15),
              color: Color.fromRGBO(0, 0, 0, 0.1),
            )
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding:  EdgeInsets.all(20.0*h),
              child: Image.asset(image,width: 50*w,),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(vertical: 10*h),
              child: Text(name),
            ),
          ],
        ),
      ),
    );
  }
}
