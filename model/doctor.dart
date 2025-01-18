import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  final String id;
  final String name;
  final String type;
  final String description;
  final String education;
  final String location;
  final String constFee;
  final double goodReviews;
  final double rating;
  final double satisfaction;
  final double totalScore;
  final bool isFavourite;
  final String photoUrl; // Nouveau champ

  Doctor({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.education,
    required this.location,
    required this.constFee,
    required this.goodReviews,
    required this.rating,
    required this.satisfaction,
    required this.totalScore,
    required this.isFavourite,
    required this.photoUrl, // Nouveau champ
  });

  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Doctor(
      id: doc.id,
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      description: data['description'] ?? '',
      education: data['education'] ?? '',
      location: data['location'] ?? '',
      constFee: data['constFee'] ?? '',
      goodReviews: (data['goodReviews'] ?? 0).toDouble(),
      rating: (data['rating'] ?? 0).toDouble(),
      satisfaction: (data['satisfaction'] ?? 0).toDouble(),
      totalScore: (data['totalScore'] ?? 0).toDouble(),
      isFavourite: data['isFavourite'] ?? false,
      photoUrl: data['photoUrl'] ?? '', // Lecture du champ
    );
  }

  factory Doctor.fromMap(Map<String, dynamic> map, String id) {
    return Doctor(
      id: id,
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      description: map['description'] ?? '',
      education: map['education'] ?? '',
      location: map['location'] ?? '',
      constFee: map['constFee'] ?? '',
      goodReviews: (map['goodReviews'] ?? 0).toDouble(),
      rating: (map['rating'] ?? 0).toDouble(),
      satisfaction: (map['satisfaction'] ?? 0).toDouble(),
      totalScore: (map['totalScore'] ?? 0).toDouble(),
      isFavourite: map['isFavourite'] ?? false,
      photoUrl: map['photoUrl'] ?? '', // Lecture du champ
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'description': description,
      'education': education,
      'location': location,
      'constFee': constFee,
      'goodReviews': goodReviews,
      'rating': rating,
      'satisfaction': satisfaction,
      'totalScore': totalScore,
      'isFavourite': isFavourite,
      'photoUrl': photoUrl, // Écriture du champ
    };
  }

  Doctor copyWith({
    String? id,
    String? name,
    String? type,
    String? description,
    String? education,
    String? location,
    String? constFee,
    double? goodReviews,
    double? rating,
    double? satisfaction,
    double? totalScore,
    bool? isFavourite,
    String? photoUrl, // Nouveau champ
  }) {
    return Doctor(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      education: education ?? this.education,
      location: location ?? this.location,
      constFee: constFee ?? this.constFee,
      goodReviews: goodReviews ?? this.goodReviews,
      rating: rating ?? this.rating,
      satisfaction: satisfaction ?? this.satisfaction,
      totalScore: totalScore ?? this.totalScore,
      isFavourite: isFavourite ?? this.isFavourite,
      photoUrl: photoUrl ?? this.photoUrl, // Nouveau champ
    );
  }
}
