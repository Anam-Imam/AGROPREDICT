import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_agri_app/bloc/weather/weather_bloc.dart';
import 'package:smart_agri_app/bloc/weather/weather_event.dart';
import 'package:smart_agri_app/bloc/weather/weather_state.dart';
import 'package:smart_agri_app/models/weather/weather_model.dart';
import 'package:smart_agri_app/service/location_service.dart';
import 'package:smart_agri_app/utils/farming_advice.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String? cityName;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  void loadWeather() async {
    try {
      final position =
          await LocationService().getCurrentLocation();

      cityName = await LocationService().getCityName(
        position.latitude,
        position.longitude,
      );

      setState(() {});

      context.read<WeatherBloc>().add(
        FetchWeatherCombined(
          lat: position.latitude,
          lon: position.longitude,
          days: 3,
        ),
      );
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Weather")),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {

          if (state is WeatherLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WeatherLoaded) {
            final weather = state.weatherResponse;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 🌤 CURRENT WEATHER CARD
                  _buildCurrentWeather(weather),

                  const SizedBox(height: 20),

                  // 📅 FORECAST
                  const Text(
                    "3-Day Forecast",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  ...weather.forecast!.forecastday.map(
                    (day) => Card(
                      child: ListTile(
                        title: Text(day.date),
                        subtitle: Text(
                          "Max: ${day.day.maxtempC}°C  Min: ${day.day.mintempC}°C",
                        ),
                        trailing: Text(day.day.condition.text),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is WeatherError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text("Loading..."));
        },
      ),
    );
  }

  // 🌤 CURRENT WEATHER + FARMING STATUS
  Widget _buildCurrentWeather(WeatherResponse weather) {
    final iconUrl =
        'http:${weather.currentWather.condition.icon}';

    final advice = FarmingAdvice.getAdvice(
      temp: weather.currentWather.tempC,
      humidity: weather.currentWather.humidity,
      windSpeed: 10.0,
      condition: weather.currentWather.condition.text,
    );

    return Card(
      color: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              children: [
                Image.network(
                  iconUrl,
                  width: 60,
                  height: 60,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.cloud),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cityName ?? weather.location.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "${weather.currentWather.tempC}°C",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),

                      Text(
                        weather.currentWather.condition.text,
                        style: const TextStyle(color: Colors.white),
                      ),

                      Text(
                        "Humidity: ${weather.currentWather.humidity}%",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 12),

            // 🌾 FARMING STATUS
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "🌾 Farming Status: $advice",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}