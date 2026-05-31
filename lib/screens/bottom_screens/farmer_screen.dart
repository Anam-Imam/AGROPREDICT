import 'package:flutter/material.dart';
import 'package:smart_agri_app/local/pref_helper.dart';
import 'package:smart_agri_app/service/crop_service.dart';

import '../crop_library_tab.dart';
import '../planning_tab.dart';

class FarmerScreen extends StatefulWidget {
  const FarmerScreen({super.key});

  @override
  State<FarmerScreen> createState() => _FarmerScreenState();
}

class _FarmerScreenState extends State<FarmerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late CropService _cropService;
  String? token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadToken();
  }

  Future<void> _loadToken() async {
    final savedToken = await PrefHelper.getToken();
    setState(() {
      token = savedToken;
      _cropService = CropService(authToken: token!);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  Widget _buildCustomTabBar() {
    return Container(
      decoration: BoxDecoration(color: Colors.transparent),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.green,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 5,
        dividerColor: Colors.green,
        dividerHeight: 1,
        labelColor: Colors.green,
        unselectedLabelColor: Colors.grey.shade400,
        tabs: const [
          Tab(text: 'Crop Library'),
          Tab(text: 'Planning'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: token == null
          ? Center(child: CircularProgressIndicator())
          : Column(children: [
            _buildCustomTabBar(),
        Expanded(
            child: TabBarView(
              controller: _tabController,
                children: [
                  CropLibraryTab(cropService: _cropService),
                  PlanningTab(cropService: _cropService),
                ]
            )
        )
      ]),
    );
  }
}
