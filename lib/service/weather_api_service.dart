import 'package:dio/dio.dart';
import 'package:smart_agri_app/models/weather/weather_model.dart';

class WeatherApiService {

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.weatherapi.com/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
    ),
  );

  final String _apiKey = 'f4ee25bae82f4b70848192821260805';

  Future<WeatherResponse> getCurrentWeather(
      double lat,
      double lon,
      ) async {

    final response = await _dio.get(
      '/current.json',
      queryParameters: {
        'key': _apiKey,
        'q': '$lat,$lon',
      },
    );

    return WeatherResponse.fromJson(response.data);
  }

  Future<WeatherResponse> getForecast(
      double lat,
      double lon,
      int days,
      ) async {

    final response = await _dio.get(
      '/forecast.json',
      queryParameters: {
        'key': _apiKey,
        'q': '$lat,$lon',
        'days': days,
        'alerts': 'yes',
      },
    );

    return WeatherResponse.fromJson(response.data);
  }
}