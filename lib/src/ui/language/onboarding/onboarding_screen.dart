import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:naqsh_agent/src/widget/button/ontap_widget.dart';

import '../../../utils/utils.dart';
import '../../../widget/pop/pop_widget.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double w = Utils.getWidth(context);
    double h = Utils.getHeight(context);
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset('assets/icons/vvv.svg',fit: BoxFit.cover,),
          SafeArea(
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
                        children: [
                          NavigatorPop(context),
                          SizedBox(width: 30*w,),
                          Text('Hush kelibsiz !',style: TextStyle(fontSize: 30*w,fontWeight: FontWeight.w700,),),
                        ],
                      ),
                    ),
                    SizedBox(height: 15*h,),
                    Text('Ilovadan foydalanish uchun ro‘yxatdan o‘ting. Avval ro‘yxatdan o‘tgan bo‘lsangiz kirish tugmasiga bosing !',textAlign: TextAlign.center,style: TextStyle(fontSize: 18*w),),
                    Padding(
                      padding:EdgeInsets.only(top: 73.0*h,bottom: 103*h),
                      child: Image.asset('assets/icons/onboarding.png',width: 200*h,),
                    ),
                    OnTapWidget(title: 'Kirish', onTap: ()=>Navigator.pushNamed(context, '/login'),),
                    SizedBox(height: 15*h,),
                    TextButton(onPressed: (){
                      Navigator.pushNamed(context, '/register');
                    }, child: Text('Ro‘yxatdan o‘tish',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 20*h,color: AppTheme.black24),))
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
