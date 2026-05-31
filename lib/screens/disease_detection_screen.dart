import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_agri_app/bloc/disease/disease_bloc.dart';
import 'package:smart_agri_app/bloc/disease/disease_event.dart';
import 'package:smart_agri_app/bloc/disease/disease_state.dart';

import '../utils/advice_box.dart';
import '../utils/detection_result_box.dart';

class DiseaseDetectionScreen extends StatelessWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiseaseBloc(),
      child: DiseaseView(),
    );
  }
}

class DiseaseView extends StatelessWidget {
  const DiseaseView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text("Disease Detection"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<DiseaseBloc>().add(ResetEvent()),
          )
        ],
      ),
      body: BlocBuilder<DiseaseBloc, DiseaseState>(
          builder: (context, state) {
            if (state is DiseaseInitial) {
              return _buildPickButton(context);
            } else if (state is DiseaseLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DiseaseSuccess) {
              return _buildResult(context, state);
            } else if (state is DiseaseError) {
              return Center(child: Text(state.error));
            }
            return const SizedBox();
          }
      ),
    );
  }

  Widget _buildPickButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
          onPressed: () => context.read<DiseaseBloc>().add(PickImageEvent()),
          label: const Text('Pick Image')
      ),
    );
  }

  Widget _buildResult(BuildContext context, DiseaseSuccess state) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          if(state.selectedImage != null)
            _buildImageBox(state.selectedImage),
          const SizedBox(height: 16,),
          DetectionResultBox(
            disease: state.disease,
            confidence: state.confidence,
          ),
          const SizedBox(height: 16,),
          AdviceBox(advice: state.advice),
        ],
      ),
    );
  }

  Widget _buildImageBox(File? file) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: file != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(file, fit: BoxFit.cover,),
      ) : Center(
        child: Text("No image selected"),
      ),
    );
  }

}
