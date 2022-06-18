import 'package:dio/dio.dart';
import 'package:psq/domain/model/user_model.dart';

class UserApi {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'http://82.148.19.59:27015/api'),
  );

  Future<UserModel> postNumber({required String number}) async {
    try {
      final response = await _dio.post('/validatePhone', queryParameters: {'number': number});
      return UserModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<UserModel> postVerify({required String code, required String number}) async {
    try {
      final response = await _dio.get('/verity', queryParameters: {'code': code, 'number': number});
      return UserModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

  Future<UserModel> postRegister({required String code, required String number, required String name }) async {
    try {
      final response = await _dio.get('/register', queryParameters: {'code': code, 'number': number});
      return UserModel.fromJson(response.data);
    } catch (error) {
      rethrow;
    }
  }

}