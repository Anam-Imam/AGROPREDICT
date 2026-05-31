import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_agri_app/bloc/auth/auth_bloc.dart';
import 'package:smart_agri_app/bloc/fertilizer/fertilizer_bloc.dart';
import 'package:smart_agri_app/bloc/market/price_bloc.dart';
import 'package:smart_agri_app/bloc/weather/weather_bloc.dart';
import 'package:smart_agri_app/screens/splash_screen.dart';
import 'package:smart_agri_app/service/agmarknet_service.dart';
import 'package:smart_agri_app/service/weather_api_service.dart';

void main() {
  runApp(
    MultiBlocProvider(
        providers: [
          BlocProvider(create: (context)=> AuthBloc()),
          BlocProvider(create: (context)=> FertilizerBloc()),
          BlocProvider(create: (context)=> PriceBloc(apiService: AgmarknetService())),
          BlocProvider(create: (context) => WeatherBloc(weatherApiService: WeatherApiService()))
        ],
        child: MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Agriculture App',
      home: SplashScreen(),
    );
  }
}

