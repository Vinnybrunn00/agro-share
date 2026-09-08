import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class LocationServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> determinePosition() async {
    final bool serviceEnabled;
    late LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    final Position currentPosition = await Geolocator.getCurrentPosition();

    await _saveCurrentLocation(
      lat: currentPosition.latitude,
      long: currentPosition.longitude,
    );
  }

  Stream<bool> get locationServiceStatusStream async* {
    yield await Geolocator.isLocationServiceEnabled();
    yield* Geolocator.getServiceStatusStream().map(
      (ServiceStatus status) => status == ServiceStatus.enabled,
    );
  }

  Future<void> _saveCurrentLocation({
    required double lat,
    required double long,
  }) async => await _firestore
      .collection('users')
      .doc(_firebaseAuth.currentUser?.uid)
      .set({'lat': lat, 'long': long}, SetOptions(merge: true));
}
