import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/fertilizer/fertilizer_bloc.dart';
import '../bloc/fertilizer/fertilizer_event.dart';
import '../bloc/fertilizer/fertilizer_state.dart';

class FertilizerForm extends StatefulWidget {
  @override
  _FertilizerFormState createState() => _FertilizerFormState();
}

class _FertilizerFormState extends State<FertilizerForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nController = TextEditingController();
  final TextEditingController _pController = TextEditingController();
  final TextEditingController _kController = TextEditingController();
  final TextEditingController _phController = TextEditingController();
  final TextEditingController _organicCarbonController =
      TextEditingController();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _rainfallController = TextEditingController();

  String _selectedCrop = '';
  String _selectedStage = '';
  String _selectedSoilType = '';

  @override
  void initState() {
    super.initState();
    context.read<FertilizerBloc>().add(FetchDropdowns());
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) return;

    final formData = {
      'crop': _selectedCrop,
      'stage': _selectedStage,
      'soil_type': _selectedSoilType,
      'N': double.parse(_nController.text),
      'P': double.parse(_pController.text),
      'K': double.parse(_kController.text),
      'pH': double.parse(_phController.text),
      'organic_carbon': double.parse(_organicCarbonController.text),
      'temp': double.parse(_tempController.text),
      'rainfall': double.parse(_rainfallController.text),
    };

    context.read<FertilizerBloc>().add(GetRecommendation(formData));
  }

  /// FIXED DIALOG
  void _showRecommendationDialog(
      BuildContext context,
      String recommendation,
      ) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Row(
                  children: [
                    Icon(
                      Icons.eco,
                      color: Colors.green[700],
                      size: 28,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        'Fertilizer Recommendation',
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                /// RECOMMENDATION TEXT
                Text(
                  recommendation,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 20),

                /// BUTTON
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('OK'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FertilizerBloc, FertilizerState>(
      listener: (context, state) {
        if (state is FertilizerRecommendationSuccess) {
          _showRecommendationDialog(context, state.recommendation);
        } else if (state is FertilizerError) {
          _showRecommendationDialog(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        List<String> crops = [];
        List<String> stages = [];
        List<String> soilTypes = [];

        if (state is FertilizerDropdownsLoaded) {
          crops = state.crops;
          stages = state.stages;
          soilTypes = state.soilTypes;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Fertilizer Recommendation',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.green.shade50,
                  Colors.white,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [

                    /// HEADER BOX
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.eco,
                            color: Colors.green.shade800,
                            size: 32,
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              'Enter your soil and crop details to get personalized fertilizer recommendations',
                              style: TextStyle(
                                color: Colors.green.shade900,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// CROP INFO
                    Text(
                      'Crop Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade800,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            'Crop',
                            crops,
                            _selectedCrop,
                                (val) => setState(() => _selectedCrop = val!),
                          ),
                        ),

                        const SizedBox(width: 4),

                        Expanded(
                          child: _buildDropdown(
                            'Growth Stage',
                            stages,
                            _selectedStage,
                                (val) => setState(() => _selectedStage = val!),
                          ),
                        ),

                        const SizedBox(width: 4),

                        Expanded(
                          child: _buildDropdown(
                            'Soil Type',
                            soilTypes,
                            _selectedSoilType,
                                (val) =>
                                setState(() => _selectedSoilType = val!),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    /// SOIL PROPERTIES
                    Text(
                      'Soil Properties',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade800,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      _nController,
                      'Nitrogen (N) kg/ha',
                      Icons.water_drop,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      _pController,
                      'Phosphorus (P) kg/ha',
                      Icons.water_drop,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      _kController,
                      'Potassium (K) kg/ha',
                      Icons.water_drop,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      _phController,
                      'Soil pH',
                      Icons.thermostat,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      _organicCarbonController,
                      'Organic Carbon (%)',
                      Icons.grass,
                    ),

                    const SizedBox(height: 24),

                    /// WEATHER
                    Text(
                      'Weather Conditions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.green.shade800,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      _tempController,
                      'Temperature (°C)',
                      Icons.device_thermostat,
                    ),

                    const SizedBox(height: 16),

                    _buildTextField(
                      _rainfallController,
                      'Rainfall (mm)',
                      Icons.cloudy_snowing,
                    ),

                    const SizedBox(height: 32),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                        state is FertilizerLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: state is FertilizerLoading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                            AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                            : const Text(
                          'Get Recommendation',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdown(
      String label,
      List<String> items,
      String value,
      Function(String?) onChanged,
      ) {
    return DropdownButtonFormField<String>(
      value: value.isEmpty ? null : value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      items: items
          .map(
            (e) => DropdownMenuItem(
          value: e,
          child: Text(e),
        ),
      )
          .toList(),
      onChanged: onChanged,
      isExpanded: true,
      validator: (val) =>
      val == null ? 'Please select $label' : null,
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon,
      ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: Colors.white,
      ),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Please enter a value';
        }

        if (double.tryParse(val) == null) {
          return 'Please enter a valid number';
        }

        return null;
      },
    );
  }
}