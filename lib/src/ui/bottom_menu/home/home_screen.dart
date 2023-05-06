import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:naqsh_agent/src/bloc/banner/banner_bloc.dart';
import 'package:naqsh_agent/src/model/banner/banner_model.dart';
import 'package:naqsh_agent/src/model/wallet/wallet_model.dart';
import 'package:naqsh_agent/src/theme/app_theme.dart';
import 'package:naqsh_agent/src/ui/bottom_menu/bottom_menu_screen.dart';
import 'package:naqsh_agent/src/widget/stack/stack_widget.dart';
import '../../../bloc/wallet/wallet_bloc.dart';
import '../../../utils/utils.dart';
import '../../wallet/wallet_add/add_wallet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController pageController = PageController(viewportFraction: 0.8);
  @override
  void initState() {
    super.initState();
    walletBloc.getWallet();
    bannerBloc.getBanner();
  }
  @override
  void dispose() {
    super.dispose();
    walletBloc.getWallet();
  }

  @override
  Widget build(BuildContext context) {
    double w = Utils.getWidth(context);
    double h = Utils.getHeight(context);
    return Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: ()async{
              await Future.delayed(Duration(seconds: 2));
              walletBloc.getWallet();
              bannerBloc.getBanner();
            },
            child: Stack(
              children: [
                SvgPicture.asset('assets/icons/vvv.svg',fit: BoxFit.cover,),
                SingleChildScrollView(
                  child: Column(
                    children:  [
                       SizedBox(height: 32*h,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        child: StreamBuilder<List<WalletModel>>(
                            stream: walletBloc.getWalletInfo,
                            builder: (context, snapshot) {
                            if(snapshot.hasData){
                              List<WalletModel> data = snapshot.data!;
                              return  data.isNotEmpty? PageView.builder(
                                controller: pageController,
                                  itemCount: data.length+1,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context,index){
                                  if(index == data.length){
                                    return GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context){
                                          return const WalletAddScreen();
                                        }));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.symmetric(horizontal: 5*w),
                                        width: MediaQuery.of(context).size.width,
                                        height: 100*h,
                                        decoration: BoxDecoration(
                                          color: AppTheme.purple,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.grey),
                                        ),
                                        child: Center(
                                          child: Text('addWallet'.tr(),style: TextStyle(color: Colors.white),),
                                        ),
                                      ),
                                    );
                                  }
                                  else{
                                    return GestureDetector(
                                      onTap: (){
                                        Navigator.pushNamed(context, '/wallet_history',arguments: data[index]);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10*h),
                                        padding: EdgeInsets.symmetric(horizontal: 16*w),
                                        height: 100*h,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.blue,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: data[index].bg == ""?const AssetImage(
                                                  'assets/icons/006.png',
                                                ):AssetImage(
                                                  data[index].bg,
                                                )
                                            )
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 16*h,),
                                            Text(data[index].name,style: TextStyle(fontSize: 19*h,fontWeight: FontWeight.w700,color: Colors.white),),
                                            SizedBox(height: 5*h,),
                                            Text('balance'.tr(),style: TextStyle(fontSize: 15*h,fontWeight: FontWeight.w400,color: Colors.white),),
                                            SizedBox(height: 5*h,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(priceFormat.format(data[index].balans).toString(),style: TextStyle(fontSize: 21*h,fontWeight: FontWeight.w700,color: Colors.white)),
                                                Text(data[index].valyuteType,style: TextStyle(fontSize: 17*h,fontWeight: FontWeight.w500,color: Colors.white)),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  }):
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20*w),
                                width: MediaQuery.of(context).size.width,
                                height: 100*h,
                                decoration: BoxDecoration(
                                  color: AppTheme.purple,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Center(
                                  child: TextButton(
                                    onPressed: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return WalletAddScreen();
                                      }));
                                    },
                                    child: Text('addWallet'.tr(),style: TextStyle(color: Colors.white),),
                                  ),
                                ),
                              );
                            }return const Center(child: CircularProgressIndicator.adaptive(),);
                          }
                        ),
                      ),
                      const SizedBox(height: 32,),
                       StreamBuilder<BannerModel>(
                         stream: bannerBloc.getCost,
                         builder: (context, snapshot) {
                           if(snapshot.hasData){
                             return StackWidget(income: snapshot.data!.data!.kirim, debt: snapshot.data!.data!.chiqim, expense: snapshot.data!.data!.xarajat, incomeUsd: snapshot.data!.data!.kirimUsd, debtUsd: snapshot.data!.data!.chiqimUsd, expenseUsd: snapshot.data!.data!.xarajatUsd,);
                           }
                           return Container();
                         }
                       ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),);
  }
}
