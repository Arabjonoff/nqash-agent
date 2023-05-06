import 'package:naqsh_agent/src/model/search/search_model.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/http_result.dart';


class SearchBloc{
  final _fetchSearch = PublishSubject<SearchModel>();

  Stream<SearchModel> get getSearchsss => _fetchSearch.stream;

  final Repository _repository = Repository();
  getSearch(query)async{
    HttpResult response = await _repository.search(query);
    if(response.isSuccess){
      SearchModel data = SearchModel.fromJson(response.result);
      _fetchSearch.sink.add(data);
    }
  }
}
final searchBloc = SearchBloc();