import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_agri_app/config.dart';
import 'package:smart_agri_app/models/planning/crop.dart';
import 'package:smart_agri_app/models/planning/crop_planning.dart';
import 'package:smart_agri_app/models/planning/crop_task.dart';


class CropService {
  final Dio _dio;
  static const String baseUrl = '${Config.baseUrl}/farmer';

  CropService({required String authToken}) :_dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    };

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ));
    }

    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, ErrorInterceptorHandler handler) {
        if(e.response?.statusCode == 401){
          // logout here
        }
        return handler.next(e);
      },
    ));
  }


  Future<List<Crop>> getCropLibrary() async {
    try {
      final response  = await _dio.get('/get_crop_list');
      if(response.statusCode == 200){
        final data = response.data;
        if(data['status'] == 'success'){
          List<dynamic> cropJson = data['data'];
          return cropJson.map((json) => Crop.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load the crop library: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load the crop library: ${response.statusCode}');
      }

    } on DioException catch (e){
      if(e.response != null){
        throw Exception('server Error: ${e.response?.data['message']}');
      }else {
        throw Exception('Network Error: ${e.message}');
      }
    }
  }

  Future<CropPlanning> createCropPlanning(CropPlanning planning) async {
    try {
      final response = await _dio.post(
        '/planning',
        data: planning.toJson(),
      );

      if(response.statusCode == 201){
        final data = response.data;
        if(data['status'] == 'success'){
          final planningData = data['data'];
          return CropPlanning.fromJson(planningData);
        } else {
          throw Exception('Failed to create crop planning: ${data['message']}');
        }
      } else {
        throw Exception('Failed to create crop planning: ${response.statusCode}');
      }

    } on DioException catch (e){
      if(e.response != null){
        throw Exception('server Error: ${e.response?.data['message']}');
      }else {
        throw Exception('Network Error: ${e.message}');
      }
    }
  }

  Future<List<CropPlanning>> getCropPlannings() async {
    try {
      final response  = await _dio.get('/planning');
      if(response.statusCode == 200){
        final data = response.data;
        if(data['status'] == 'success'){
          List<dynamic> planningJson = data['data'];
          return planningJson.map((json) => CropPlanning.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load the crop planning: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load the crop planning: ${response.statusCode}');
      }
    }on DioException catch(e){
      if(e.response != null){
        throw Exception('server Error: ${e.response?.data['message']}');
      }else {
        throw Exception('Network Error: ${e.message}');
      }
    }
  }

  Future<CropTask> createCropTask(int planningId, String taskType, String taskDate) async {
    try {
      final response = await _dio.post(
        '/tasks',
        data: {
          'planning_id': planningId,
          'task_type': taskType,
          'task_date': taskDate,
        },
      );

      if(response.statusCode == 201){
        final data = response.data;
        if(data['status'] == 'success'){
          return CropTask.fromJson(data['data']);
        } else {
          throw Exception('Failed to create crop task: ${data['message']}');
        }
      } else {
        throw Exception('Failed to create crop task: ${response.statusCode}');
      }

    } on DioException catch (e){
      if(e.response != null){
        throw Exception('server Error: ${e.response?.data['message']}');
      }else {
        throw Exception('Network Error: ${e.message}');
      }
    }
  }

  Future<List<CropTask>> getTaskCalendar() async {
    try {
      final response  = await _dio.get('/tasks/calendar');
      if(response.statusCode == 200){
        final data = response.data;
        if(data['status'] == 'success'){
          List<dynamic> taskJson = data['data'];
          return taskJson.map((json) => CropTask.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load the task calendar: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load the task calendar: ${response.statusCode}');
      }
    }on DioException catch(e){
      if(e.response != null){
        throw Exception('server Error: ${e.response?.data['message']}');
      }else {
        throw Exception('Network Error: ${e.message}');
      }
    }
  }

  Future<List<CropTask>> getTaskByPlanningId(int planningId) async {
    try {
      final response  = await _dio.get('/tasks/$planningId/tasks');
      if(response.statusCode == 200){
        final data = response.data;
        if(data['status'] == 'success'){
          List<dynamic> taskJson = data['data'];
          return taskJson.map((json) => CropTask.fromJson(json)).toList();
        } else {
          throw Exception('Failed to load the task calendar: ${data['message']}');
        }
      } else {
        throw Exception('Failed to load the task calendar: ${response.statusCode}');
      }
    }on DioException catch(e){
      if(e.response != null){
        throw Exception('server Error: ${e.response?.data['message']}');
      }else {
        throw Exception('Network Error: ${e.message}');
      }
    }
  }

  Future<CropTask> updateTaskStatus(int taskId, String status) async {
    try {
      final response  = await _dio.patch(
          '/tasks/$taskId',
        data: {'status': status},
      );
      if(response.statusCode == 200){
        final data = response.data;
        if(data['status'] == 'success'){
          return CropTask.fromJson(data['data']);
        } else {
          throw Exception('Failed to update task: ${data['message']}');
        }
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    }on DioException catch(e){
      if(e.response != null){
        throw Exception('server Error: ${e.response?.data['message']}');
      }else {
        throw Exception('Network Error: ${e.message}');
      }
    }
  }

  Future<bool> deleteTask(int taskId) async {
    try {
      final response  = await _dio.delete(
        '/tasks/$taskId'
      );
      if(response.statusCode == 200){
        final data = response.data;
        return data['data'] == 'success';
      } else {
        throw Exception('Failed to delete task: ${response.statusCode}');
      }
    }on DioException catch(e){
      if(e.response != null){
        throw Exception('server Error: ${e.response?.data['message']}');
      }else {
        throw Exception('Network Error: ${e.message}');
      }
    }
  }


}





















