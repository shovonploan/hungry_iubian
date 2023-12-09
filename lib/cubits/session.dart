import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hungry_iubian/models/user.dart';

abstract class Session {}

class SessionInitial extends Session {}

class SessionValue extends Session {
  final User user;

  SessionValue(this.user);
}

class SessionCubit extends Cubit<Session> {
  SessionCubit() : super(SessionInitial());

  void login(User newUser) {
    emit(SessionValue(newUser));
  }

  void logout() {
    emit(SessionInitial());
  }
}
