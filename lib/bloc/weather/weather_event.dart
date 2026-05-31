abstract class WeatherEvent {}

class FetchCurrentWeather extends WeatherEvent {
  final double lat;
  final double lon;

  FetchCurrentWeather({required this.lat, required this.lon});
}

class FetchWeatherForecast extends WeatherEvent {
  final double lat;
  final double lon;
  final int days;

  FetchWeatherForecast({
    required this.lat,
    required this.lon,
    this.days = 3,
  });
}

class FetchWeatherCombined extends WeatherEvent {
  final double lat;
  final double lon;
  final int days;

  FetchWeatherCombined({
    required this.lat,
    required this.lon,
    this.days = 3,
  });
}