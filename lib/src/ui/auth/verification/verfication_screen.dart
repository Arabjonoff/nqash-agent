import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../model/http_result.dart';
import '../../../provider/repository.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/utils.dart';
import '../../../widget/button/ontap_widget.dart';
import '../../../widget/pop/pop_widget.dart';

class VerficationScreen extends StatefulWidget {
  final String phone;
   const VerficationScreen({Key? key, required this.phone}) : super(key: key);

  @override
  State<VerficationScreen> createState() => _VerficationScreenState();
}

class _VerficationScreenState extends State<VerficationScreen> {
  TextEditingController controller = TextEditingController();

   bool loading = false;

  Widget build(BuildContext context) {
    double w = Utils.getWidth(context);
    double h = Utils.getHeight(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SvgPicture.asset('assets/icons/vvv.svg',fit: BoxFit.cover),
          SafeArea(
            child: Column(
              children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0 * w, bottom: 47 * h,top: 19*h),
                      child: NavigatorPop(context),
                    ),
                    Center(
                      child: Text(
                        'verification1'.tr(),
                        style: TextStyle(
                          fontSize: 30 * w,
                          fontWeight: FontWeight.w700,
                        ),
                      ),),
                    SizedBox(height: 15*w,),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 58.0*w),
                        child: Text(
                          "${widget.phone}  ${"verfication".tr()}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18 * w,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30*w,),
                    Center(
                      child: Pinput(
                        controller: controller,
                        showCursor: true,
                        length: 5,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        submittedPinTheme: submittedPinTheme,
                      ),
                    ),

                    SizedBox(
                      height: 366 * h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'verficationTitle'.tr(),
                          style: TextStyle(fontSize: 14 * w),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Text(
                            'restart'.tr(),
                            style: TextStyle(
                              color: AppTheme.purple, fontSize: 14 * w,
                            ),
                          ),),
                      ],
                    ),
                  ],
                ),),
                OnTapWidget(
                  loading: loading,
                  title: 'loginOnTap'.tr(),
                  onTap: () => senData(widget.phone, controller.text, context)
                ),
                const SizedBox(height: 20,)
              ],
            )
          )
        ],
      ),
    );
  }
  senData(phone ,code,context)async{
    setState(() => loading = true);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Repository _repository = Repository();
    HttpResult response = await _repository.activate(phone,code);
    print(code);
    if(response.result["status"] =="ok"){
      var y = response.result["register_date"];
      var m = response.result["register_date"];
      preferences.setInt('year', int.parse(y.substring(0,4)));
      preferences.setInt('month', int.parse(m.substring(5,6)));
      setState(() => loading = false);
      preferences.setString('token', response.result["token"].toString());
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, '/bottomMenu',);
      // Navigator.pushNamed(context, '/verfication',arguments: phone);
    }
    else{
      setState(() => loading = false);
      final snackBar = SnackBar(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        backgroundColor: Colors.transparent,
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.down,
        content: AwesomeSnackbarContent(
          title: "Error",
          message: "errorVerification".tr(),
          contentType: ContentType.failure,
          inMaterialBanner: false,
        ),
      );
      ScaffoldMessenger.of(context)..hideCurrentMaterialBanner()..showSnackBar(snackBar);
    }

  }
}





final defaultPinTheme = PinTheme(
  width: 50,
  height: 50,
  textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 24,
  ),
  decoration: BoxDecoration(
    boxShadow: const [
      BoxShadow(
          color: Color.fromRGBO(255, 255, 255, 0.1),
          offset: Offset(0,4)
      )
    ],
    color: AppTheme.white,
    borderRadius: BorderRadius.circular(10),
  ),
);
final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
  borderRadius: BorderRadius.circular(8),
);

final submittedPinTheme = defaultPinTheme.copyWith(
  decoration: defaultPinTheme.decoration?.copyWith(
    color: AppTheme.purple,
  ),
);

