import 'package:naqsh_agent/src/model/cost/cost_model.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/http_result.dart';

class CostBloc{
  final Repository _repository = Repository();
  final _costInfo = PublishSubject<CostGetModel>();
  Stream<CostGetModel> get getCost => _costInfo.stream;


  getCosts()async{
    HttpResult response = await _repository.getCost();
    if(response.isSuccess){
      CostGetModel data = CostGetModel.fromJson(response.result);
      _costInfo.sink.add(data);
    }
  }
}
final costBloc = CostBloc();