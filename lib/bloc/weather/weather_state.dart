
import 'package:smart_agri_app/models/weather/weather_model.dart';

abstract class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherResponse weatherResponse;
  final bool isCurrentWeather;


  WeatherLoaded({required this.weatherResponse, this.isCurrentWeather = true});
}

class WeatherError extends WeatherState {
  final String message;

  WeatherError({required this.message});

}