import 'package:naqsh_agent/src/model/http_result.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/income/income_model.dart';

class WalletHistoryBloc{
  final Repository _repository = Repository();
  final _fetchWallet = PublishSubject<IncomeAllModel>();
  Stream<IncomeAllModel> get getWallet => _fetchWallet.stream;



  getWalletHistory(id,date)async{
    HttpResult response = await _repository.getWalletDetail(id,date);
    if(response.isSuccess){
      IncomeAllModel data = IncomeAllModel.fromJson(response.result);
      _fetchWallet.sink.add(data);
    }
  }

}

final walletHistoryBloc = WalletHistoryBloc();

