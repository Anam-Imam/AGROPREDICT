import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_agri_app/bloc/disease/disease_event.dart';

import 'disease_state.dart';

class DiseaseBloc extends Bloc<DiseaseEvent, DiseaseState> {

  final ImagePicker picker = ImagePicker();

  DiseaseBloc() : super(DiseaseInitial()) {

    on<PickImageEvent>(_onPickImage);

    on<UploadImageEvent>(_onUploadImage);

    on<ResetEvent>(
      (event, emit) => emit(DiseaseInitial()),
    );
  }

  // =========================
  // PICK IMAGE
  // =========================

  Future<void> _onPickImage(
    PickImageEvent event,
    Emitter<DiseaseState> emit,
  ) async {

    try {

      // Prevent multiple picker openings
      if (state is DiseaseLoading) {
        return;
      }

      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
      );

      // User cancelled picker
      if (pickedFile == null) {
        return;
      }

      final file = File(
        pickedFile.path,
      );

      emit(
        DiseaseLoading(file),
      );

      add(
        UploadImageEvent(file),
      );

    } catch (e) {

      emit(
        DiseaseError(
          "Failed to pick image: $e",
        ),
      );
    }
  }

  // =========================
  // UPLOAD IMAGE
  // =========================

  Future<void> _onUploadImage(
    UploadImageEvent event,
    Emitter<DiseaseState> emit,
  ) async {

    emit(
      DiseaseLoading(event.image),
    );

    try {

      String apiUrl =
          "https://animator-overflow-drool.ngrok-free.dev/predict";

      FormData formData = FormData.fromMap({

        "image": await MultipartFile.fromFile(
          event.image.path,
          filename: "image.jpg",
        ),

      });

      final response = await Dio().post(
        apiUrl,
        data: formData,
      );

      emit(

        DiseaseSuccess(

          event.image,

          response.data['disease'],

          response.data['confidence'],

          response.data['advice'],
        ),
      );

    } catch (e) {

      emit(

        DiseaseError(

          "Failed to process image: $e",

          selectedImage: event.image,
        ),
      );
    }
  }
}