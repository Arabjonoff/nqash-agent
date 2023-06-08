// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:naqsh_agent/src/model/income/income_model.dart';
import 'package:naqsh_agent/src/ui/expense/add_expense_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../bloc/cost/cost_bloc.dart';
import '../../bloc/expense/expense_bloc.dart';
import '../../bloc/wallet/wallet_bloc.dart';
import '../../dialog/alert/alert_dialog.dart';
import '../../model/cost/cost_model.dart';
import '../../model/http_result.dart';
import '../../model/wallet/wallet_model.dart';
import '../../provider/repository.dart';
import '../../theme/app_theme.dart';
import '../../utils/utils.dart';
import '../../widget/button/ontap_widget.dart';
import '../bottom_menu/bottom_menu_screen.dart';
import '../wallet/wallet_add/add_wallet.dart';
class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {

  @override
  void initState() {
    _getData();
    expenseBloc.getExpenses(date,'','');
    super.initState();
  }
  @override
  void dispose() {
    expenseBloc.getExpenses(date,'','');
    super.dispose();
  }
  var date = DateFormat('yyyy-MM').format(DateTime.now());
  DateTime selected = DateTime.now();
  List<DateTime> data = [];
  var filterDate;
  var filterWallet;
  var filterCost;
  @override
  Widget build(BuildContext context) {
    double h = Utils.getHeight(context);
    double w = Utils.getWidth(context);
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: SvgPicture.asset('assets/icons/filter.svg'),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
                walletBloc.getWallet();
                costBloc.getCosts();

              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
        elevation: 5,
        foregroundColor: AppTheme.black24,
        backgroundColor: AppTheme.white,
        centerTitle: true,
        title: Text('expense'.tr(),style: TextStyle(fontSize: 25*w,fontWeight: FontWeight.w700,color: Colors.black),),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
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
                        expenseBloc.getExpenses(date,'','');
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
                          DateFormat('yyyy-MMMM').format(data[index]),
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
        ),
      ),
      endDrawer: Drawer(
        child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Center(
                          child: Text(
                            'Filtr',
                            style: TextStyle(
                                fontSize: 20 * h, fontWeight: FontWeight.w600),
                          )),
                      SizedBox(
                        height: 16 * h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0 * w, vertical: 10 * h),
                        child: Text(
                          'theWallet'.tr(),
                          style: TextStyle(
                              fontSize: 16 * h, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: StreamBuilder<List<WalletModel>>(
                            stream: walletBloc.getWalletInfo,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<WalletModel> data = snapshot.data!;
                                return data.isNotEmpty
                                    ? PageView.builder(
                                    itemCount: data.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() =>
                                          filterWallet = data[index].id);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16 * w),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 16 * w),
                                          height: 100 * h,
                                          width:
                                          MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              border: filterWallet ==
                                                  data[index].id
                                                  ? Border.all(
                                                  color: AppTheme.purple,
                                                  width: 3)
                                                  : Border(),
                                              borderRadius:
                                              BorderRadius.circular(10),
                                              color: Colors.blue,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: data[index].bg == ""
                                                      ? const AssetImage(
                                                    'assets/icons/006.png',
                                                  )
                                                      : AssetImage(
                                                    data[index].bg,
                                                  ))),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 16 * h,
                                              ),
                                              Text(
                                                data[index].name,
                                                style: TextStyle(
                                                    fontSize: 19 * h,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 5 * h,
                                              ),
                                              Text(
                                                'balance'.tr(),
                                                style: TextStyle(
                                                    fontSize: 15 * h,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 5 * h,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                      priceFormat.format(data[index].balans).toString(),
                                                      style: TextStyle(
                                                          fontSize: 21 * h,
                                                          fontWeight:
                                                          FontWeight.w700,
                                                          color: Colors.white)),
                                                  Text(data[index].valyuteType,
                                                      style: TextStyle(
                                                          fontSize: 17 * h,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color: Colors.white)),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                    : Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20 * w),
                                  width: MediaQuery.of(context).size.width,
                                  height: 100 * h,
                                  decoration: BoxDecoration(
                                    color: AppTheme.purple,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                                  return WalletAddScreen();
                                                }));
                                      },
                                      child: Text(
                                        'addWallet'.tr(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator.adaptive(),
                              );
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0 * w, vertical: 10 * h),
                        child: Text(
                          'theDate'.tr(),
                          style: TextStyle(
                              fontSize: 16 * h, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: SfDateRangePicker(
                          maxDate: DateTime.now(),
                          selectionColor: AppTheme.black24,
                          onSelectionChanged:
                              (DateRangePickerSelectionChangedArgs args) {
                            setState(() => filterDate = args.value);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0 * w, vertical: 10 * h),
                        child: Text(
                          'typeExpense'.tr(),
                          style: TextStyle(
                              fontSize: 16 * h, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 50*h,
                        child: StreamBuilder<CostGetModel>(
                          stream: costBloc.getCost,
                          builder: (context, snapshot) {
                         if(snapshot.hasData){
                           List<Datum> data = snapshot.data!.data;
                           return ListView.builder(
                             itemCount: data.length,
                               scrollDirection: Axis.horizontal,
                               itemBuilder: (context,index){
                                 return TextButton(onPressed: (){
                                   setState(() {
                                     filterCost = data[index].id;
                                   });
                                 }, child: Text(data[index].name,style: TextStyle(color: data[index].id == filterCost?Colors.blue:Colors.grey),));
                               });
                         }return const SizedBox();
                          }
                        ),
                      )
                    ],
                  ),
                ),
                TextButton(onPressed: (){
                  expenseBloc.getExpenses(date, '','');
                  Navigator.pop(context);
                }, child: Text('allSee'.tr())),
                Row(
                  children: [
                    Expanded(child: OnTapWidget(title: 'back'.tr(), onTap: () =>Navigator.pop(context),color: false,)),
                    Expanded(
                      child: OnTapWidget(
                        title: 'confirmation'.tr(),
                        onTap: () {
                          expenseBloc.getExpenses(DateFormat('yyyy-MM-dd').format(filterDate), filterWallet,filterCost);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                )
              ],
            )),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<IncomeAllModel>(
              stream: expenseBloc.getExpense,
              builder: (context, snapshot) {
                if(snapshot.hasData){
                  List<DatumResult> data = snapshot.data!.data;
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context,index){
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                            background: slideLeftBackground(),
                            onDismissed: (direction) async {
                              if (direction ==
                                  DismissDirection.endToStart) {
                                await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text(
                                            'deleteOk'.tr()),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text(
                                              "back".tr(),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          TextButton(
                                            child: Text(
                                              "delete".tr(),
                                              style: TextStyle(
                                                  color: Colors.red),
                                            ),
                                            onPressed: () async {
                                              Repository repository = Repository();
                                              HttpResult res =
                                              await repository
                                                  .deleteOperation(
                                                  data[index].id);
                                              if (res.result["status"] ==
                                                  "ok") {
                                                // ignore: use_build_context_synchronously
                                                Navigator.pop(context);
                                                expenseBloc.getExpenses(date,'','');
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              }},
                            key: UniqueKey(), child: Container(
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(data[index].cost,style: TextStyle(fontSize: 18),),
                                  data[index].summaUsd==0?Text("${priceFormat.format(data[index].summaUzs )} uzs",style: TextStyle(fontSize: 18*w,fontWeight: FontWeight.w400,color: Colors.orange),):Text("${priceFormat.format(data[index].summaUsd )} \$",style: TextStyle(fontSize: 18*w,fontWeight: FontWeight.w400,color: Colors.orange),),
                                ],
                              ),
                              SizedBox(height: 8*h,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(data[index].wallet.name,style: TextStyle(fontSize: 18),),
                                  Text( DateFormat('yyyy-MM-dd').format(data[index].date)),
                                ],
                              ),
                              SizedBox(height: 8*h,),
                              data[index].comment.isEmpty?const SizedBox(): span('comment'.tr(), data[index].comment),
                            ],
                          ),
                        ));
                      });
                }
                return  Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    ),
                  ),
                );
              }
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: FloatingActionButton(heroTag: "btn5",onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context){
          return const AddExpenseScreen();
        })),backgroundColor: AppTheme.purple,child: const Icon(Icons.add),),
      ),
    );
  }


  void _getData() async{
    DateTime now = DateTime.now();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int year = preferences.getInt('year')??now.year;
    int month = preferences.getInt('month')??now.month;
    var startYear = DateTime(year,month);
    var endYear = DateTime(now.year,now.month +1); //if you want String
    while (startYear != endYear) {
      data.add(DateTime(startYear.year,startYear.month));
      startYear = DateTime(startYear.year, startYear.month + 1, startYear.day);
    }
    setState(() {

    });
  }

  Widget span(String title,content){
    double h = Utils.getHeight(context);
    double w = Utils.getWidth(context);
    return Row(
      children: [
        Padding(
          padding:  EdgeInsets.only(bottom: 0.0*w),
          child: Text(title,style:  TextStyle(fontSize: 18*w,),),
        ),
        SizedBox(width: 20*w,),
        Padding(
          padding:  EdgeInsets.only(bottom: 0.0*w),
          child: Text(content,style: TextStyle(fontSize: 18*w,fontWeight: FontWeight.w400,color: Colors.black.withOpacity(0.7)),),
        )
      ],
    );
  }
  Widget slideLeftBackground() {
    return Container(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children:  [
            const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            Text(
              "delete".tr(),
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }


}
