import 'package:psq/data/api/user_api.dart';
import 'package:psq/domain/model/user_model.dart';

class Repository {
  final UserApi _userApi = UserApi();

//   Future<UserModel> getCode{
//     return _userApi.getCode();
// }

  Future<UserModel> postNumber(String number) {
    return _userApi.postNumber(number: number);
  }


  Future<UserModel> postVerify(String number, String code){
    return _userApi.postVerify(code: code, number: number);
  }

  Future<UserModel> postRegister(String number, String code, String name){
    return _userApi.postRegister(code: code, number: number, name: name);
  }
}
