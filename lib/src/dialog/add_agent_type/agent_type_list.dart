import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naqsh_agent/src/bloc/category/category_bloc.dart';

import '../../model/category/category_model.dart';

class AgentTypeListDialog{
  static void showAgentTypeListDialog(BuildContext context){
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
        context: context, builder: (context){
      return StatefulBuilder(builder: (context,setState){
        return Container(
          height: 350,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: StreamBuilder<List<CategoryModel>>(
            stream: categoryBloc.getCategory,
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        leading: SvgPicture.asset('assets/icons/profile.svg'),
                        onTap: (){
                          print('object');
                        },
                        title: Text(snapshot.data![index].name),
                        trailing: IconButton(onPressed: (){

                        },icon: const Icon(Icons.delete,color: Colors.red,),)
                      );
                    });
              }
              return Container();
            }
          ),
        );
      });
    });
  }
}