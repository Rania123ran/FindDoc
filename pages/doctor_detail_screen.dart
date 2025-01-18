import 'package:flutter/material.dart';
import '../model/doctor.dart';

class DoctorDetailScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailScreen({
    Key? key,
    required this.doctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dr. ${doctor.name}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Header Section
            Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: doctor.photoUrl.isNotEmpty
                        ? NetworkImage(doctor.photoUrl)
                        : null, // Load image if URL exists
                    child: doctor.photoUrl.isEmpty
                        ? const Icon(Icons.person, size: 40)
                        : null, // Fallback icon
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          doctor.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          doctor.type,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Stats Section
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    'Rating',
                    '${doctor.rating}',
                    Icons.star,
                    Colors.amber,
                  ),
                  _buildStatItem(
                    context,
                    'Reviews',
                    '${doctor.goodReviews}%',
                    Icons.thumb_up,
                    Colors.blue,
                  ),
                  _buildStatItem(
                    context,
                    'Satisfaction',
                    '${doctor.satisfaction}%',
                    Icons.sentiment_satisfied,
                    Colors.green,
                  ),
                ],
              ),
            ),

            const Divider(),

            // Information Sections
            _buildInfoSection(
              context,
              'About',
              doctor.description,
              Icons.info_outline,
            ),
            _buildInfoSection(
              context,
              'Education',
              doctor.education,
              Icons.school_outlined,
            ),
            _buildInfoSection(
              context,
              'Location',
              doctor.location,
              Icons.location_on_outlined,
            ),

            // Consultation Fee
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Consultation Fee',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'MAD ${doctor.constFee}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement booking functionality
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
            child: const Text('Book Appointment'),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      Color color,
      ) {
    return Column(
      children: [
        Icon(icon, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildInfoSection(
      BuildContext context,
      String title,
      String content,
      IconData icon,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }
}
