import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_agri_app/bloc/weather/weather_event.dart';
import 'package:smart_agri_app/bloc/weather/weather_state.dart';
import 'package:smart_agri_app/service/weather_api_service.dart';
import 'package:smart_agri_app/models/weather/weather_model.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherApiService weatherApiService;

  WeatherBloc({required this.weatherApiService})
      : super(WeatherInitial()) {
    on<FetchWeatherCombined>(_fetchCombinedWeather);
  }

  Future<void> _fetchCombinedWeather(
    FetchWeatherCombined event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());

    try {
      final current =
          await weatherApiService.getCurrentWeather(
        event.lat,
        event.lon,
      );

      final forecast =
          await weatherApiService.getForecast(
        event.lat,
        event.lon,
        event.days,
      );

      final combined = WeatherResponse(
        location: current.location,
        currentWather: current.currentWather,
        forecast: forecast.forecast,
      );

      emit(WeatherLoaded(weatherResponse: combined));
    } catch (e) {
      emit(WeatherError(message: e.toString()));
    }
  }
}