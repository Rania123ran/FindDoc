// lib/screens/all_categories_screen.dart

import 'package:flutter/material.dart';
import '../model/doctor.dart';
import '../services/doctor_service.dart';
import '../widgets/category_card.dart';
import 'Filtred_doctor_screen.dart';


class AllCategoriesScreen extends StatelessWidget {
  final DoctorService _doctorService = DoctorService();

  AllCategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
      ),
      body: StreamBuilder<List<Doctor>>(
        stream: _doctorService.getDoctors(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found'));
          }

          final categories = _processCategories(snapshot.data!);

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryCard(
                title: category['title'],
                count: category['count'],
                color: category['color'],
                icon: category['icon'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FilteredDoctorsScreen(
                        category: category['title'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Color _getCategoryColor(String category) {
    Map<String, Color> categoryColors = {
      'Cardiologist': Color(0xFF40E0D0),
      'Pediatrician': Color(0xFF6495ED),
      'Dermatologist': Color(0xFFDE3163),
      'Neurology': Color(0xFF40B5AD),
      'Orthopedic Surgeon': Color(0xFFFF7F50),
      'General': Color(0xFF9370DB),
      'Dentist': Color(0xFF20B2AA),
      'Ophthalmologist': Color(0xFFFA8072),
      'Heart Surgeon' :Color(0xFFFA8072),
    };
    return categoryColors[category] ?? Color(0xFF40E0D0);
  }
  IconData _getCategoryIcon(String category) {
    Map<String, IconData> categoryIcons = {
      'Heart Surgeon': Icons.favorite,
      'Pediatrician': Icons.child_care,
      'Dermatologist': Icons.face,
      'Neurology': Icons.psychology,
      'Orthopedic Surgeon': Icons.accessible,
      'General': Icons.medical_services,
      'Dentist': Icons.masks,
      'Ophthalmologist': Icons.remove_red_eye,
    };
    return categoryIcons[category] ?? Icons.medical_services;
  }
  List<Map<String, dynamic>> _processCategories(List<Doctor> doctors) {
    Map<String, int> categoryCount = {};

    for (var doctor in doctors) {
      String doctorType = doctor.type ?? 'General';
      categoryCount[doctorType] = (categoryCount[doctorType] ?? 0) + 1;
    }

    return categoryCount.entries.map((entry) {
      return {
        'title': entry.key,
        'count': '${entry.value}+ Doctors',
        'color': _getCategoryColor(entry.key),
        'icon': _getCategoryIcon(entry.key),
      };
    }).toList();
  }
// Copy _processCategories, _getCategoryColor, and _getCategoryIcon methods from HomeScreen
}