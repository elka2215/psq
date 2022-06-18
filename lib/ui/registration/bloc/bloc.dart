import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:psq/ui/registration/bloc/event_bloc.dart';
import 'package:psq/ui/registration/bloc/state_bloc.dart';
import 'package:psq/ui/repository/repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Repository repository;

  AuthBloc(this.repository) : super(InitialAuthState()) {
    on<NumberAuthEvent>(_onNumberAuthEvent);
    on<InternetAuthEvent>(_onInternetAuthEvent);
    on<CodeAuthEvent>(_onCodeAuthEvent);
    on<NameAuthEvent>(_onNameAuthEvent);
  }

  FutureOr<void> _onNumberAuthEvent(NumberAuthEvent event,
      Emitter<AuthState> emit) async {
    try {
      // emit(LoadingAuthState());
      // emit(InternetAuthState());
      final response = await repository.postNumber(event.number);
      emit(InitialAuthState(userModel: response));
      emit(InitialAuthState());
    } catch (e) {
      // emit(ErrorAuthState());
    }
  }

  FutureOr<void> _onCodeAuthEvent(CodeAuthEvent event,
      Emitter<AuthState> emit) async {
    try {
      // emit(LoadingAuthState());
      // emit(InternetAuthState());
      final response = await repository.postVerify(event.number, event.code);
      emit(InitialAuthState(userModel: response));
      emit(InitialAuthState());
    } catch (e) {
      // emit(ErrorAuthState());
    }
  }
  FutureOr<void> _onNameAuthEvent(NameAuthEvent event,
      Emitter<AuthState> emit) async {
    try {
      // emit(LoadingAuthState());
      // emit(InternetAuthState());
      final response = await repository.postRegister(event.number, event.code, event.name);
      emit(InitialAuthState(userModel: response));
      emit(InitialAuthState());
    } catch (e) {
      // emit(ErrorAuthState());
    }
  }

  FutureOr<void> _onInternetAuthEvent(InternetAuthEvent event,
      Emitter<AuthState> emit) async {
    try {
      // emit(LoadingAuthState());
      // emit(InternetAuthState());
    } catch (e) {
      // emit(ErrorAuthState());
    }
  }

}
