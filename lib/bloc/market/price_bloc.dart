// bloc/price_bloc.dart
import 'dart:async';
import '../../bloc/market/price_event.dart';
import '../../bloc/market/price_state.dart';
import 'package:bloc/bloc.dart';

import '../../service/agmarknet_service.dart';

class PriceBloc extends Bloc<PriceEvent, PriceState> {
  final AgmarknetService apiService;

  PriceBloc({required this.apiService}) : super(const PriceState()) {
    on<LoadCommodities>(_onLoadCommodities);
    on<LoadGeographies>(_onLoadGeographies);
    on<LoadMarkets>(_onLoadMarkets);
    on<LoadPrices>(_onLoadPrices);
  }

  Future<void> _onLoadCommodities(
      LoadCommodities event,
      Emitter<PriceState> emit,
      ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final commodities = await apiService.getCommodities();
      emit(state.copyWith(commodities: commodities, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: 'Failed to load commodities: $e'));
    }
  }

  Future<void> _onLoadGeographies(
      LoadGeographies event,
      Emitter<PriceState> emit,
      ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final geographies = await apiService.getGeographies();
      emit(state.copyWith(geographies: geographies, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: 'Failed to load geographies: $e'));
    }
  }

  Future<void> _onLoadMarkets(
      LoadMarkets event,
      Emitter<PriceState> emit,
      ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final markets = await apiService.getMarkets(
        commodityId: event.commodityId,
        stateId: event.stateId,
        districtId: event.districtId,
      );
      emit(state.copyWith(markets: markets, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: 'Failed to load markets: $e'));
    }
  }

  Future<void> _onLoadPrices(
      LoadPrices event,
      Emitter<PriceState> emit,
      ) async {
    emit(state.copyWith(loading: true, error: null));
    try {
      final prices = await apiService.getPrices(
        commodityId: event.commodityId,
        stateId: event.stateId,
        districtId: event.districtId,
        marketId: event.marketId,
        fromDate: event.fromDate,
        toDate: event.toDate,
      );
      emit(state.copyWith(prices: prices, loading: false));
    } catch (e) {
      emit(state.copyWith(loading: false, error: 'Failed to load prices: $e'));
    }
  }
}
