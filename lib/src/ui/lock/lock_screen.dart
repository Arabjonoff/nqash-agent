import 'package:custom_pin_screen/custom_pin_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:naqsh_agent/src/widget/button/ontap_widget.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({Key? key}) : super(key: key);

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String pinCode = '';
  // final LocalAuthentication auth = LocalAuthentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset('assets/icons/vvv.svg',fit: BoxFit.cover),
          PinAuthentication(
            onChanged: (v) {
              if (kDebugMode) {
                print(v);
              }
            },
            onCompleted: (v) {
              if (kDebugMode) {

              }
            },
            actionDescription: ' Pin kodni kiriting',
            action: 'Pin Kod',
            pinTheme: PinTheme(
              inactiveFillColor: Colors.white,
              selectedFillColor: Colors.white,
              activeFillColor: AppTheme.purple,
              backgroundColor: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      )
    );
  }
// bio()async{
//   final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
//   final bool canAuthenticate = canAuthenticateWithBiometrics || await auth.isDeviceSupported();
//
//   final List<BiometricType> availableBiometrics =
//   await auth.getAvailableBiometrics();
//
//   if (availableBiometrics.isNotEmpty) {
//     // Some biometrics are enrolled.
//   }
//
//   if (availableBiometrics.contains(BiometricType.strong) ||
//       availableBiometrics.contains(BiometricType.face)) {
//     // Specific types of biometrics are available.
//     // Use checks like this with caution!
//   }
//   try {
//     final bool didAuthenticate = await auth.authenticate(
//         localizedReason: 'Please authenticate to show account balance');
//     if(didAuthenticate == true){
//       Navigator.pushNamed(context, '/login');
//     }
//     // ···
//   } on PlatformException {
//     // ...
//   }
// }
}

























// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:naqsh_agent/src/theme/app_theme.dart';
// import 'package:naqsh_agent/src/utils/utils.dart';
//
// import '../../widget/pincode/keyboard_number.dart';
// import '../../widget/pincode/pin_number_widget.dart';
//
// class LockScreen extends StatefulWidget {
//   const LockScreen({Key? key}) : super(key: key);
//
//   @override
//   State<LockScreen> createState() => _LockScreenState();
// }
//
// class _LockScreenState extends State<LockScreen> {
//   List<String> currentPin = ["", "", "", ""];
//   TextEditingController pinOneController = TextEditingController();
//   TextEditingController pinTwoController = TextEditingController();
//   TextEditingController pinThreeController = TextEditingController();
//   TextEditingController pinFourController = TextEditingController();
//
//   var outlineInputBorder = OutlineInputBorder(
//     borderSide: const BorderSide(color: Colors.transparent),
//   );
//   int pinIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     double h = Utils.getHeight(context);
//     double w = Utils.getWidth(context);
//     return Scaffold(
//       backgroundColor: AppTheme.purple,
//       body: SafeArea(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 380 * h,
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(top: 50.0 * h, left: 20 * w),
//                     child: Text(
//                       'PIN-kod ',
//                       style: TextStyle(
//                           fontSize: 35 * w,
//                           color: AppTheme.white,
//                           fontWeight: FontWeight.w700),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(top: 5.0 * h, left: 20 * w),
//                     child: Text(
//                       'PIN-kodni kiriting ',
//                       style: TextStyle(
//                           fontSize: 20 * w,
//                           color: AppTheme.white,
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 70 * h,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       PINumberWidget(
//                         textEditingController: pinOneController,
//                         outlineInputBorder: outlineInputBorder,
//                       ),
//                       SizedBox(
//                         width: 10 * w,
//                       ),
//                       PINumberWidget(
//                         textEditingController: pinTwoController,
//                         outlineInputBorder: outlineInputBorder,
//                       ),
//                       SizedBox(
//                         width: 10 * w,
//                       ),
//                       PINumberWidget(
//                         textEditingController: pinThreeController,
//                         outlineInputBorder: outlineInputBorder,
//                       ),
//                       SizedBox(
//                         width: 10 * w,
//                       ),
//                       PINumberWidget(
//                         textEditingController: pinFourController,
//                         outlineInputBorder: outlineInputBorder,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 padding: EdgeInsets.only(top: 30 * h),
//                 alignment: Alignment.bottomCenter,
//                 width: MediaQuery.of(context).size.width,
//                 decoration: const BoxDecoration(
//                     color: AppTheme.background,
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20))),
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         KeyboardNumberWidget(
//                           n: 1,
//                           onPressed: () => pinIndexSetup('1'),
//                         ),
//                         KeyboardNumberWidget(
//                           n: 2,
//                           onPressed: () => pinIndexSetup('2'),
//                         ),
//                         KeyboardNumberWidget(
//                           n: 3,
//                           onPressed: () => pinIndexSetup('3'),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         KeyboardNumberWidget(
//                           n: 4,
//                           onPressed: () => pinIndexSetup('4'),
//                         ),
//                         KeyboardNumberWidget(
//                           n: 5,
//                           onPressed: () => pinIndexSetup('5'),
//                         ),
//                         KeyboardNumberWidget(
//                           n: 6,
//                           onPressed: () => pinIndexSetup('6'),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         KeyboardNumberWidget(
//                           n: 7,
//                           onPressed: () => pinIndexSetup('7'),
//                         ),
//                         KeyboardNumberWidget(
//                           n: 8,
//                           onPressed: () => pinIndexSetup('8'),
//                         ),
//                         KeyboardNumberWidget(
//                           n: 9,
//                           onPressed: () => pinIndexSetup('9'),
//                         ),
//                       ],
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Container(
//                           width: 60 * w,
//                           child: const MaterialButton(
//                             onPressed: null,
//                           ),
//                         ),
//                         KeyboardNumberWidget(
//                           n: 0,
//                           onPressed: () => pinIndexSetup('9'),
//                         ),
//                         Container(
//                           width: 60 * w,
//                           child: MaterialButton(
//                             onPressed: () {
//                               clearPin();
//                             },
//                             height: 60 * w,
//                             child: Icon(Icons.clear),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   pinIndexSetup(String text) {
//     if (pinIndex == 0) {
//       pinIndex = 1;
//     } else if (pinIndex < 4) {
//       pinIndex++;
//     }
//     setPin(pinIndex, text);
//     currentPin[pinIndex - 1] = text;
//     String strPin = "";
//     currentPin.forEach((element) {
//       strPin += element;
//     });
//     if (pinIndex == 4) {
//       print(strPin);
//     }
//   }
//
//   setPin(int n, String text) {
//     switch (n) {
//       case 1:
//         pinOneController.text = text;
//         break;
//       case 2:
//         pinTwoController.text = text;
//         break;
//       case 3:
//         pinThreeController.text = text;
//         break;
//       case 4:
//         pinFourController.text = text;
//         break;
//     }
//   }
//
//   clearPin(){
//     if(pinIndex == 0){
//       pinIndex = 0;
//     }
//     else if(pinIndex == 4){
//       setPin(pinIndex, '');
//       currentPin[pinIndex-1] = "";
//       pinIndex --;
//     }
//     else{
//       setPin(pinIndex, '');
//       currentPin[pinIndex-1] = "";
//       pinIndex --;
//     }
//   }
// }
