import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/bloc/cost/cost_bloc.dart';
import 'package:naqsh_agent/src/model/http_result.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:naqsh_agent/src/widget/textfield/textfield_widget.dart';
import '../../utils/utils.dart';

class AddExpenseDialog{
  static void addExpenseDialog(BuildContext context){
    TextEditingController controller = TextEditingController();
    Repository repository = Repository();
    double h = Utils.getHeight(context);
    double w = Utils.getWidth(context);
    showDialog(context: context, builder: (context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: AppTheme.background,
        title: Text('typeExpense'.tr()),
        content: TextFieldWidget(controller: controller, icon: 'assets/icons/category.svg', hint: 'enterExpense'.tr(),horizontal: true,),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('back'.tr())),
          TextButton(onPressed: ()async{
            HttpResult res = await repository.addCost(controller.text);
            if(res.result["status"] == 'Ok'){
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              costBloc.getCosts();
            }
          }, child: Text('add'.tr())),
        ],
      );
    });
  }
}