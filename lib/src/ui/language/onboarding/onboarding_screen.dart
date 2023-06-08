import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:naqsh_agent/src/widget/button/ontap_widget.dart';

import '../../../utils/utils.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = Utils.getWidth(context);
    double h = Utils.getHeight(context);
    return Scaffold(
      body: SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0 * w,top: 19*h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('welcome'.tr(),style: TextStyle(fontSize: 30*w,fontWeight: FontWeight.w700,),),
                        ],
                      ),
                    ),
                    SizedBox(height: 15*h,),
                    Text('onBoarding'.tr(),textAlign: TextAlign.center,style: TextStyle(fontSize: 18*w),),
                    Padding(
                      padding:EdgeInsets.only(top: 73.0*h,bottom: 103*h),
                      child: Image.asset('assets/icons/onboarding.png',width: 200*h,),
                    ),
                    OnTapWidget(title: 'login'.tr(), onTap: ()=>Navigator.pushNamed(context, '/login'),),
                    SizedBox(height: 15*h,),
                    TextButton(onPressed: (){
                      Navigator.pushNamed(context, '/register');
                    }, child: Text('register'.tr(),style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20*h,color: AppTheme.black24),))
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
