import 'package:equatable/equatable.dart';

abstract class FertilizerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDropdowns extends FertilizerEvent {}

class GetRecommendation extends FertilizerEvent{
  final Map<String, dynamic> formData;
  GetRecommendation(this.formData);

  @override
  List<Object?> get props => [formData];
}