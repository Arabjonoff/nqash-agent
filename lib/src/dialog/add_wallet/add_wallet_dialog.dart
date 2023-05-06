// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:naqsh_agent/src/model/http_result.dart';
// import 'package:naqsh_agent/src/provider/repository.dart';
// import 'package:naqsh_agent/src/theme/app_theme.dart';
// import 'package:naqsh_agent/src/widget/button/ontap_widget.dart';
// import 'package:naqsh_agent/src/widget/textfield/textfield_widget.dart';
//
// import '../../utils/utils.dart';
//
// class AddWalletDialog {
//   static void showAddWalletDialog(BuildContext context) {
//     TextEditingController cardController = TextEditingController();
//     TextEditingController vayluteController = TextEditingController();
//     TextEditingController balansController = TextEditingController();
//     double h = Utils.getHeight(context);
//     double w = Utils.getWidth(context);
//     final List<String> items = [
//       'sum',
//       'dollar',
//     ];
//     String? selectedValue;
//     showModalBottomSheet(
//         backgroundColor: Colors.transparent,
//         isScrollControlled: true,
//         context: context,
//         builder: (context) {
//           return StatefulBuilder(builder: (context, setState) {
//             bool animate = false;
//             return Container(
//               height: 632 * h,
//               decoration: const BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(30),
//                     topLeft: Radius.circular(30)),
//                 color: AppTheme.background,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.all(30.0 * h),
//                     child: Text(
//                       'Hamyon qo‘shish',
//                       style: TextStyle(
//                           fontSize: 30,
//                           fontWeight: FontWeight.w700,
//                           color: Colors.black),
//                     ),
//                   ),
//                  // ignore: dead_code
//                  if (animate) Container() else Column(
//                    children: [
//                      TextFieldWidget(
//                        controller: cardController,
//                        icon: 'assets/icons/wallet.svg',
//                        hint: 'Karta nomi',
//                      ),
//                      Container(
//                        padding:  EdgeInsets.symmetric(horizontal: 25*w),
//                        height: 47,
//                        margin:  EdgeInsets.symmetric(horizontal: 16*w,vertical: 10),
//                        decoration: BoxDecoration(
//                            color: Colors.white,
//                            borderRadius: BorderRadius.circular(10)),
//                        width: MediaQuery.of(context).size.width,
//                        child: Row(
//                          children: [
//                            SvgPicture.asset('assets/icons/sum.svg'),
//                            Expanded(
//                              child: DropdownButtonHideUnderline(
//                                child: DropdownButton2(
//                                    hint: Text('Valyuta turi'),
//                                    isExpanded: true,
//                                    items: items
//                                        .map((item) => DropdownMenuItem<String>(
//                                      value: item,
//                                      child: Text(
//                                        item,
//                                        style: const TextStyle(
//                                          fontSize: 14,
//                                          fontWeight: FontWeight.w500,
//                                          color: Colors.black,
//                                        ),
//                                        overflow: TextOverflow.ellipsis,
//                                      ),
//                                    ))
//                                        .toList(),
//                                    value: selectedValue,
//                                    onChanged: (value) {
//                                      setState(() {
//                                        selectedValue = value as String;
//                                      });
//                                    }),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                      TextFieldWidget(
//                        controller: balansController,
//                        icon: 'assets/icons/receipt.svg',
//                        hint: 'Qoldiq',
//                      ),
//                      Container(
//                        height: 200,
//                        color: Colors.purple,
//                        width: 100,
//                      )
//                    ],
//                  ),
//                   const Spacer(),
//                   OnTapWidget(title: 'Hamyon qo‘shish', onTap: () async{
//                     Repository repository = Repository();
//                     HttpResult response = await repository.addWallet(cardController.text, selectedValue, balansController.text);
//                     if(response.result["status"] == 'Ok'){
//                       repository.getWallet();
//                       Navigator.pop(context);
//                     }
//                     else{
//                       final snackBar = SnackBar(
//                         /// need to set following properties for best effect of awesome_snackbar_content
//                         elevation: 0,
//                         backgroundColor: Colors.transparent,
//                         behavior: SnackBarBehavior.floating,
//                         dismissDirection: DismissDirection.down,
//                         content: AwesomeSnackbarContent(
//                           title: "Xatolik",
//                           message: "Nimadur xato qaytadan urinib koring",
//                           contentType: ContentType.failure,
//                           inMaterialBanner: false,
//                         ),
//                       );
//                       ScaffoldMessenger.of(context)..hideCurrentMaterialBanner()..showSnackBar(snackBar);
//                     }
//
//                   }),
//                   SizedBox(
//                     height: 32 * w,
//                   )
//                 ],
//               ),
//             );
//           });
//         });
//   }
// }
