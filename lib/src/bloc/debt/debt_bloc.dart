import 'package:naqsh_agent/src/model/income/income_model.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/http_result.dart';

class DebtBloc{
  Repository _repository = Repository();

  final _fetchIncome = PublishSubject<IncomeAllModel>();
  Stream<IncomeAllModel> get getIncom => _fetchIncome.stream;


  getDebt(date,wallet)async{
    HttpResult response = await _repository.debtAll(date,wallet);
    if(response.isSuccess){
      IncomeAllModel data = IncomeAllModel.fromJson(response.result);
      _fetchIncome.sink.add(data);
    }
  }
}

final debtBloc = DebtBloc();