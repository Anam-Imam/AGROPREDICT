import 'dart:io';

abstract class DiseaseEvent {}

class PickImageEvent extends DiseaseEvent{}

class UploadImageEvent extends DiseaseEvent{
  final File image;
  UploadImageEvent(this.image);
}

class ResetEvent extends DiseaseEvent{}