import 'package:psq/domain/model/user_model.dart';

abstract class AuthState{}

class EmptyAuthState extends AuthState{
}
class LoadingAuthState extends AuthState{}
class InternetAuthState extends AuthState{}
class InitialAuthState extends AuthState{
UserModel? userModel;
bool? internet;
String? name;
String? code;
String? number;
InitialAuthState({this.userModel, this.internet, this.number, this.code, this.name});
}
class ErrorAuthState extends AuthState{}