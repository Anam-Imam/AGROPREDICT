class PriceData {
  final DateTime date;
  final int commodityId;
  final int censusStateId;
  final int censusDistrictId;
  final int marketId;
  final double minPrice;
  final double maxPrice;
  final double modalPrice;

  PriceData({
    required this.date,
    required this.commodityId,
    required this.censusStateId,
    required this.censusDistrictId,
    required this.marketId,
    required this.minPrice,
    required this.maxPrice,
    required this.modalPrice,
  });

  factory PriceData.fromJson(Map<String, dynamic> json) {
    return PriceData(
      date: DateTime.parse(json['date']),
      commodityId: json['commodity_id'],
      censusStateId: json['census_state_id'],
      censusDistrictId: json['census_district_id'],
      marketId: json['market_id'],
      minPrice: json['min_price'].toDouble(),
      maxPrice: json['max_price'].toDouble(),
      modalPrice: json['modal_price'].toDouble(),
    );
  }
}

class PriceResponse {
  final String type;
  final String message;
  final List<PriceData> data;

  PriceResponse({
    required this.type,
    required this.message,
    required this.data,
  });

  factory PriceResponse.fromJson(Map<String, dynamic> json) {
    return PriceResponse(
      type: json['type'],
      message: json['message'],
      data: (json['data'] as List).map((e) => PriceData.fromJson(e)).toList(),
    );
  }
}