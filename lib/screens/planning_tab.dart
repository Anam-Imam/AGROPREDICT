import 'package:flutter/material.dart';
import 'package:smart_agri_app/screens/planning_details_screen.dart';

import '../models/planning/crop_planning.dart';
import '../service/crop_service.dart';
import '../utils/create_planning_dialog.dart';

class PlanningTab extends StatefulWidget {
  final CropService cropService;

  const PlanningTab({super.key, required this.cropService});

  @override
  State<PlanningTab> createState() => _PlanningTabState();
}

class _PlanningTabState extends State<PlanningTab> {
  late Future<List<CropPlanning>> futurePlanning;

  @override
  void initState() {
    super.initState();
    futurePlanning = widget.cropService.getCropPlannings();
  }

  void _refreshPlanning() {
    setState(() {
      futurePlanning = widget.cropService.getCropPlannings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            _refreshPlanning();
            await futurePlanning;
          },
          child: FutureBuilder<List<CropPlanning>>(
            future: futurePlanning,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${snapshot.error}'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshPlanning,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No planning records yet.'),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _showCreatePlanningDialog,
                        child: const Text('Create Your First Plan'),
                      ),
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final planning = snapshot.data![index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          // navigate to tasks list for selected planning ID
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context)=>
                                PlanningDetailsScreen(planning: planning)
                            )
                          );

                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [

                              // Planning info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Crop name
                                    Text(
                                      planning.cropName ?? 'Unknown Crop',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    Row(
                                      children: [
                                        // Start Date
                                        Expanded(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.play_circle_outline,
                                                  size: 12, color: Colors.grey),
                                              const SizedBox(width: 6),
                                              Text(
                                                "Start: ${_formatDate(planning.startDate)}",
                                                style: const TextStyle(color: Colors.black54, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        // Expected Harvest
                                        Expanded(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.calendar_month,
                                                  size: 12, color: Colors.grey),
                                              const SizedBox(width: 6),
                                              Text(
                                                "Harvest: ${_formatDate(planning.expectedHarvestDate)}",
                                                style: const TextStyle(color: Colors.black54, fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),


                                      ],
                                    ),

                                    const SizedBox(height: 4),
                                    // Notes (if available)
                                    if (planning.notes != null && planning.notes!.isNotEmpty)
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.note_alt,
                                              size: 12, color: Colors.grey),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              planning.notes!,
                                              style: TextStyle(
                                                color: Colors.green.shade600,
                                                fontSize: 12,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    const SizedBox(height: 6),

                                    // Reminders Row
                                    Row(
                                      children: [
                                        if (planning.irrigationReminder)
                                          Container(
                                            margin: const EdgeInsets.only(right: 8),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade50,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: const [
                                                Icon(Icons.water_drop,
                                                    size: 14, color: Colors.blue),
                                                SizedBox(width: 4),
                                                Text(
                                                  "Irrigation",
                                                  style: TextStyle(
                                                      fontSize: 12, color: Colors.blue),
                                                ),
                                              ],
                                            ),
                                          ),
                                        if (planning.fertilizerReminder)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade50,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              children: const [
                                                Icon(Icons.eco,
                                                    size: 14, color: Colors.green),
                                                SizedBox(width: 4),
                                                Text(
                                                  "Fertilizer",
                                                  style: TextStyle(
                                                      fontSize: 12, color: Colors.green),
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            onPressed: _showCreatePlanningDialog,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }


  void _showCreatePlanningDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreatePlanningDialog(
          cropService: widget.cropService,
          onPlanningCreated: _refreshPlanning,
        );
      }
    );
  }

}