class Commodity {
  final int commodityId;
  final String commodityName;

  Commodity({
    required this.commodityId,
    required this.commodityName,
  });

  factory Commodity.fromJson(Map<String, dynamic> json) {
    return Commodity(
      commodityId: json['commodity_id'],
      commodityName: json['commodity_name'],
    );
  }
}

class CommodityResponse {
  final String type;
  final String message;
  final List<Commodity> data;

  CommodityResponse({
    required this.type,
    required this.message,
    required this.data,
  });

  factory CommodityResponse.fromJson(Map<String, dynamic> json) {
    return CommodityResponse(
      type: json['type'],
      message: json['message'],
      data: (json['data'] as List).map((e) => Commodity.fromJson(e)).toList(),
    );
  }
}