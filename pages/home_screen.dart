import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_f/pages/all_doctors_screen.dart';
import 'package:test_f/pages/user_profile.dart';
import '../services/doctor_service.dart';
import '../model/doctor.dart';
import '../widgets/category_card.dart';
import '../widgets/doctor_list.dart';
import 'Filtred_doctor_screen.dart';
import 'all_categories_screen.dart';
import 'favorite_screen.dart';


class HomeScreen extends StatelessWidget {
  final DoctorService _doctorService = DoctorService();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context), // Pass context here
              SizedBox(height: 20),
              SizedBox(height: 20),
              _buildCategories(context),
              SizedBox(height: 20),
              _buildDoctorsList(context),
            ],
          ),
        ),
      ),
    );
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Widget _buildHeader(BuildContext context) {
    final user = _auth.currentUser;
    final displayName = user?.displayName ?? 'Guest';
    // Accept context as a parameter
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello,',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            Text(
              displayName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
        Row(
          children: [
            IconButton(
                icon: Icon(Icons.favorite, color: Colors.red),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteDoctorsScreen(),
                    ),
                  );
                  },
                ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfileScreen(),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
            ),

          ],
        ),
      ],
    );
  }


  // Function to get color based on category
  Color _getCategoryColor(String category) {
    Map<String, Color> categoryColors = {
      'Cardiologist': Color(0xFF40E0D0),
      'Pediatrician': Color(0xFF6495ED),
      'Dermatologist': Color(0xFFDE3163),
      'Neurologist': Color(0xFF40B5AD),
      'Orthopedic': Color(0xFFFF7F50),
      'General': Color(0xFF9370DB),
      'Dentist': Color(0xFF20B2AA),
      'Ophthalmologist': Color(0xFFFA8072),
    };
    return categoryColors[category] ?? Color(0xFF40E0D0);
  }

  // Function to get icon based on category
  IconData _getCategoryIcon(String category) {
    Map<String, IconData> categoryIcons = {
      'Cardiologist': Icons.favorite,
      'Pediatrician': Icons.child_care,
      'Dermatologist': Icons.face,
      'Neurologist': Icons.psychology,
      'Orthopedic': Icons.accessible,
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

  Widget _buildCategories(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AllCategoriesScreen(),
                  ),
                );
              },
              child: Text('See All'),
            ),
          ],
        ),/*TextButton(
          onPressed: () async {
            try {
              // Show loading indicator
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );*/

              // Load and add doctors
              /*List<Doctor> doctors = await _doctorService.loadDoctorsFromJson();
              await _doctorService.addDoctors(doctors);

              // Close loading indicator
              Navigator.pop(context);

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Doctors successfully imported!'),
                  backgroundColor: Colors.green,
                ),
              );
            } catch (e) {
              // Close loading indicator if showing
              Navigator.pop(context);

              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error importing doctors: ${e.toString()}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: const Text('Import Doctors'),
        ),*/

        SizedBox(height: 10),
        StreamBuilder<List<Doctor>>(
          stream: _doctorService.getDoctors(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('No categories found'),
              );
            }

            final categories = _processCategories(snapshot.data!);

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) => CategoryCard(
                  title: category['title'],
                  count: category['count'],
                  color: category['color'],
                  icon: category['icon'],
                  onTap: () {
                    // Add this navigation
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FilteredDoctorsScreen(
                          category: category['title'],
                        ),
                      ),
                    );
                  },
                )).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDoctorsList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
          'Doctors',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
              ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllDoctorsScreen(),
                ),
              );
            },
            child: Text('See All'),
          ),
        ],
      ),
    SizedBox(height: 10),
    DoctorList(),
    ],
    );
    }
}
