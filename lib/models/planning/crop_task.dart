class CropTask {
  final int id;
  final int planningId;
  final String taskType;
  final String taskDate;
  final String status;
  final int cropId;
  final String cropName;

  CropTask({
    required this.id,
    required this.planningId,
    required this.taskType,
    required this.taskDate,
    required this.status,
    required this.cropId,
    required this.cropName,
  });

  factory CropTask.fromJson(Map<String, dynamic> json) {
    return CropTask(
      id: json['id'] ?? 0,
      planningId: json['planning_id'] ?? 0,
      taskType: json['task_type'] ?? '',
      taskDate: json['task_date'] ?? '',
      status: json['status'] ?? 'pending',
      cropId: json['crop_id'] ?? 0,
      cropName: json['crop_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planning_id': planningId,
      'task_type': taskType,
      'task_date': taskDate,
    };
  }
}