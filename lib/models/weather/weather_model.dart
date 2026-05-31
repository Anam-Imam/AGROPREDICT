class WeatherResponse {
  final Location location;
  final CurrentWeather currentWather;
  final Forecast? forecast;

  WeatherResponse({
    required this.location,
    required this.currentWather,
    required this.forecast,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      location: Location.fromJson(json['location']),
      currentWather: CurrentWeather.fromJson(json['current']),
      forecast: json['forecast'] != null ? Forecast.fromJson(json['forecast']) : null,
    );
  }
}

class Location {
  final String name;
  final String region;
  final String country;

  Location({
    required this.name,
    required this.region,
    required this.country,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      region: json['region'],
      country: json['country'],
    );
  }
}

class CurrentWeather {
  final double tempC;
  final int humidity;
  final Condition condition;

  CurrentWeather({
    required this.tempC,
    required this.humidity,
    required this.condition,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      tempC: json['temp_c'],
      humidity: json['humidity'],
      condition: Condition.fromJson(json['condition']),
    );
  }
}

class Condition {
  final String text;
  final String icon;

  Condition({
    required this.text,
    required this.icon,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      text: json['text'],
      icon: json['icon'],
    );
  }
}

class Forecast {
  final List<ForecastDay> forecastday;

  Forecast({
    required this.forecastday,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final forecastday = json['forecastday'] as List;
    return Forecast(
      forecastday: forecastday.map((e) => ForecastDay.fromJson(e)).toList(),
    );
  }
}

class ForecastDay {
  final String date;
  final Day day;

  ForecastDay({
    required this.date,
    required this.day,
  });

  factory ForecastDay.fromJson(Map<String, dynamic> json) {
    return ForecastDay(
      date: json['date'],
      day: Day.fromJson(json['day']),
    );
  }
}


class Day {
  final double maxtempC;
  final double mintempC;
  final Condition condition;

  Day({
    required this.maxtempC,
    required this.mintempC,
    required this.condition,
  });

  factory Day.fromJson(Map<String, dynamic> json) {
    return Day(
      maxtempC: json['maxtemp_c'],
      mintempC: json['mintemp_c'],
      condition: Condition.fromJson(json['condition']),
    );
  }
}