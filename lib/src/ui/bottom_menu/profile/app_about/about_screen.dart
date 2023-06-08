import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('about'.tr()),
        foregroundColor: AppTheme.black24,
        backgroundColor: AppTheme.background,
      ),
      backgroundColor: AppTheme.background,
      body: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: Image.asset(
                    'assets/icons/logo.png',
                    width: 90,
                  )),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'N Hisob ',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Version: ${snapshot.data!.version}',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ],
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
