import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/bloc/serach/serach_bloc.dart';
import 'package:naqsh_agent/src/model/search/search_model.dart';
import 'package:naqsh_agent/src/utils/utils.dart';

import '../../theme/app_theme.dart';
import '../bottom_menu/bottom_menu_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      searchBloc.getSearch(controller.text);
    });
  }
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w = Utils.getWidth(context);
    double h = Utils.getHeight(context);
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          width: MediaQuery.of(context).size.width,
          height: 47*h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppTheme.white
          ),
          child: Row(
            children: [
              Expanded(child: Container(
                padding: EdgeInsets.only(left: 16*h),
                child: TextField(
                  autofocus: true,
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Qidirsh',
                    suffixIcon: Icon(Icons.search_rounded),
                    border: InputBorder.none,
                  ),
                ),
              )
              )
            ],
          ),
        ),
        shape:  const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(20),bottomLeft: Radius.circular(20))
        ),
        elevation: 0,
        foregroundColor: AppTheme.black24,
        backgroundColor: AppTheme.background,
      ),
      body: StreamBuilder<SearchModel>(
        stream: searchBloc.getSearchsss,
        builder: (context, snapshot) {
         if(snapshot.hasData){
           List<Datum> data = snapshot.data!.data;
           return ListView.builder(
             itemCount: data.length,
               itemBuilder: (context,index){
             return Container(
               padding: EdgeInsets.symmetric(vertical: 20*h,horizontal: 20*h),
               margin: EdgeInsets.symmetric(horizontal: 20*w,vertical: 10),
               width: MediaQuery.of(context).size.width,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(20),
                 color: AppTheme.white,
                 boxShadow: const [
                   BoxShadow(
                     offset: Offset(4,15),
                     blurRadius: 15,
                     color: Color.fromRGBO(0, 0, 0, 0.1),
                   ),
                 ],
               ),
               child: Column(
                 children: [
                   span('name'.tr(), data[index].name),
                   span('phone'.tr(), data[index].phone),
                   span('agentType'.tr(), data[index].category.toString()),
                   span('date'.tr(), DateFormat('yyyy/MM/dd').format(data[index].lastOperationDate!)),
                   Row(
                     children: [
                       Text('Som uzs:',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500,),),
                       const SizedBox(width: 20,),
                       Text(priceFormat.format(data[index].summaUzs).toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.green),),
                     ],
                   ),
                   const SizedBox(height: 8,),
                   Row(
                     children: [
                       Text('Som usd:',style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500,),),
                       const SizedBox(width: 20,),
                       Text(priceFormat.format(data[index].summaUsd).toString(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.green),),
                     ],
                   ),
                 ],
               ),
             );
           });
         }
         return Container();
        }
      )
    );
  }

  Widget span(String title,content){
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(title,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500,),),
        ),
        const SizedBox(width: 20,),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(content,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400,color: Colors.black.withOpacity(0.7)),),
        )
      ],
    );
  }
}
