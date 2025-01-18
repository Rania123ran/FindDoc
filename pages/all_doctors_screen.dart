// lib/screens/all_doctors_screen.dart

import 'package:flutter/material.dart';
import '../model/doctor.dart';
import '../services/doctor_service.dart';
import '../widgets/doctor_list.dart';

class AllDoctorsScreen extends StatelessWidget {
  final DoctorService _doctorService = DoctorService();

  AllDoctorsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Doctors'),
      ),
      body: StreamBuilder<List<Doctor>>(
        stream: _doctorService.getDoctors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No doctors found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return DoctorCard(doctor: snapshot.data![index], doctorService: _doctorService,);
            },
          );
        },
      ),
    );
  }
}