import 'package:equatable/equatable.dart';

abstract class FertilizerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FertilizerInitial extends FertilizerState {}

class FertilizerLoading extends FertilizerState {}

class FertilizerDropdownsLoaded extends FertilizerState {
  final List<String> crops;
  final List<String> stages;
  final List<String> soilTypes;

  FertilizerDropdownsLoaded(this.crops, this.stages, this.soilTypes,);

  @override
  List<Object?> get props => [crops, stages, soilTypes];

}

class FertilizerRecommendationSuccess extends FertilizerState {
  final String recommendation;
  FertilizerRecommendationSuccess(this.recommendation);

  @override
  List<Object?> get props => [recommendation];
}

class FertilizerError extends FertilizerState {
  final String errorMessage;
  FertilizerError(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}