import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/utils.dart';

class LanguageScreen extends StatefulWidget {
   const LanguageScreen({Key? key}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    double w = Utils.getWidth(context);
    double h = Utils.getHeight(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F4),
      body: Stack(
        children: [
          SvgPicture.asset('assets/icons/vvv.svg',fit: BoxFit.cover,),
          SafeArea(
            child: Padding(
              padding:  EdgeInsets.only(top: 100*h),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Hush kelibsiz !',style: TextStyle(fontSize: 30*w,fontWeight: FontWeight.w700,),),
                    Text('O‘zingizga maqul tilni tanlang !',textAlign: TextAlign.center,style: TextStyle(fontSize: 18*w,height: 2*h),),
                    SizedBox(height: 120*h,),
                    GestureDetector(
                      onTap: (){
                        context.setLocale(const Locale('uz',));
                        Navigator.pushNamed(context, '/boarding');
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5*h),
                          width: 200*w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/uz.png'),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('UZ',style: TextStyle(fontSize: 18*w,fontWeight: FontWeight.w600),),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20*h,),
                    GestureDetector(
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5*h),
                          width: 200*w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/ru.png'),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('RU',style: TextStyle(fontSize: 18*w,fontWeight: FontWeight.w600),),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: (){
                        context.setLocale(const Locale('ru',));
                        Navigator.pushNamed(context, '/boarding');
                      },
                    ),
                    SizedBox(height: 20*h,),
                    GestureDetector(
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5*h),
                          width: 200*w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/en.png'),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('ENG',style: TextStyle(fontSize: 18*w,fontWeight: FontWeight.w600),),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20*h,),
                    GestureDetector(
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),),
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 5*h),
                          width: 200*w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/icons/turk.png'),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('TUR',style: TextStyle(fontSize: 18*w,fontWeight: FontWeight.w600),),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20*h,),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
