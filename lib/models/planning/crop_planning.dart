class CropPlanning {
  final int id;
  final int userId;
  final int cropId;
  final String startDate;
  final String expectedHarvestDate;
  final String? notes;
  final bool irrigationReminder;
  final bool fertilizerReminder;
  final String? cropName; // Make this nullable
  final String? createdAt; // Add this field

  CropPlanning({
    required this.id,
    required this.userId,
    required this.cropId,
    required this.startDate,
    required this.expectedHarvestDate,
    this.notes,
    required this.irrigationReminder,
    required this.fertilizerReminder,
    this.cropName, // Make this optional
    this.createdAt, // Make this optional
  });

  factory CropPlanning.fromJson(Map<String, dynamic> json) {
    return CropPlanning(
      id: json['id'],
      userId: json['user_id'],
      cropId: json['crop_id'],
      startDate: json['start_date'],
      expectedHarvestDate: json['expected_harvest_date'],
      notes: json['notes'],
      irrigationReminder: json['irrigation_reminder'],
      fertilizerReminder: json['fertilizer_reminder'],
      cropName: json['crop_name'], // This can be null now
      createdAt: json['created_at'], // This can be null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crop_id': cropId,
      'start_date': startDate,
      'expected_harvest_date': expectedHarvestDate,
      'notes': notes,
      'irrigation_reminder': irrigationReminder,
      'fertilizer_reminder': fertilizerReminder,
    };
  }
}