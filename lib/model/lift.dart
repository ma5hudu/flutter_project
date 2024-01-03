import 'package:cloud_firestore/cloud_firestore.dart';

/// Use this class to represent a Lift
class Lift {
  final String id;
  final String ownerId;
  final String departureTown;
  final String departureStreet;
  final DateTime departureDateTime;
  final String destination;
  final String destinationStreet;
  int seats;

  //TODO

  Lift(
      {required this.id,
      required this.ownerId,
      required this.departureTown,
      required this.departureStreet,
      required this.departureDateTime,
      required this.destination,
      required this.destinationStreet,
      required this.seats});

  Lift.fromJson(Map<String, Object?> jsonMap, String id)
      : this(
          id: id,
          ownerId: jsonMap['ownerId'] as String,
          departureTown: jsonMap['departure'] as String,
          departureStreet: jsonMap['departureStreet'] as String,
          departureDateTime:
              DateTime.parse(jsonMap['departureDateTime'] as String),
          destination: jsonMap['destination'] as String,
          destinationStreet: jsonMap['destinationStreet'] as String,
          seats: jsonMap['seats'] as int,
        );

  Map<String, Object?> toJson() {
    return {
      'ownerId': ownerId,
      'departure': departureTown,
      'departureStreet': departureStreet,
      'departureDateTime': departureDateTime.toIso8601String(),
      'destination': destination,
      'destinationStreet': destinationStreet,
      'seats': seats.toInt(),
    };
  }

  Future<void> bookSeats() async {
    try {
      if (seats > 0) {
        seats--;
        await FirebaseFirestore.instance.collection('lifts').doc(id).update({
          'seats': seats,
        });
      } else {
        print('No available seats.');
      }
    } catch (error) {
      print('Error updating Firebase: $error');
    }
  }

    Future<void> cancelBooking() async {
    try {
      
      seats++;
      await FirebaseFirestore.instance.collection('lifts').doc(id).update({
        'seats': seats,
      });
    } catch (error) {
      print('Error canceling booking: $error');
    }
  }


  @override
  String toString() {
    return 'Lift{ownerId: $ownerId, departure: $departureTown,  departureStreet: $departureStreet, departureDateTime: $departureDateTime, destination: $destination, destinationStreet: $destinationStreet, seats: $seats }';
  }
}
