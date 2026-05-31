import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:smart_agri_app/local/pref_helper.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  final Dio _dio = Dio();

  AuthBloc() : super(AuthInitial()) {

    on<LoginEvent>(_handleLogin);

    on<RegisterEvent>(_handleRegister);

  }

  // ================= LOGIN =================

  Future<void> _handleLogin(
      LoginEvent event,
      Emitter<AuthState> emit,
      ) async {

    emit(AuthLoading());

    try {

      print("LOGIN USERNAME: ${event.username}");
      print("LOGIN PASSWORD: ${event.password}");

      print("LOGIN URL:");
print("https://animator-overflow-drool.ngrok-free.dev/api/auth/login");

      final response = await _dio.post(
        'https://animator-overflow-drool.ngrok-free.dev/api/auth/login',
        data: {
          'username': event.username,
          'password': event.password,
        },
      );

      print("LOGIN STATUS CODE: ${response.statusCode}");
      print("LOGIN RESPONSE: ${response.data}");

      if (response.statusCode == 200) {

        final data = response.data['data'];

        await PrefHelper.saveLoginData(
          data['token'],
          data['user'],
        );

        emit(AuthSuccess(data: response.data));

      } else {

        emit(
          AuthFailure(
            error: 'Login failed: ${response.statusCode}',
          ),
        );

      }

    } on DioException catch (e) {

      print("LOGIN DIO ERROR: ${e.response?.data}");
      print("LOGIN DIO STATUS: ${e.response?.statusCode}");
      print("LOGIN DIO MESSAGE: ${e.message}");

      emit(
        AuthFailure(
          error: e.message ??
              'Login failed: ${e.response?.data ?? e.message}',
        ),
      );

    } catch (e) {

      print("LOGIN UNEXPECTED ERROR: $e");

      emit(
        AuthFailure(
          error: 'An unexpected error occurred!!',
        ),
      );

    }

  }

  // ================= REGISTER =================

  Future<void> _handleRegister(
      RegisterEvent event,
      Emitter<AuthState> emit,
      ) async {

    emit(AuthLoading());

    try {

      print("REGISTER DATA: ${event.userDate}");

      final response = await _dio.post(
        'http://192.168.100.113:6070/api/auth/register',
        data: event.userDate,
      );

      print("REGISTER STATUS CODE: ${response.statusCode}");
      print("REGISTER RESPONSE: ${response.data}");

      if (response.statusCode == 201) {

        emit(AuthSuccess(data: response.data));

      } else {

        emit(
          AuthFailure(
            error: 'Registration failed: ${response.statusCode}',
          ),
        );

      }

    } on DioException catch (e) {

      print("REGISTER DIO ERROR: ${e.response?.data}");
      print("REGISTER DIO STATUS: ${e.response?.statusCode}");
      print("REGISTER DIO MESSAGE: ${e.message}");

      emit(
        AuthFailure(
          error: e.message ??
              'Registration failed: ${e.response?.data ?? e.message}',
        ),
      );

    } catch (e) {

      print("REGISTER UNEXPECTED ERROR: $e");

      emit(
        AuthFailure(
          error: 'An unexpected error occurred!!',
        ),
      );

    }

  }

}