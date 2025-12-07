import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/utils/logger.dart';
import '../../../trip/data/models/trip_model.dart';

class CloudRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInAnonymously() async {
    if (_auth.currentUser == null) {
      await _auth.signInAnonymously();
      logger.i('Signed in anonymously: ${_auth.currentUser?.uid}');
    }
  }

  Future<void> syncTrip(TripModel trip) async {
    try {
      await signInAnonymously();

      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        logger.w('Cannot sync trip: User not logged in');
        return;
      }

      // Save to users/{uid}/trips/{tripId}
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('trips')
          .doc(trip.id)
          .set(trip.toJson());

      logger.i('Trip synced to cloud: ${trip.id}');
    } catch (e) {
      logger.e('Failed to sync trip', error: e);
      // In a real app, queue for offline sync
    }
  }
}
