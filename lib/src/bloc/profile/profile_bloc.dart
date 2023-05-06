import 'package:naqsh_agent/src/model/http_result.dart';
import 'package:naqsh_agent/src/model/profile/profile_model.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc{
  final Repository _repository = Repository();
  final _fetchInfoProfile = PublishSubject<ProfileModel>();
  Stream<ProfileModel> get getProfiles => _fetchInfoProfile.stream;

  getProfile()async{
    HttpResult response = await _repository.profile();
    if(response.isSuccess){
      ProfileModel data = ProfileModel.fromJson(response.result);
      _fetchInfoProfile.sink.add(data);
    }
  }
}
final profileBloc = ProfileBloc();