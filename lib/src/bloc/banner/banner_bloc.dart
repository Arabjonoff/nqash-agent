import 'package:naqsh_agent/src/model/banner/banner_model.dart';
import 'package:naqsh_agent/src/model/http_result.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:rxdart/rxdart.dart';

class BannerBloc{
  final Repository _repository = Repository();
  final _bannerInfo = PublishSubject<BannerModel>();
  Stream<BannerModel> get getCost => _bannerInfo.stream;

  getBanner()async{
    HttpResult response = await _repository.home();
    if(response.isSuccess){
      BannerModel data = BannerModel.fromJson(response.result);
      _bannerInfo.sink.add(data);
    }
  }
}
final bannerBloc = BannerBloc();