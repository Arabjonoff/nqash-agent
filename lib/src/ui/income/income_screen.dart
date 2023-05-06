import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:naqsh_agent/src/bloc/income/income_bloc.dart';
import 'package:naqsh_agent/src/dialog/alert/alert_dialog.dart';
import 'package:naqsh_agent/src/model/http_result.dart';
import 'package:naqsh_agent/src/model/income/income_model.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:naqsh_agent/src/widget/button/ontap_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../bloc/wallet/wallet_bloc.dart';
import '../../dialog/connection/connection_dialog.dart';
import '../../model/wallet/wallet_model.dart';
import '../../theme/app_theme.dart';
import '../../utils/bus/rx_bus.dart';
import '../../utils/utils.dart';
import '../bottom_menu/bottom_menu_screen.dart';
import '../wallet/wallet_add/add_wallet.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({Key? key}) : super(key: key);

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  PageController pageController = PageController(viewportFraction: 0.8);
  @override
  void initState() {
    incomeBloc.getIncome(date, '');
    _getData();
    _initBus();
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
    RxBus.destroy(tag: 'income_bloc');

  }

  var date = DateFormat('yyyy-MM').format(DateTime.now());
  var filterDate;
  var filterWallet;
  bool loading = false;
  DateTime selected = DateTime.now();
  List<DateTime> listDate = [];


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
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
        ],
        elevation: 5,
        foregroundColor: AppTheme.black24,
        backgroundColor: AppTheme.white,
        centerTitle: true,
        title: const Text(
          'Kirimlar',
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Container(
            color: Colors.transparent,
            height: 49 * h,
            child: ListView.builder(
                itemCount: listDate.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        selected = listDate[index];
                        date = listDate[index].toString();
                        incomeBloc.getIncome(date, '');
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16 * w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: listDate[index].month == selected.month &&
                                listDate[index].year == selected.year
                            ? AppTheme.purple
                            : Colors.white,
                      ),
                      margin: EdgeInsets.only(
                          right: 10, left: 10 * w, bottom: 8 * h),
                      child: Center(
                        child: Text(
                          DateFormat('yyyy-MMMM').format(listDate[index]),
                          style: TextStyle(
                            fontSize: 16 * h,
                            color: listDate[index].month == selected.month &&
                                    listDate[index].year == selected.year
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
        // shape: const RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //         bottomRight: Radius.circular(20),
        //         bottomLeft: Radius.circular(20))),
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
                      'Hamyon boyicha ',
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
                              controller: pageController,
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
                                                'Balans',
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
                                          '+ Hanyon qo\'shish',
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
                      'Sana boyicha ',
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
                  )
                ],
              ),
            ),
            TextButton(onPressed: (){
              incomeBloc.getIncome(date, '');
              Navigator.pop(context);
            }, child: Text('Barchasi korish')),
            Row(
              children: [
                Expanded(child: OnTapWidget(title: 'Orqaga', onTap: () =>Navigator.pop(context),color: false,)),
                Expanded(
                  child: OnTapWidget(
                    title: 'Qollash',
                    onTap: () {
                      setState(() {
                        state();
                      });
                      incomeBloc.getIncome(filterDate, filterWallet);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            )
          ],
        )),
      ),
      body: Stack(
        children: [
          StreamBuilder<IncomeAllModel>(
              stream: incomeBloc.getIncom,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<DatumResult> data = snapshot.data!.data;
                  int count = 0;
                  for (int i = 0; i < data.length; i++) {
                    count += (data[i].summaUzs);
                  }
                  int countUsd = 0;
                  for (int i = 0; i < data.length; i++) {
                    countUsd += (data[i].summaUsd);
                  }
                  return snapshot.data!.data.isEmpty
                      ? Center(
                    child: Text('Ma\'lumotlar topilmadi'),
                  )
                      : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                background: slideLeftBackground(),
                                  onDismissed: (direction) async {
                                    if (direction ==
                                        DismissDirection.endToStart) {
                                      await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: Text(
                                                  "Haqiqatan ham oʻchirib tashlamoqchimisiz ${data[index].client}?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text(
                                                    "Orqaga",
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
                                                    "O'chirish",
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
                                                      incomeBloc.getIncome(date,'');
                                                    }
                                                  },
                                                ),
                                              ],
                                            );
                                          });
                                    }},
                                  key: UniqueKey(),
                                  child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 20 * h, horizontal: 20 * h),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20 * w, vertical: 10),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: AppTheme.white,
                                  boxShadow: const [
                                    BoxShadow(
                                      offset: Offset(4, 15),
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
                                        Text(data[index].client,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                                        data[index].wallet.valyuteType == 'dollar'?Text(
                                          '${priceFormat.format(data[index].summaUsd)} dollar',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
                                        ):Text(
                                          '${priceFormat.format(data[index].summaUzs)} som',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 8*h,),
                                    data[index].accepted=='0'?SizedBox():Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Qabul qilindi:',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          '${data[index].accepted}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 8*h,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        span('Hamyon', data[index].wallet.name),
                                        Text(DateFormat('yyyy-MM-dd').format(data[index].date))
                                      ],
                                    ),
                                    SizedBox(height: 8*h,),
                                    data[index].comment.isEmpty?const SizedBox():span('Izoh:', data[index].comment),
                                  ],
                                ),
                              ),
                              );
                            }),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20 * w),
                        width: MediaQuery.of(context).size.width,
                        height: 90 * h,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Jami summa:',
                              style: TextStyle(fontSize: 18 * h),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${priceFormat.format(count)} som',
                                    style: TextStyle(fontSize: 18 * h)),
                                SizedBox(
                                  height: 5 * h,
                                ),
                                Text('${priceFormat.format(countUsd)} \$',
                                    style: TextStyle(fontSize: 18 * h)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  );
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
              }),
          if(loading)Container(
            color: Colors.black.withOpacity(0.7),
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
          ) else SizedBox(),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom:45.0 * h),
        child: FloatingActionButton(
          heroTag: "btn2",
          onPressed: () => Navigator.pushNamed(context, '/add_income'),
          backgroundColor: AppTheme.purple,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
state(){
    loading = true;
  Future.delayed(Duration(seconds: 2), () {
    setState(() {
      loading = false;
    });
  });

}
  void _getData() async {
    DateTime now = DateTime.now();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int year = preferences.getInt('year') ?? now.year;
    int month = preferences.getInt('month') ?? now.month;
    var startYear = DateTime(year, month);
    var endYear = DateTime(now.year, now.month + 1); //if you want String
    while (startYear != endYear) {
      listDate.add(DateTime(startYear.year, startYear.month));
      startYear = DateTime(startYear.year, startYear.month + 1, startYear.day);
    }
    setState(() {});
  }

  Widget span(String title, content) {
    double h = Utils.getHeight(context);
    double w = Utils.getWidth(context);
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 0.0 * w),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18 * w,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          width: 20 * w,
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 0.0 * w),
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

  void _initBus() {
    RxBus.register<String>(tag: 'income_bloc').listen((event) {
      ConnectionDialog.showConnectionDialog(context,event);
    });
  }

  Widget slideLeftBackground() {
    return Container(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Icon(
              Icons.delete,
              color: Colors.red,
            ),
            Text(
              " O'chirish",
              style: TextStyle(
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
