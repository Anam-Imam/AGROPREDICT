import 'package:flutter/material.dart';

import '../disease_detection_screen.dart';
// import '../fetilizer_form.dart';


class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome to AgroPredict",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "This app helps farmers detect plant diseases early and get advice "
                  "to protect crops. It also provides fertilizer recommendations "
                  "to improve crop yield and reduce costs.",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 40),

            Card(
              color: Colors.green.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: InkWell(
                onTap: () {
                  // Navigate to Disease Detection Page
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> DiseaseDetectionScreen()));
                },
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const Icon(Icons.camera_alt,
                          size: 40, color: Colors.green),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Disease Detection",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Upload plant leaf images to identify "
                                  "diseases and get treatment advice instantly.",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Card(
            //   color: Colors.yellow.shade100,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(15),
            //   ),
            //   elevation: 4,
            //   child: InkWell(
            //     onTap: () {
            //       // Navigate to Fertilizer Recommendation Page
            //       Navigator.push(context, MaterialPageRoute(builder: (context)=>FertilizerForm()));

            //     },
            //     borderRadius: BorderRadius.circular(15),
            //     child: Padding(
            //       padding: const EdgeInsets.all(20),
            //       child: Row(
            //         children: [
            //           const Icon(Icons.eco, size: 40, color: Colors.brown),
            //           const SizedBox(width: 20),
            //           Expanded(
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: const [
            //                 Text(
            //                   "Fertilizer Recommendation",
            //                   style: TextStyle(
            //                       fontSize: 18, fontWeight: FontWeight.bold),
            //                 ),
            //                 SizedBox(height: 5),
            //                 Text(
            //                   "Get personalized fertilizer advice "
            //                       "based on your crop type and soil condition.",
            //                   style: TextStyle(fontSize: 14),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
