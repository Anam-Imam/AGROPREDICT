
import 'dart:io';

abstract class DiseaseState {
  final File? selectedImage;
  const DiseaseState({this.selectedImage});
}

class DiseaseInitial extends DiseaseState {
  const DiseaseInitial({File? selectedImage}) : super(selectedImage: selectedImage);
}

class DiseaseLoading extends DiseaseState {
  const DiseaseLoading(File selectedImage) : super(selectedImage: selectedImage);
}

class DiseaseSuccess extends DiseaseState {
  final String disease;
  final double confidence;
  final String advice;

  const DiseaseSuccess(
      File selectedImage,
      this.disease,
      this.confidence,
      this.advice)
      : super(selectedImage: selectedImage);
}

class DiseaseError extends DiseaseState {
  final String error;
  const DiseaseError(this.error, {File? selectedImage})
      : super(selectedImage: selectedImage);
}