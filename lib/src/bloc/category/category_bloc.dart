import 'dart:convert';

import 'package:naqsh_agent/src/model/category/category_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../model/http_result.dart';
import '../../provider/repository.dart';

class CategoryBloc{
  final _fetchCategory = PublishSubject<List<CategoryModel>>();
  Stream<List<CategoryModel>> get getCategory => _fetchCategory.stream;

  final Repository _repository = Repository();
  getCategories()async{
    HttpResult response = await _repository.categoryGet();
    if(response.isSuccess){
      List<CategoryModel> data = categoryModelFromJson(json.encode(response.result));
      _fetchCategory.sink.add(data);
    }
  }
}
final categoryBloc = CategoryBloc();