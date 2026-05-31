import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/market/price_bloc.dart';
import '../../bloc/market/price_event.dart';
import '../../bloc/market/price_state.dart';
import '../../models/market/commodity.dart';
import '../../models/market/geography.dart';
import '../../models/market/market.dart';
import '../../models/market/price.dart';


class MarketPricesScreen extends StatefulWidget {
  const MarketPricesScreen({super.key});

  @override
  State<MarketPricesScreen> createState() => _MarketPricesScreenState();
}

class _MarketPricesScreenState extends State<MarketPricesScreen> {
  Commodity? _selectedCommodity;
  Geography? _selectedState;
  Geography? _selectedDistrict;
  Market? _selectedMarket;
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void initState() {
    super.initState();
    context.read<PriceBloc>().add(LoadCommodities());
    context.read<PriceBloc>().add(LoadGeographies());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PriceBloc, PriceState>(
        builder: (context, state) {
          if (state.loading && state.prices.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.prices.isEmpty) {
            return const Center(
              child: Text(
                "No Data to Display",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return _buildPriceDisplay(state.prices);
        },
      ),

      floatingActionButton: BlocBuilder<PriceBloc, PriceState>(
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () => _openFilterDialog(state),
            backgroundColor: Colors.green[700],
            child: const Icon(Icons.filter_alt_outlined, color: Colors.white),
          );
        },
      ),
    );
  }


  void _openFilterDialog(PriceState state) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: StatefulBuilder(
            builder: (ctx, setDialogState) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Filters",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Commodity Dropdown
                    _buildDropdown<Commodity>(
                      items: state.commodities,
                      value: _selectedCommodity,
                      onChanged: (value) {
                        setDialogState(() => _selectedCommodity = value);
                        // reset markets if commodity changes
                        _selectedMarket = null;
                      },
                      hint: 'Select Commodity',
                      displayString: (c) => c.commodityName,
                    ),
                    const SizedBox(height: 12),

                    // State
                    _buildDropdown<Geography>(
                      items: state.geographies
                          .map((g) => g.censusStateId)
                          .toSet()
                          .map(
                            (id) => state.geographies.firstWhere(
                              (g) => g.censusStateId == id,
                        ),
                      )
                          .toList(),
                      value: _selectedState,
                      onChanged: (value) {
                        setDialogState(() {
                          _selectedState = value;
                          _selectedDistrict = null;
                          _selectedMarket = null;
                        });
                      },
                      hint: 'Select State',
                      displayString: (g) => g.censusStateName,
                    ),
                    const SizedBox(height: 12),

                    // District
                    if (_selectedState != null)
                      _buildDropdown<Geography>(
                        items: state.geographies
                            .where(
                              (g) =>
                          g.censusStateId ==
                              _selectedState!.censusStateId,
                        )
                            .toList(),
                        value: _selectedDistrict,
                        onChanged: (value) {
                          setDialogState(() {
                            _selectedDistrict = value;
                            _selectedMarket = null;
                          });

                          if (value != null && _selectedCommodity != null) {
                            // 👈 Trigger market load when district + commodity is selected
                            context.read<PriceBloc>().add(
                              LoadMarkets(
                                commodityId: _selectedCommodity!.commodityId,
                                stateId: _selectedState!.censusStateId,
                                districtId: value.censusDistrictId,
                              ),
                            );
                          }
                        },
                        hint: 'Select District',
                        displayString: (g) => g.censusDistrictName,
                      ),
                    const SizedBox(height: 12),

                    // Market Dropdown
                    if (_selectedDistrict != null)
                      BlocBuilder<PriceBloc, PriceState>(
                        builder: (context, state) {
                          if (state.loading && state.markets.isEmpty) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (state.markets.isEmpty) {
                            return const Text(
                              "No markets available",
                              style: TextStyle(color: Colors.redAccent),
                            );
                          }
                          return _buildDropdown<Market>(
                            items: state.markets,
                            value: _selectedMarket,
                            onChanged: (value) =>
                                setDialogState(() => _selectedMarket = value),
                            hint: 'Select Market',
                            displayString: (m) => m.marketName,
                          );
                        },
                      ),

                    const SizedBox(height: 12),

                    // Date pickers row
                    Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setDialogState(() => _fromDate = date);
                              }
                            },
                            label: Text(
                              _fromDate == null
                                  ? 'From Date'
                                  : _formatDate(_fromDate!), // yyyy-MM-dd
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton.icon(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setDialogState(() => _toDate = date);
                              }
                            },
                            label: Text(
                              _toDate == null
                                  ? 'To Date'
                                  : _formatDate(_toDate!),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        _loadPrices();
                        Navigator.pop(ctx);
                      },
                      child: Text(
                        "Load Prices",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _loadPrices() {
    if (_selectedCommodity != null &&
        _selectedState != null &&
        _selectedDistrict != null &&
        _selectedMarket != null &&
        _fromDate != null &&
        _toDate != null) {
      context.read<PriceBloc>().add(
        LoadPrices(
          commodityId: _selectedCommodity!.commodityId,
          stateId: _selectedState!.censusStateId,
          districtId: [_selectedDistrict!.censusDistrictId],
          marketId: [_selectedMarket!.marketId],
          // 👈 use selected market
          fromDate: _fromDate!.toIso8601String().split('T')[0],
          toDate: _toDate!.toIso8601String().split('T')[0],
        ),
      );
    }
  }


  Widget _buildDropdown<T>({
    required List<T> items,
    required T? value,
    required Function(T?) onChanged,
    required String hint,
    required String Function(T) displayString,
  }) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      value: value,
      onChanged: onChanged,
      items: items.map((T item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(displayString(item)),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: hint,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildPriceDisplay(List<PriceData> prices) {
    if (prices.isEmpty) {
      return const Center(
        child: Text(
          'No price data available for selected criteria',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      children: [
        Container(
          height: 280,
          padding: const EdgeInsets.all(10),
          child: LineChart(
            LineChartData(
              backgroundColor: Colors.white,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.withValues(alpha: 0.2),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 4,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < prices.length) {
                        final date = prices[index].date;
                        return Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '${date.day}/${date.month}',
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    interval: 100,
                    getTitlesWidget: (value, meta) => Text(
                      "₹${value.toInt()}",
                      style: const TextStyle(fontSize: 9),
                    ),
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),

              /// 👇 Three lines: min, max, modal
              lineBarsData: [
                LineChartBarData(
                  spots: prices
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value.minPrice))
                      .toList(),
                  isCurved: true,
                  color: Colors.redAccent,
                  barWidth: 2,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Colors.redAccent,
                        strokeWidth: 1,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                ),
                LineChartBarData(
                  spots: prices
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value.maxPrice))
                      .toList(),
                  isCurved: true,
                  color: Colors.blueAccent,
                  barWidth: 2,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Colors.blueAccent,
                        strokeWidth: 1,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                ),
                LineChartBarData(
                  spots: prices
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value.modalPrice))
                      .toList(),
                  isCurved: true,
                  color: Colors.green,
                  barWidth: 3,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: Colors.green,
                        strokeWidth: 1,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                ),
              ],
            ),

          ),
        ),

        /// 👇 Legend for Min/Max/Modal
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem(Colors.redAccent, "Min Price"),
              const SizedBox(width: 16),
              _buildLegendItem(Colors.blueAccent, "Max Price"),
              const SizedBox(width: 16),
              _buildLegendItem(Colors.green, "Modal Price"),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // List of prices
        Expanded(
          child: ListView.builder(
            itemCount: prices.length,
            itemBuilder: (context, index) {
              final price = prices[index];
              return Card(
                color: Colors.green.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Date + Modal Price Chip
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(price.date),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Chip(
                            backgroundColor: Colors.white,
                            label: Text(
                              "₹${price.modalPrice.toStringAsFixed(0)}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Min / Max / Modal Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _priceInfo(
                            Icons.trending_down,
                            "Min",
                            price.minPrice,
                            Colors.redAccent,
                          ),
                          _priceInfo(
                            Icons.trending_up,
                            "Max",
                            price.maxPrice,
                            Colors.blueAccent,
                          ),
                          _priceInfo(
                            Icons.equalizer,
                            "Modal",
                            price.modalPrice,
                            Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Legend widget
  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _priceInfo(IconData icon, String label, double value, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          "₹${value.toStringAsFixed(0)}",
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }


}
