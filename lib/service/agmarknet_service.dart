import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'package:smart_agri_app/config.dart';

import '../models/market/commodity.dart';
import '../models/market/geography.dart';
import '../models/market/market.dart';
import '../models/market/price.dart';

class AgmarknetService {
  late Dio _dio;

  AgmarknetService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.ceda.ashoka.edu.in/v1/agmarknet/',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',

          // IMPORTANT
          'Authorization':
              'Bearer ${Config.agmarknetAPIKey}',
        },
      ),
    );
  }

  // ==========================
  // GET COMMODITIES
  // ==========================
  Future<List<Commodity>> getCommodities() async {
    try {
      final response = await _dio.get('commodities');

      debugPrint("COMMODITIES RESPONSE:");
      debugPrint(response.data.toString());

      // CHECK RESPONSE FORMAT
      if (response.data == null) {
        throw Exception("Empty response");
      }

      final output = response.data['output'];

      if (output == null) {
        throw Exception("No output field found");
      }

      final commodityResponse =
          CommodityResponse.fromJson(output);

      return commodityResponse.data;
    } on DioException catch (e) {
      debugPrint("DIO ERROR:");
      debugPrint(e.response?.data.toString());
      debugPrint(e.message);

      rethrow;
    } catch (e) {
      debugPrint("GENERAL ERROR:");
      debugPrint(e.toString());

      rethrow;
    }
  }

  // ==========================
  // GET GEOGRAPHIES
  // ==========================
  Future<List<Geography>> getGeographies() async {
    try {
      final response =
          await _dio.get('geographies');

      debugPrint(response.data.toString());

      final geographyResponse =
          GeographyResponse.fromJson(
        response.data['output'],
      );

      return geographyResponse.data;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // ==========================
  // GET MARKETS
  // ==========================
  Future<List<Market>> getMarkets({
    required int commodityId,
    required int stateId,
    required int districtId,
  }) async {
    try {
      final response = await _dio.post(
        'markets',
        data: {
          "commodity_id": commodityId,
          "state_id": stateId,
          "district_id": districtId,
          "indicator": "price",
        },
      );

      debugPrint(response.data.toString());

      final marketResponse =
          MarketResponse.fromJson(
        response.data['output'],
      );

      return marketResponse.data;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // ==========================
  // GET PRICES
  // ==========================
  Future<List<PriceData>> getPrices({
    required int commodityId,
    required int stateId,
    required List<int> districtId,
    required List<int> marketId,
    required String fromDate,
    required String toDate,
  }) async {
    try {
      final response = await _dio.post(
        'prices',
        data: {
          "commodity_id": commodityId,
          "state_id": stateId,
          "district_id": districtId,
          "market_id": marketId,
          "from_date": fromDate,
          "to_date": toDate,
        },
      );

      debugPrint(response.data.toString());

      final priceResponse =
          PriceResponse.fromJson(
        response.data['output'],
      );

      return priceResponse.data;
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }
}