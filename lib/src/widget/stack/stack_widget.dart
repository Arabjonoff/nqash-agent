import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:naqsh_agent/src/widget/card/banner_card/banner_card_widget.dart';
import 'package:naqsh_agent/src/widget/card/menu_card/menu_card_widget.dart';

import '../../utils/utils.dart';

class StackWidget extends StatefulWidget {
  final num income;
  final num debt;
  final num expense;
  final num incomeUsd;
  final num debtUsd;
  final num expenseUsd;
  const StackWidget({Key? key, required this.income, required this.debt, required this.expense, required this.incomeUsd, required this.debtUsd, required this.expenseUsd}) : super(key: key);

  @override
  State<StackWidget> createState() => _StackWidgetState();
}

class _StackWidgetState extends State<StackWidget> {
  @override
  Widget build(BuildContext context) {
    double w = Utils.getWidth(context);
    double h = Utils.getHeight(context);
    return Stack(
      children: [
        Container(
          height: 213*h,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: AppTheme.indigo,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(DateFormat('MMMM-yyyy').format(DateTime.now()),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16*w,color: AppTheme.white),),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 16*w,),
                  BannerCardWidget(name: 'income'.tr(),summa: widget.income,summa_usd: widget.incomeUsd,),
                  BannerCardWidget(name: 'debt'.tr(),summa: widget.debt,summa_usd:widget.debtUsd ,),
                  BannerCardWidget(name: 'expense'.tr(),summa: widget.expense,summa_usd: widget.expenseUsd,),
                  SizedBox(width: 16*w,),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 150.0*h),
          child: Container(
            padding: EdgeInsets.only(top: 24*h),
            width: MediaQuery.of(context).size.width,
              height: 630*h,
              decoration: const BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              childAspectRatio: 1.3,
              mainAxisSpacing: 14,
              crossAxisCount: 2,
            children: [
              MenuCardWidget(image: 'assets/icons/3.png', onTap: () => Navigator.pushNamed(context, '/wallet'), margin: EdgeInsets.only(left: 20*w), name: 'wallet'.tr(),),
              MenuCardWidget(image: 'assets/icons/1.png', onTap: () => Navigator.pushNamed(context, '/agent'), margin: EdgeInsets.only(right: 20*w), name: 'agent'.tr(), ),
              MenuCardWidget(image: 'assets/icons/3.png', onTap: () => Navigator.pushNamed(context, '/income') , margin: EdgeInsets.only(left: 20*w), name: 'income'.tr(),),
              MenuCardWidget(image: 'assets/icons/4.png', onTap: () => Navigator.pushNamed(context, '/debt',arguments: 3), margin: EdgeInsets.only(right: 20*w), name: 'debt'.tr(),),
              MenuCardWidget(image: 'assets/icons/4.png', onTap: ()=> Navigator.pushNamed(context, '/expense'), margin: EdgeInsets.only(left: 20*w), name: 'expense'.tr(),),
            ],)
          ),
        ),
      ],
    );
  }



}
