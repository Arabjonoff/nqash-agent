import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:naqsh_agent/src/model/http_result.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:naqsh_agent/src/utils/utils.dart';
import 'package:naqsh_agent/src/widget/textfield/textfield_widget.dart';

import '../../bloc/course/course_bloc.dart';
import '../../provider/repository.dart';

class AddValyuteDialog {
  static void showAddValyuteDialog(BuildContext context) {
    var data = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
              title: Text('Kurs qoshish'),
              content: SizedBox(
                height: 150 * h,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                          onTap: () {
                            DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              minTime: DateTime(2022, 01, 01),
                              maxTime: DateTime.now(),
                              onConfirm: (date) {
                                data = DateFormat('yyyy-MM-dd').format(date);
                                setState(() {});
                              },
                            );
                          },
                          child: TextFieldWidget(
                            horizontal: true,
                            controller: TextEditingController(),
                            icon: 'assets/icons/calendar.svg',
                            hint: data,
                            enables: false,
                          )),
                      TextFieldWidget(
                        horizontal: true,
                        controller: controller,
                        icon: 'assets/icons/money.svg',
                        hint: 'Kursni kiriting',
                        type: true,
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
                    child: Text('Bekor qilish')),
                TextButton(
                    onPressed: () async {
                      HttpResult res = await repository.courseAdd(
                          '${data}T10:00', int.parse(controller.text.replaceAll(",", "")));
                      if (res.result['status'] == 'Ok') {
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        courseBloc.getCourse();
                      }
                    },
                    child: Text('Qoshish')),
              ],
            );
          });
        });
  }
}
