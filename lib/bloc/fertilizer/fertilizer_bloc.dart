import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_agri_app/bloc/fertilizer/fertilizer_event.dart';
import 'package:smart_agri_app/bloc/fertilizer/fertilizer_state.dart';

class FertilizerBloc extends Bloc<FertilizerEvent, FertilizerState> {
  final Dio dio = Dio();

  FertilizerBloc() : super(FertilizerInitial()) {
    on<FetchDropdowns>(_onFetchDropdown);
    on<GetRecommendation>(_onGetRecommendation);
  }

  Future<void> _onFetchDropdown(FetchDropdowns event, Emitter<FertilizerState> emit) async {
    emit(FertilizerLoading());

    try {
      final response = await dio.get('https://animator-overflow-drool.ngrok-free.dev/api/dropdowns');
      emit(FertilizerDropdownsLoaded(
          List<String>.from(response.data['crops']),
          List<String>.from(response.data['stages']),
          List<String>.from(response.data['soilTypes']),
      ));
    }catch (e){
      emit(FertilizerError("Failed to fetch dropdowns: $e"));
    }

  }

  Future<void> _onGetRecommendation(GetRecommendation event, Emitter<FertilizerState> emit) async {
    emit(FertilizerLoading());
    try {
      final response = await dio.post(
  'https://animator-overflow-drool.ngrok-free.dev/api/predict_fertilizer',
  data: event.formData,
);
      if(response.statusCode == 200){
        emit(FertilizerRecommendationSuccess(response.data['recommendation']));
      }else {
        emit(FertilizerError("Failed to get recommendation: ${response.statusCode}"));
      }
    }catch(e){
      emit(FertilizerError("Failed to get recommendation: $e"));
    }
  }

}