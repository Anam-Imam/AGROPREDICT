import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/planning/crop.dart';
import '../models/planning/crop_planning.dart';
import '../service/crop_service.dart';

class CreatePlanningDialog extends StatefulWidget {
  final CropService cropService;
  final VoidCallback onPlanningCreated;

  const CreatePlanningDialog({
    super.key,
    required this.cropService,
    required this.onPlanningCreated,
  });

  @override
  State<CreatePlanningDialog> createState() => _CreatePlanningDialogState();
}

class _CreatePlanningDialogState extends State<CreatePlanningDialog> {
  final _formKey = GlobalKey<FormState>();
  late Future<List<Crop>> futureCrops;

  int? _selectedCropId;
  DateTime? _startDate;
  DateTime? _expectedHarvestDate;
  String _notes = '';
  bool _irrigationReminder = false;
  bool _fertilizerReminder = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    futureCrops = widget.cropService.getCropLibrary();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Create Crop Plan',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
      ),
      content: FutureBuilder<List<Crop>>(
        future: futureCrops,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 250,
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return SizedBox(
              height: 250,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          futureCrops = widget.cropService.getCropLibrary();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const SizedBox(
              height: 250,
              child: Center(child: Text('No crops available')),
            );
          } else {
            return SizedBox(
              width: double.maxFinite,
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Select Crop
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Select Crop',
                        labelStyle: TextStyle(fontSize: 14),
                        filled: true,
                        fillColor: Colors.green.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      value: _selectedCropId,
                      items: snapshot.data!
                          .map(
                            (crop) => DropdownMenuItem<int>(
                              value: crop.id,
                              child: Text(crop.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCropId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a crop';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Start Date
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.calendar_today,
                          color: Colors.blue,
                          size: 18,
                        ),
                        title: Text(
                          _startDate == null
                              ? 'Select Start Date'
                              : 'Start: ${DateFormat('dd/MM/yyyy').format(_startDate!)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              _startDate = selectedDate;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Harvest Date
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.agriculture,
                          color: Colors.orange,
                          size: 18,
                        ),
                        title: Text(
                          _expectedHarvestDate == null
                              ? 'Select Expected Harvest Date'
                              : 'Harvest: ${DateFormat('dd/MM/yyyy').format(_expectedHarvestDate!)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(
                              const Duration(days: 30),
                            ),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              _expectedHarvestDate = selectedDate;
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Notes
                    TextFormField(
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        labelText: 'Notes',
                        filled: true,
                        fillColor: Colors.grey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        _notes = value;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Switches
                    SwitchListTile(
                      title: Text(
                        '💧 Irrigation Reminder',
                        style: TextStyle(fontSize: 14),
                      ),
                      value: _irrigationReminder,
                      onChanged: (value) {
                        setState(() {
                          _irrigationReminder = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      title: const Text(
                        '🌿 Fertilizer Reminder',
                        style: TextStyle(fontSize: 14),
                      ),
                      value: _fertilizerReminder,
                      onChanged: (value) {
                        setState(() {
                          _fertilizerReminder = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      actions: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.grey.shade700),
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          ),
          onPressed: _isSubmitting ? null : _submitForm,
          icon: _isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Icon(Icons.check_circle, color: Colors.white),
          label: Text(
            _isSubmitting ? 'Creating...' : 'Create Plan',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_startDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a start date')),
        );
        return;
      }

      if (_expectedHarvestDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a harvest date')),
        );
        return;
      }

      setState(() {
        _isSubmitting = true;
      });

      final planning = CropPlanning(
        id: 0,
        userId: 0,
        cropId: _selectedCropId!,
        startDate: _startDate!.toIso8601String(),
        expectedHarvestDate: _expectedHarvestDate!.toIso8601String(),
        notes: _notes.isNotEmpty ? _notes : null,
        irrigationReminder: _irrigationReminder,
        fertilizerReminder: _fertilizerReminder,
        cropName: '',
      );

      try{
        await widget.cropService.createCropPlanning(planning);
        if(mounted) {
          Navigator.of(context).pop();
          widget.onPlanningCreated();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Crop plan created successfully!!!')),
          );
        }

      } catch (e){
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: $e')),
          );
        }
      } finally {
        if(mounted) setState(() => _isSubmitting = false);
      }


    }
  }
}
