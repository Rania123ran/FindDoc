import 'package:flutter/material.dart';
import '../model/doctor.dart';
import '../services/doctor_service.dart';
import '../widgets/doctor_list.dart';

class FavoriteDoctorsScreen extends StatelessWidget {
  final DoctorService _doctorService = DoctorService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Doctors'),
      ),
      body: StreamBuilder<List<Doctor>>(
        stream: _doctorService.getFavoriteDoctors(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final doctors = snapshot.data ?? [];
          if (doctors.isEmpty) {
            return Center(child: Text('No favorite doctors yet'));
          }

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              return DoctorCard(doctor: doctors[index], doctorService: _doctorService,);
            },
          );
        },
      ),
    );
  }
}