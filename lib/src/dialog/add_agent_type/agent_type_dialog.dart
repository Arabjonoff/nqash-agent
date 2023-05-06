import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/bloc/category/category_bloc.dart';
import 'package:naqsh_agent/src/model/http_result.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:naqsh_agent/src/utils/utils.dart';
import 'package:naqsh_agent/src/widget/textfield/textfield_widget.dart';

import '../../provider/repository.dart';

class AgentTypeDialog {
  static void showAddAgentTypeDialog(BuildContext context) {
    TextEditingController controller = TextEditingController();
    Repository repository = Repository();
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            double h = Utils.getHeight(context);
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),),
              backgroundColor: AppTheme.background,
              title: Text('addAgentType'.tr()),
              content: SizedBox(
                height: 100 * h,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFieldWidget(
                        horizontal: true,
                        controller: controller,
                        icon: 'assets/icons/category.svg',
                        hint: 'writeAgentType'.tr(),
                        type: false,
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('cancel'.tr())),
                TextButton(
                    onPressed: () async {
                      Repository repo = Repository();
                      HttpResult res = await repo.categoryAdd(controller.text);
                      if(res.result
                      ["status"] == 'ok'){
                        Navigator.pop(context);
                        categoryBloc.getCategories();
                      }
                    },
                    child: Text('add'.tr())),
              ],
            );
          });
        });
  }
}
