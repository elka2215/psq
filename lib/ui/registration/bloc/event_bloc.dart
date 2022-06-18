abstract class AuthEvent{}

class NumberAuthEvent extends AuthEvent{
  String number;
  NumberAuthEvent({required this.number});
}
class CodeAuthEvent extends AuthEvent{
  String number;
  String code;
  CodeAuthEvent({required this.number, required this.code});
}
class NameAuthEvent extends AuthEvent{
  String number;
  String code;
  String name;
  NameAuthEvent({required this.number, required this.code, required this.name});
}
class InternetAuthEvent extends AuthEvent{
}

class ErrorAuthEvent extends AuthEvent{}
