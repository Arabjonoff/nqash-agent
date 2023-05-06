import 'package:naqsh_agent/src/model/course/course_model.dart';
import 'package:naqsh_agent/src/model/http_result.dart';
import 'package:naqsh_agent/src/provider/repository.dart';
import 'package:rxdart/rxdart.dart';

class CourseBloc{
  final Repository _repository = Repository();
  final _clientCourse = PublishSubject<CourseAllModel>();
  Stream<CourseAllModel> get getCourses => _clientCourse.stream;



  getCourse()async{
    HttpResult response = await _repository.courseAll();
    if(response.isSuccess){
      CourseAllModel data = CourseAllModel.fromJson(response.result);
      _clientCourse.sink.add(data);
    }
  }
}

final courseBloc = CourseBloc();