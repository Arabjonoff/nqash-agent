// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/dialog/alert/alert_dialog.dart';
import 'package:naqsh_agent/src/model/profile/profile_model.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:naqsh_agent/src/ui/bottom_menu/profile/app_about/about_screen.dart';
import 'package:naqsh_agent/src/utils/utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../dialog/lang/lang_dialog.dart';
import '../../webview/webviev_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    profileBloc.getProfile();
  }

  final Uri _urlTg = Uri.parse('https://t.me/naqshsoft_uz');
  final Uri _urlFc = Uri.parse('https://t.me/naqshsoft_uz');
  final Uri _urlWeb = Uri.parse('https://t.me/naqshsoft_uz');

  Future<void> _launchUrl() async {
    if (await launchUrl(_urlTg)) {
      throw Exception('Could not launch $_urlTg');
    }
  }
  Future<void> _launchUrlFc() async {
    if (await launchUrl(_urlFc)) {
      throw Exception('Could not launch $_urlFc');
    }
  }
  Future<void> _launchUrlWeb() async {
    if (await launchUrl(_urlWeb)) {
      throw Exception('Could not launch $_urlWeb');
    }
  }
  @override
  Widget build(BuildContext context) {
    double w = Utils.getWidth(context);
    double h = Utils.getHeight(context);
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        elevation: 5,
        foregroundColor: AppTheme.black24,
        backgroundColor: AppTheme.white,
        centerTitle: true,
        title:  Text(
          'profile'.tr(),
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<ProfileModel>(
              stream: profileBloc.getProfiles,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  Data? data = snapshot.data!.data;
                  return Container(
                    padding: EdgeInsets.all(20*w),
                    margin: EdgeInsets.symmetric(horizontal: 20*w,vertical: 20*h),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppTheme.purple,
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 60*h,
                          height: 60*h,
                          child:  CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Center(child: data!.name!.isEmpty?const Text('none'):Text(data.name![0].toString(),style: TextStyle(color: AppTheme.purple,fontSize: 25*h))),
                          ),
                        ),
                        Expanded(child: Padding(
                          padding:  EdgeInsets.only(left: 20.0*w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data.name.toString(),style: TextStyle(color: AppTheme.white,fontSize: 20*h),),
                              Text(data.phone.toString(),style: TextStyle(color: AppTheme.white,fontSize: 15*h)),
                            ],
                          ),
                        ))
                      ],
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator.adaptive());
              }
            ),
            SizedBox(
              height: 10 * h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(width: 20*w,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppTheme.white
                    ),
                    child: IconButton(onPressed: (){
                      _launchUrl();
                    },icon: Icon(Icons.telegram),),
                  ),
                ),
                SizedBox(width: 20*w,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppTheme.white
                    ),
                    child: IconButton(onPressed: (){
                      _launchUrlFc();
                    },icon: Icon(Icons.facebook),),
                  ),
                ),
                SizedBox(width: 20*w,),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppTheme.white
                    ),
                    child: IconButton(onPressed: (){
                      _launchUrlWeb();
                    },icon: Icon(Icons.language),),
                  ),
                ),
                SizedBox(width: 20*w,),
              ],
            ),
            SizedBox(
              height: 25 * h,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20*w),
              decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: ListTile(
                leading: Icon(
                  Icons.language,
                  color: AppTheme.purple,
                ),
                onTap: () {
                  ShowBottomLanguageDialog.showLangDialog(context);
                },
                title: Text('changeLang'.tr()),
              ),
            ),
            SizedBox(height: 10*h,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20*w),
              decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: ListTile(
                leading: Icon(
                  Icons.list_alt_rounded,
                  color: AppTheme.purple,
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const AboutScreen();
                  }));
                },
                title: Text('about'.tr()),
              ),
            ),
            SizedBox(height: 10*h,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20*w),
              decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.message,
                  color: AppTheme.purple,
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){return WebViewScreen();}));
                },
                title: Text('call'.tr()),
              ),
            ),
            SizedBox(height: 10*h,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20*w),
              decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.share,
                  color: AppTheme.purple,
                ),
                onTap: () {
                  Share.share('https://play.google.com/store/apps/details?id=uz.naqshsoft.naqsh_client&hl=uz&gl=US');
                },
                title: Text('share'.tr()),
              ),
            ),
            SizedBox(height: 10*h,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20*w),
              decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: AppTheme.purple,
                ),
                onTap: () {
                  ShowAlertDialog.showAlertDialog(
                    context,
                    'logOut'.tr(),
                    'deleteOk'.tr(),
                    () async {
                      SharedPreferences preferences = await SharedPreferences.getInstance();
                      preferences.remove('token');
                      preferences.remove('walletName');
                      preferences.remove('walletType');
                      preferences.remove('walletId');
                      preferences.remove('dollar');
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushReplacementNamed(context, '/lang');
                    },
                  );
                },
                title: Text('logOut'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }




}
