import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../local/pref_helper.dart';
import '../models/planning/crop_planning.dart';
import '../models/planning/crop_task.dart';
import '../service/crop_service.dart';
import '../utils/create_task_dialog.dart';

class PlanningDetailsScreen extends StatefulWidget {
  final CropPlanning planning;

  const PlanningDetailsScreen({super.key, required this.planning});

  @override
  State<PlanningDetailsScreen> createState() => _PlanningDetailsScreenState();
}

class _PlanningDetailsScreenState extends State<PlanningDetailsScreen> {
  late CropService _cropService;
  late Future<List<CropTask>> _futureTasks;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final savedToken = await PrefHelper.getToken();
    setState(() {
      token = savedToken;
      _cropService = CropService(authToken: token!);
      _futureTasks = _cropService.getTaskByPlanningId(widget.planning.id);
    });
  }

  void _refreshTasks() {
    setState(() {
      _futureTasks = _cropService.getTaskByPlanningId(widget.planning.id);
    });
  }

  void _showCreateTaskDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CreateTaskDialog(
          taskService: _cropService,
          planningId: widget.planning.id,
          onTaskCreated: _refreshTasks,
        );
      },
    );
  }

  Future<void> _updateTaskStatus(CropTask task, String status) async {
    try {
      await _cropService.updateTaskStatus(task.id, status);
      _refreshTasks();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Task marked as $status')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update task: $e')),
      );
    }
  }

  Future<void> _deleteTask(CropTask task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _cropService.deleteTask(task.id);
        _refreshTasks();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete task: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(widget.planning.cropName ?? 'Planning Details',
          style: TextStyle(fontWeight: FontWeight.w600),),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Planning details header card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.planning.cropName ?? 'Unknown Crop',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                      fontSize: 21
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.play_circle_outline,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text('Start: ${_formatDate(widget.planning.startDate)}'),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_month,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                        'Expected Harvest: ${_formatDate(widget.planning.expectedHarvestDate)}'),
                  ],
                ),
                if (widget.planning.notes != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.note_alt,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.planning.notes!,
                          style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    if (widget.planning.irrigationReminder)
                      Chip(
                        avatar: const Icon(Icons.water_drop,
                            size: 16, color: Colors.blue),
                        label: const Text('Irrigation'),
                        backgroundColor: Colors.blue.shade50,
                      ),
                    if (widget.planning.fertilizerReminder)
                      Chip(
                        avatar: const Icon(Icons.eco,
                            size: 16, color: Colors.green),
                        label: const Text('Fertilizer'),
                        backgroundColor: Colors.green.shade100,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Tasks',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          // Tasks list
          Expanded(
            child: FutureBuilder<List<CropTask>>(
              future: _futureTasks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return _buildError(snapshot.error.toString());
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final task = snapshot.data![index];
                      return _buildTaskItem(task);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTaskDialog,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildError(String error) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Error: $error'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _refreshTasks,
          child: const Text('Retry'),
        ),
      ],
    ),
  );

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('No tasks yet.'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _showCreateTaskDialog,
          child: const Text('Create First Task'),
        ),
      ],
    ),
  );

  Widget _buildTaskItem(CropTask task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Icon with background
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.green.shade50,
            child: _getTaskIcon(task.taskType),
          ),
          const SizedBox(width: 12),

          // Task details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.taskType,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: task.status == 'completed'
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      'Due: ${_formatDate(task.taskDate)}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.flag, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      task.status,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: task.status == 'completed'
                            ? Colors.green
                            : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Popup menu
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                _deleteTask(task);
              } else {
                _updateTaskStatus(task, value);
              }
            },
            itemBuilder: (context) => [
              if (task.status != 'completed')
                const PopupMenuItem(
                  value: 'completed',
                  child: Text('Mark as Completed'),
                ),
              if (task.status != 'pending')
                const PopupMenuItem(
                  value: 'pending',
                  child: Text('Mark as Pending'),
                ),
              const PopupMenuItem(
                value: 'delete',
                child: Text(
                  'Delete Task',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Icon _getTaskIcon(String taskType) {
    switch (taskType.toLowerCase()) {
      case 'sowing':
        return const Icon(Icons.agriculture, color: Colors.green);
      case 'irrigation':
        return const Icon(Icons.water_drop, color: Colors.blue);
      case 'fertilizing':
        return const Icon(Icons.eco, color: Colors.green);
      case 'harvesting':
        return const Icon(Icons.forest, color: Colors.brown);
      default:
        return const Icon(Icons.task, color: Colors.grey);
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
