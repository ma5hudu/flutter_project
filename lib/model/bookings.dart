import 'package:cloud_firestore/cloud_firestore.dart';

class Bookings {
  final String passengerId;
  final String liftId;
  final bool confirmed;

  Bookings(
      {required this.passengerId,
      required this.liftId,
      required this.confirmed});

  Bookings.fromJson(Map<String, Object?> jsonMap, String id)
      : this(
          passengerId: jsonMap['passengerId'] as String,
          liftId: jsonMap['liftId'] as String,
          confirmed: jsonMap['confirmed'] as bool,
         
        );

    
  Map<String, Object?> toJson() {
    return {
      'passengerId': passengerId,
      'liftId': liftId,
      'confirmed': confirmed,
    };
  }

  Future<void> addBooking() async {
    try {
      await FirebaseFirestore.instance.collection('bookings').add({
        'passengerId': passengerId,
        'liftId': liftId,
        'confirmed': confirmed,
      });
      print('Booking added to Firestore successfully.');
    } catch (e) {
      print('Error adding booking to Firestore: $e');
    }
  }
  }



