import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:naqsh_agent/src/widget/pop/pop_widget.dart';

import '../../../model/http_result.dart';
import '../../../provider/repository.dart';
import '../../../utils/formatter/phone_number_format.dart';
import '../../../utils/utils.dart';
import '../../../widget/button/ontap_widget.dart';



class LoginScreen extends StatefulWidget {
   const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PhoneNumberTextInputFormatter _phoneNumber =
  PhoneNumberTextInputFormatter();

  TextEditingController controller = TextEditingController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    double w = Utils.getWidth(context);
    double h = Utils.getHeight(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SvgPicture.asset('assets/icons/vvv.svg',fit: BoxFit.cover),
          ),
          SafeArea(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0 * w, bottom: 47 * h,top: 19*h),
                      child: NavigatorPop(context),
                    ),
                    Center(
                        child: Text(
                      'login'.tr(),
                      style: TextStyle(
                        fontSize: 30 * w,
                        fontWeight: FontWeight.w700,
                      ),
                    ),),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 58.0*w),
                        child: Text(
                          'loginTitle'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18 * h,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 20 * w, vertical: 30 * h),
                      decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(0, 4),
                                color: Color.fromRGBO(255, 255, 255, 0.1))
                          ]),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 54 * w,
                          ),
                          Text(
                            '+998',
                            style: TextStyle(
                              fontSize: 18 * w,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 10 * h),
                            height: 22 * h,
                            width: 1,
                            color: Colors.black,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: controller,
                              inputFormatters: [
                                maskFormatter
                              ],
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 18 * w),
                              decoration: const InputDecoration(
                                  counterText: '', border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 366 * h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'noAccount'.tr(),
                          style: TextStyle(fontSize: 14 * w),
                        ),
                        GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/register'),
                            child: Text(
                              'register'.tr(),
                              style: TextStyle(
                                  color: AppTheme.purple, fontSize: 14 * w,
                              ),
                            ),),
                      ],
                    ),
                    SizedBox(height: 50*h,),
                    OnTapWidget(
                      loading: loading,
                      title: 'loginOnTap'.tr(),
                      onTap: () => senData('+998${controller.text.replaceAll(" ","")}', context),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

   senData(phone ,context)async{
    setState(() => loading = true);
     Repository _repository = Repository();
     HttpResult response = await _repository.login(phone);
     if(response.result["status"] =='ok'){
       setState(() => loading = false);
       Navigator.pushNamed(context, '/verfication',arguments: phone);
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
           message: "errorLogin".tr(),
           contentType: ContentType.failure,
           inMaterialBanner: false,
         ),
       );
       ScaffoldMessenger.of(context)..hideCurrentMaterialBanner()..showSnackBar(snackBar);
     }
   }
  var maskFormatter =  MaskTextInputFormatter(
      mask: '## ### ## ##',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );
}
