import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lift_sync/model/lift.dart';
import 'package:lift_sync/model/view_bookings.dart';


///Contains the relevant lifts data for our views
class LiftsViewModel extends ChangeNotifier {
  //TODO keep track of loaded Lifts and notify views on changes

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Lift> _lifts = [];
  List<Lift> get lifts => _lifts;

  Future<void> loadLifts() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('lifts').get();
      _lifts =
          snapshot.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        final data = doc.data();
        return Lift(
          id: doc.id,
          ownerId: data['ownerId'],
          departureTown: data['departure'] as String,
          departureStreet: data['departureStreet'] as String,
          departureDateTime:
              DateTime.parse(data['departureDateTime'] as String),
          destination: data['destination'] as String,
          destinationStreet: data['destinationStreet'] as String,
          seats: data['seats'] as int,
        );
      }).toList();
      notifyListeners();
    } catch (exception) {
      print('Error loading lifts: $exception');
    }
  }

  Future<void> deleteLift(String liftId) async{
    try{
      await FirebaseFirestore.instance.collection('lifts').doc(liftId).delete();
      _lifts.removeWhere((lift) => lift.id == liftId);
      notifyListeners();
    }catch(e){
      print('Error deleting lift:$e');
    
    }
  }

   Future<List<ViewMyBookings>> fetchBookingsFromFirebase() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('booking_details')
          .get();

      List<ViewMyBookings> bookingsList = snapshot.docs.map((doc) {
        return ViewMyBookings.fromJson(doc.data()!, doc.id);
      }).toList();

      return bookingsList;
    } catch (e) {
      print('Error fetching bookings from Firebase: $e');
      return [];
    }
  }


}
