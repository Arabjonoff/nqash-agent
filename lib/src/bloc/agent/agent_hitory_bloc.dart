import 'package:naqsh_agent/src/model/http_result.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/income/income_model.dart';

class AgentHistoryBloc{
  final Repository _repository = Repository();
  final _fetchAgentHistory = PublishSubject<IncomeAllModel>();
  Stream<IncomeAllModel> get getHistory => _fetchAgentHistory.stream;

  getAgentHistory(id,date)async{
    HttpResult response = await _repository.getAgentDetail(id,date);
    if(response.isSuccess){
      IncomeAllModel data = IncomeAllModel.fromJson(response.result);
      _fetchAgentHistory.sink.add(data);
    }
  }
}
final agentHistoryBloc = AgentHistoryBloc();