// models/geography_model.dart
class Geography {
  final int censusStateId;
  final String censusStateName;
  final int censusDistrictId;
  final String censusDistrictName;

  Geography({
    required this.censusStateId,
    required this.censusStateName,
    required this.censusDistrictId,
    required this.censusDistrictName,
  });

  factory Geography.fromJson(Map<String, dynamic> json) {
    return Geography(
      censusStateId: json['census_state_id'],
      censusStateName: json['census_state_name'],
      censusDistrictId: json['census_district_id'],
      censusDistrictName: json['census_district_name'],
    );
  }
}

class GeographyResponse {
  final String type;
  final String message;
  final List<Geography> data;

  GeographyResponse({
    required this.type,
    required this.message,
    required this.data,
  });

  factory GeographyResponse.fromJson(Map<String, dynamic> json) {
    return GeographyResponse(
      type: json['type'],
      message: json['message'],
      data: (json['data'] as List).map((e) => Geography.fromJson(e)).toList(),
    );
  }
}