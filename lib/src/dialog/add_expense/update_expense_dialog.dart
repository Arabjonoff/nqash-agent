import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/bloc/cost/cost_bloc.dart';
import 'package:naqsh_agent/src/model/http_result.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:naqsh_agent/src/widget/textfield/textfield_widget.dart';
import '../../model/cost/cost_model.dart';
import '../../utils/utils.dart';

class UpdateExpenseDialog{
  static void updateExpenseDialog(BuildContext context,Datum costGetModel){
    TextEditingController controller = TextEditingController(text: costGetModel.name);
    Repository repository = Repository();
    double h = Utils.getHeight(context);
    double w = Utils.getWidth(context);
    showDialog(context: context, builder: (context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: AppTheme.background,
        title: Text('Xarajat turini qoshish'),
        content: TextFieldWidget(controller: controller, icon: 'assets/icons/category.svg', hint: 'Harajat turini kiriting',horizontal: true,),
        actions: [
          TextButton(onPressed: (){}, child: Text('Orqaga')),
          TextButton(onPressed: ()async{
            HttpResult res = await repository.updateCost(costGetModel.id,controller.text);
            if(res.result["status"] == 'ok'){
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
              costBloc.getCosts();
            }
          }, child: Text('Ozgartirish')),
        ],
      );
    });
  }
}