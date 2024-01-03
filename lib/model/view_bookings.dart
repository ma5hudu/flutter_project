import 'package:cloud_firestore/cloud_firestore.dart';

class ViewMyBookings {
  final String driverUsername;
  final String passengerUsername;
  final String departure;
  final String departureStreet;
  final String destination;
  final String destinationStreet;
  final DateTime departureDateTime;
  final int selectedPrice;

  ViewMyBookings(
      {
    required this.driverUsername,
    required this.passengerUsername,
    required this.departure,
    required this.departureStreet,
    required this.destination,
    required this.destinationStreet,
    required this.departureDateTime,
    required this.selectedPrice,});

ViewMyBookings.fromJson(Map<String, Object?> jsonMap, String id)
    : this(
          driverUsername: jsonMap['driver'] as String,
          passengerUsername: jsonMap['passanger'] as String,
          departure: jsonMap['departure'] as String,
          departureStreet: jsonMap['departureStreet'] as String,
          departureDateTime: DateTime.parse(jsonMap['departureDateTime'] as String),
          destination: jsonMap['destination'] as String,
          destinationStreet: jsonMap['destinationStreet'] as String,
          selectedPrice: jsonMap['price'] as int? ?? 0, // Use 0 as a default value if 'price' is null
        );


    
  Map<String, Object?> toJson() {
    return {
      'driver': driverUsername,
      'passanger': passengerUsername,
      'departure': departure,
      'departureStreet': departureStreet,
      'departureDateTime': departureDateTime.toIso8601String(),
      'destination': destination,
      'destinationStreet': destinationStreet,
      'price': selectedPrice.toInt(),
    };
  }



}





  