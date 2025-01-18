import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/doctor.dart';
import '../pages/doctor_detail_screen.dart';
import '../services/doctor_service.dart';

class DoctorList extends StatelessWidget {
  final DoctorService _doctorService = DoctorService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Doctor>>(
      stream: _doctorService.getDoctors(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final doctors = snapshot.data ?? [];
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doctor = doctors[index];
            return DoctorCard(
              doctor: doctor,
              doctorService: _doctorService, // Pass the service instance
            );
          },
        );
      },
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final DoctorService doctorService; // Add DoctorService field

  const DoctorCard({
    super.key,
    required this.doctor,
    required this.doctorService, // Add to constructor
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: doctor.photoUrl.isNotEmpty
              ? NetworkImage(doctor.photoUrl)
              : null, // Load image from URL if available
          child: doctor.photoUrl.isEmpty
              ? const Icon(Icons.person, size: 30)
              : null, // Fallback icon if no URL is provided
        ),
        title: Text(
          doctor.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(doctor.type),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text('${doctor.rating}'),
                const SizedBox(width: 16),
                Text('MAD ${doctor.constFee}'),
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            doctor.isFavourite ? Icons.favorite : Icons.favorite_border,
            color: doctor.isFavourite ? Colors.red : Colors.grey,
          ),
          onPressed: () => doctorService.toggleFavorite(doctor.id), // Use the instance method
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DoctorDetailScreen(doctor: doctor),
            ),
          );
        },
      ),
    );
  }
}
