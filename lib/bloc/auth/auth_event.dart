import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  AuthLoginEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class AuthLogoutEvent extends AuthEvent {}

class AuthCheckingEvent extends AuthEvent {}
