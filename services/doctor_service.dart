import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:stream_transform/stream_transform.dart';
import '../model/doctor.dart';

class DoctorService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference for doctors
  CollectionReference get _doctorCollection => _firestore.collection('doctors');

  // Stream to get all doctors with favorite status

  Stream<List<Doctor>> getDoctors() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return _doctorCollection.snapshots().map((snapshot) =>
          snapshot.docs.map((doc) => Doctor.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList()
      );
    }

    // Créer un stream qui écoute à la fois les docteurs et les favoris
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .switchMap((favoritesSnapshot) {
      final favoriteIds = favoritesSnapshot.docs.map((doc) => doc.id).toSet();

      return _doctorCollection.snapshots().map((doctorsSnapshot) {
        return doctorsSnapshot.docs.map((doc) {
          final doctor = Doctor.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          return doctor.copyWith(isFavourite: favoriteIds.contains(doc.id));
        }).toList();
      });
    });
  }

  Stream<List<Doctor>> getFavoriteDoctors() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Doctor> favoriteDoctors = [];
      for (var doc in snapshot.docs) {
        final doctorDoc = await _doctorCollection.doc(doc.id).get();
        if (doctorDoc.exists) {
          final doctor = Doctor.fromMap(
              doctorDoc.data() as Map<String, dynamic>, doctorDoc.id);
          favoriteDoctors.add(doctor.copyWith(isFavourite: true));
        }
      }
      return favoriteDoctors;
    });
  }

  Future<void> toggleFavorite(String doctorId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    final favoriteRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(doctorId);

    try {
      final doc = await favoriteRef.get();
      if (doc.exists) {
        await favoriteRef.delete();
      } else {
        await favoriteRef.set({
          'timestamp': FieldValue.serverTimestamp(),
          'doctorId': doctorId
        });
      }
    } catch (e) {
      print('Error toggling favorite: $e');
    }
  }

  // Add a list of doctors to Firestore
  Future<void> addDoctors(List<Doctor> doctors) async {
    for (var doctor in doctors) {
      await _doctorCollection.add(doctor.toMap());
    }
  }

  Future<List<Doctor>> loadDoctorsFromJson() async {
    final String response = await rootBundle.loadString('assets/doctors.json');
    final List<dynamic> data = json.decode(response);
    return data.map((json) => Doctor.fromMap(json, '')).toList();
  }

  // Fetch a doctor by ID
  Future<Doctor?> getDoctorById(String id) async {
    try {
      DocumentSnapshot doc = await _doctorCollection.doc(id).get();
      if (doc.exists) {
        final userId = _auth.currentUser?.uid;
        if (userId != null) {
          // Check if doctor is in favorites
          final favoriteDoc = await _firestore
              .collection('users')
              .doc(userId)
              .collection('favorites')
              .doc(id)
              .get();

          return Doctor.fromMap(doc.data() as Map<String, dynamic>, doc.id)
              .copyWith(isFavourite: favoriteDoc.exists);
        }
        return Doctor.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting doctor: $e');
      return null;
    }
  }
}