import 'package:flutter/material.dart';

class FilterDialog {
  static void showFilterDilaog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              title: Text('Saralash'),
              content: SizedBox(
                height: 200,
                child: Column(
                  children: [
                    ListTile(
                      onTap: (){},
                      title: Text('Turi boyicha'),
                      trailing: Radio(value: false, groupValue: (){}, onChanged: ( value) {  },),
                    ),
                    ListTile(
                      onTap: (){},
                      title: Text('Sana boyicha'),
                      trailing: Radio(value: false, groupValue: (){}, onChanged: ( value) {  },),
                    ),
                    ListTile(
                      onTap: (){},
                      title: Text('Narxi boyicha'),
                      trailing: Radio(value: false, groupValue: (){}, onChanged: ( value) {  },),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: (){}, child: Text('Bekor qilish'),),
                TextButton(onPressed: (){}, child: Text('Saralash'),),
              ],
            );
          },
        );
      },
    );
  }
}
