// bloc/price_event.dart
import 'package:equatable/equatable.dart';

abstract class PriceEvent extends Equatable {
  const PriceEvent();

  @override
  List<Object> get props => [];
}

class LoadCommodities extends PriceEvent {}

class LoadGeographies extends PriceEvent {}

class LoadMarkets extends PriceEvent {
  final int commodityId;
  final int stateId;
  final int districtId;

  const LoadMarkets({
    required this.commodityId,
    required this.stateId,
    required this.districtId,
  });

  @override
  List<Object> get props => [commodityId, stateId, districtId];
}

class LoadPrices extends PriceEvent {
  final int commodityId;
  final int stateId;
  final List<int> districtId;
  final List<int> marketId;
  final String fromDate;
  final String toDate;

  const LoadPrices({
    required this.commodityId,
    required this.stateId,
    required this.districtId,
    required this.marketId,
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object> get props => [
    commodityId,
    stateId,
    districtId,
    marketId,
    fromDate,
    toDate,
  ];
}