import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:naqsh_agent/src/model/http_result.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:naqsh_agent/src/widget/textfield/textfield_widget.dart';

import '../../../theme/app_theme.dart';
import '../../../utils/formatter/phone_number_format.dart';
import '../../../utils/utils.dart';
import '../../../widget/button/ontap_widget.dart';
import '../../../widget/pop/pop_widget.dart';




// ignore: must_be_immutable
class RegisterScreen extends StatefulWidget {
   const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PhoneNumberTextInputFormatter _phoneNumber = PhoneNumberTextInputFormatter();

   bool loading = false;


   TextEditingController nameController = TextEditingController();

  TextEditingController surnameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = Utils.getWidth(context);
    double h = Utils.getHeight(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SvgPicture.asset('assets/icons/vvv.svg',fit: BoxFit.cover),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0 * w,top: 19*h,bottom: 47*h),
                    child: NavigatorPop(context),
                  ),
                  Center(
                      child: Text(
                        'register'.tr(),
                        style: TextStyle(
                          fontSize: 30 * w,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 58.0*w,vertical: 15*h),
                      child: Text(
                        'registerTitle'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18 * w,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  TextFieldWidget(controller: nameController, icon: 'assets/icons/profile.svg', hint: 'Ism'),
                  TextFieldWidget(controller: surnameController, icon: 'assets/icons/profile.svg', hint: 'Familya'),
                  SizedBox(height: 10*h,),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 20 * w,),
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
                      Padding(
                        padding:  EdgeInsets.all(15.0*h),
                        child: SvgPicture.asset('assets/icons/call.svg'),
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
                            inputFormatters: [
                              maskFormatter
                            ],
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(fontSize: 18 * w),
                            decoration: const InputDecoration(
                                counterText: '', border: InputBorder.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 220*h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'registerText1'.tr(),
                        style: TextStyle(fontSize: 14 * w),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'login'.tr(),
                          style: TextStyle(
                            color: AppTheme.purple, fontSize: 14 * w,
                          ),
                        ),),
                    ],
                  ),
                  SizedBox(height: 30*h,),
                  OnTapWidget(
                    loading: loading,
                    title: 'loginOnTap'.tr(),
                    onTap: (){
                      if(nameController.text.isNotEmpty&&surnameController.text.isNotEmpty&&phoneController.text.isNotEmpty){
                        senData(nameController.text, surnameController.text, '+998${phoneController.text.replaceAll(" ","")}',context);
                      }
                      else{
                        final snackBar = SnackBar(
                          /// need to set following properties for best effect of awesome_snackbar_content
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          behavior: SnackBarBehavior.floating,
                          dismissDirection: DismissDirection.horizontal,
                          content: AwesomeSnackbarContent(
                            title: 'Error',
                            message: "errorRegister".tr(),
                            contentType: ContentType.failure,
                            inMaterialBanner: false,
                          ),
                        );
                        ScaffoldMessenger.of(context)..hideCurrentMaterialBanner()..showSnackBar(snackBar);
                      }
                    }
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  var maskFormatter =  MaskTextInputFormatter(
      mask: '## ### ## ##',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );

  senData(String name,surname,phone ,context)async{
    print(phone);
    setState(() => loading = true);
     Repository _repository = Repository();
    HttpResult response = await _repository.register(name, surname, phone);
    if(response.result["status"] == 'ok'){
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
          title: 'Xatolik',
          message: 'Bu raqam avval ro\'yhatdan o\'tgan',
          contentType: ContentType.failure,
          inMaterialBanner: false,
        ),
      );
      ScaffoldMessenger.of(context)..hideCurrentMaterialBanner()..showSnackBar(snackBar);
    }

  }
}
