import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:naqsh_agent/src/bloc/agent/agent_bloc.dart';
import 'package:naqsh_agent/src/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bloc/agent/agent_hitory_bloc.dart';
import '../../model/client/client_model.dart';
import '../../model/income/income_model.dart';
import '../../theme/app_theme.dart';
import '../bottom_menu/bottom_menu_screen.dart';

class AgentHistoryScreen extends StatefulWidget {
  final int id;
  final String name;

  const AgentHistoryScreen({Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  State<AgentHistoryScreen> createState() => _AgentHistoryScreenState();
}

class _AgentHistoryScreenState extends State<AgentHistoryScreen> {
  var date = DateFormat('yyyy-MM').format(DateTime.now());
  DateTime selected = DateTime.now();
  List<DateTime> data = [];
  String walletType = '';

  @override
  void initState() {
    _getData();
    agentHistoryBloc.getAgentHistory(widget.id,date);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double w = Utils.getWidth(context);
    double h = Utils.getHeight(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        foregroundColor: AppTheme.black24,
        backgroundColor: AppTheme.white,
        centerTitle: true,
        title: Text(
          widget.name,
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        bottom: PreferredSize(
          preferredSize:  Size.fromHeight(90*w),
          child: Column(
            children: [
              Container(
                color: Colors.transparent,
                height: 49 * h,
                child: ListView.builder(
                    itemCount: data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {

                      return InkWell(
                        onTap: () {
                          setState(() {
                            selected = data[index];
                            date = data[index].toString();
                            agentHistoryBloc.getAgentHistory(
                                widget.id, date);
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16 * w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: data[index].month == selected.month &&
                                data[index].year == selected.year
                                ? AppTheme.purple
                                : Colors.white,
                          ),
                          margin: EdgeInsets.only(
                              right: 10, left: 10 * w, bottom: 8 * h),
                          child: Center(
                            child: Text(
                              DateFormat('MMMM-yyyy').format(data[index]),
                              style: TextStyle(
                                fontSize: 16 * h,
                                color: data[index].month == selected.month &&
                                    data[index].year == selected.year
                                    ? AppTheme.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              StreamBuilder<IncomeAllModel>(
                  stream: agentHistoryBloc.getHistory,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
                        child: Row(
                          children: [
                            Text('monthBalanceStart'.tr(),),
                            const Spacer(),
                            Text("${snapshot.data!.client_month_balance_uzs} ${"waleType".tr()}"),
                            Text(" / ${snapshot.data!.client_month_balance_usd} \$"),
                          ],),
                      );
                    }
                    return Container(color: Colors.red,);
                  }
              )
            ],
          ),
        ),
      ),
      backgroundColor: AppTheme.background,
      body: StreamBuilder<IncomeAllModel>(
          stream: agentHistoryBloc.getHistory,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<DatumResult> data = snapshot.data!.data;
              int income = 0;
              int debt = 0;
              int incomeUsd = 0;
              int debtUsd = 0;
              walletType = data[0].wallet.valyuteType;
              for (int i = 0; i < data.length; i++) {
                if(data[i].wallet.valyuteType=='sum'){
                  if(data[i].operationType == 'kirim'){
                    income += (data[i].summaUzs);
                  }
                  else if(data[i].operationType == 'chiqim'){
                    debt += (data[i].summaUzs);
                  }
                }else{
                  if(data[i].operationType == 'kirim'){
                    incomeUsd += (data[i].summaUsd);
                  }
                  else if(data[i].operationType == 'chiqim'){
                    debtUsd += (data[i].summaUsd);
                  }
                }
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20 * h, horizontal: 20 * h),
                            margin: EdgeInsets.symmetric(
                                horizontal: 20 * w, vertical: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppTheme.white,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    span('', data[index].client),
                                    if (data[index].wallet.valyuteType == 'sum')
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            priceFormat
                                                .format(data[index].summaUzs)
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: data[index].operationType ==
                                                        "kirim"
                                                    ? Colors.green
                                                    : Colors.red),
                                          ),
                                          SizedBox(
                                            width: 5 * w,
                                          ),
                                          Text(
                                            data[index].wallet.valyuteType,
                                            style: TextStyle(
                                                fontSize: 15 * h,
                                                fontWeight: FontWeight.w400,
                                                color: data[index].operationType ==
                                                        "kirim"
                                                    ? Colors.green
                                                    : Colors.red),
                                          ),
                                        ],
                                      )
                                    else
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            priceFormat
                                                .format(data[index].summaUsd)
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: 16 * h,
                                                fontWeight: FontWeight.w400,
                                                color: data[index].operationType ==
                                                        "kirim"
                                                    ? Colors.green
                                                    : Colors.red),
                                          ),
                                          SizedBox(
                                            width: 5 * w,
                                          ),
                                          Text(
                                            data[index].wallet.valyuteType,
                                            style: TextStyle(
                                                fontSize: 15 * h,
                                                fontWeight: FontWeight.w400,
                                                color: data[index].operationType ==
                                                        "kirim"
                                                    ? Colors.green
                                                    : Colors.red),
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    span(capitalize(data[index].operationType), ''),
                                    Text(DateFormat('yyy-MM-dd')
                                        .format(data[index].date))
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10*w),
                    height: 90*w,
                    child: PageView(
                      controller: PageController(
                        viewportFraction: 0.8,
                        initialPage: 0,
                      ),
                      scrollDirection: Axis.horizontal,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 20*w,left: 10*w,right: 10*w),
                          padding: EdgeInsets.symmetric(horizontal: 20 * w,),
                          width: MediaQuery.of(context).size.width,
                          height: 90 * h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Kirim',
                                style: TextStyle(fontSize: 18 * h),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("${priceFormat.format(income)} som",
                                      style: TextStyle(fontSize: 18 * h,color: Colors.green)),
                                  Text("${priceFormat.format(incomeUsd)} \$",
                                      style: TextStyle(fontSize: 18 * h,color: Colors.green)),
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 20*w,left: 10*w,right: 10*w),
                          padding: EdgeInsets.symmetric(horizontal: 20 * w,),
                          width: MediaQuery.of(context).size.width,
                          height: 90 * h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Chiqim',
                                style: TextStyle(fontSize: 18 * h),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("${priceFormat.format(debt)} som",
                                      style: TextStyle(fontSize: 18 * h,color: Colors.red)),
                                  Text("${priceFormat.format(debtUsd)} \$",
                                      style: TextStyle(fontSize: 18 * h,color: Colors.red)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            }
            return const Center(child: CircularProgressIndicator.adaptive());
          }),
    );
  }

  Widget span(String title, content) {
    double h = Utils.getHeight(context);
    double w = Utils.getWidth(context);
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 8.0 * w),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18 * w,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 8.0 * w),
          child: Text(
            content,
            style: TextStyle(
                fontSize: 18 * w,
                fontWeight: FontWeight.w400,
                color: Colors.black.withOpacity(0.7)),
          ),
        )
      ],
    );
  }

  void _getData() async {
    DateTime now = DateTime.now();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int year = preferences.getInt('year') ?? now.year;
    int month = preferences.getInt('month') ?? now.month;
    var startYear = DateTime(year, month);
    var endYear = DateTime(now.year, now.month + 1); //if you want String
    while (startYear != endYear) {
      data.add(DateTime(startYear.year, startYear.month));
      startYear = DateTime(startYear.year, startYear.month + 1, startYear.day);
    }
    setState(() {});
  }
}

String capitalize(String text) {
  return text[0].toUpperCase() + text.substring(1);
}
