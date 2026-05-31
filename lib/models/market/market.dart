// models/market_model.dart
class Market {
  final int censusStateId;
  final int censusDistrictId;
  final int marketId;
  final String marketName;

  Market({
    required this.censusStateId,
    required this.censusDistrictId,
    required this.marketId,
    required this.marketName,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      censusStateId: json['census_state_id'],
      censusDistrictId: json['census_district_id'],
      marketId: json['market_id'],
      marketName: json['market_name'],
    );
  }
}

class MarketResponse {
  final String type;
  final String message;
  final List<Market> data;

  MarketResponse({
    required this.type,
    required this.message,
    required this.data,
  });

  factory MarketResponse.fromJson(Map<String, dynamic> json) {
    return MarketResponse(
      type: json['type'],
      message: json['message'],
      data: (json['data'] as List).map((e) => Market.fromJson(e)).toList(),
    );
  }
}