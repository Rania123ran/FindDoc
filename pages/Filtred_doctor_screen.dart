// lib/screens/filtered_doctors_screen.dart

import 'package:flutter/material.dart';
import '../model/doctor.dart';
import '../services/doctor_service.dart';
import 'doctor_detail_screen.dart';

class FilteredDoctorsScreen extends StatelessWidget {
  final String category;
  final DoctorService _doctorService = DoctorService();

  FilteredDoctorsScreen({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$category Specialists'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: StreamBuilder<List<Doctor>>(
        stream: _doctorService.getDoctors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No doctors found'));
          }

          // Filter doctors by category
          final filteredDoctors = snapshot.data!
              .where((doctor) => doctor.type == category)
              .toList();

          if (filteredDoctors.isEmpty) {
            return Center(
              child: Text('No doctors found in $category category'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filteredDoctors.length,
            itemBuilder: (context, index) {
              final doctor = filteredDoctors[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),

                  title: Text(
                    doctor.name ?? 'Unknown Doctor',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(doctor.type ?? ''),
                      const SizedBox(height: 4),

                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => DoctorDetailScreen(doctor: doctor),
                    ));
                    // Navigate to doctor detail screen if you have one
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}