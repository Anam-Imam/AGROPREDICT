class Crop {
  final int id;
  final String name;
  final String idealSeason;
  final int durationDays;
  final String idealSowingPeriod;

  Crop({
    required this.id,
    required this.name,
    required this.idealSeason,
    required this.durationDays,
    required this.idealSowingPeriod,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'],
      name: json['name'],
      idealSeason: json['ideal_season'],
      durationDays: json['duration_days'],
      idealSowingPeriod: json['ideal_sowing_period'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ideal_season': idealSeason,
      'duration_days': durationDays,
      'ideal_sowing_period': idealSowingPeriod,
    };
  }
}