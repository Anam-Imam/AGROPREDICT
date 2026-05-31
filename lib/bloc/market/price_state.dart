// bloc/price_state.dart

import 'package:equatable/equatable.dart';

import '../../models/market/commodity.dart';
import '../../models/market/geography.dart';
import '../../models/market/market.dart';
import '../../models/market/price.dart';

class PriceState extends Equatable {
  final List<Commodity> commodities;
  final List<Geography> geographies;
  final List<Market> markets;
  final List<PriceData> prices;
  final bool loading;
  final String? error;

  const PriceState({
    this.commodities = const [],
    this.geographies = const [],
    this.markets = const [],
    this.prices = const [],
    this.loading = false,
    this.error,
  });

  PriceState copyWith({
    List<Commodity>? commodities,
    List<Geography>? geographies,
    List<Market>? markets,
    List<PriceData>? prices,
    bool? loading,
    String? error,
  }) {
    return PriceState(
      commodities: commodities ?? this.commodities,
      geographies: geographies ?? this.geographies,
      markets: markets ?? this.markets,
      prices: prices ?? this.prices,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [commodities, geographies, markets, prices, loading, error];
}
