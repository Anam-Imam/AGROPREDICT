abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final dynamic data;

  AuthSuccess({required this.data});
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure({required this.error});
}