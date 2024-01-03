import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lift_sync/model/bookings.dart';
import 'package:lift_sync/model/view_bookings.dart';
import 'package:lift_sync/pages/home_page.dart';


class ConfrimBooking extends StatefulWidget {
  final String passengerId;
  final String liftId;
  final String driverUsername;
  final String passengerUsername;
  final String departure;
  final String departureStreet;
  final String destination;
  final String destinationStreet;
  final DateTime departureDateTime;
  final int selectedPrice;
  

  const ConfrimBooking(
      {Key? key,
      required this.passengerId,
      required this.liftId,
      required this.driverUsername,
      required this.passengerUsername,
      required this.departure,
      required this.departureStreet,
      required this.destination,
      required this.destinationStreet,
      required this.departureDateTime,
      required this.selectedPrice,
      })
      : super(key: key);

  @override
  State<ConfrimBooking> createState() => _ConfrimBookingState();
}

class _ConfrimBookingState extends State<ConfrimBooking> {
  bool isBooked = false;
  bool isCanceled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          'Confirm Bookings',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        leading: IconButton(
          icon: const Icon(Icons.home_outlined),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return const MyHomePage();
            }));
          },
        ),
      ),
      body: ListTile(
        title: Text('Driver: ${widget.driverUsername}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Passenger: ${FirebaseAuth.instance.currentUser!.displayName}'),
            Text('Departure: ${widget.departure}'),
            Text('Departure Street: ${widget.departureStreet}'),
            Text('Destination: ${widget.destination}'),
            Text('Destination Street: ${widget.destinationStreet}'),
            Text('Date: ${widget.departureDateTime.toLocal()}'),
            Text('Lift Price: ${widget.selectedPrice}'),
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    if (!isBooked) {
                      setState(() {
                        isBooked = true;
                        isCanceled = false;
                      });
                      try {
                        Bookings(
                          passengerId: FirebaseAuth.instance.currentUser!.uid,
                          liftId: widget.liftId,
                          confirmed: true,
                        ).addBooking();

                       
                        ViewMyBookings bookingDetails = ViewMyBookings(
                          driverUsername: widget.driverUsername,
                          passengerUsername:
                              FirebaseAuth.instance.currentUser!.displayName ??
                                  '',
                          departure: widget.departure,
                          departureStreet: widget.departureStreet,
                          destination: widget.destination,
                          destinationStreet: widget.destinationStreet,
                          departureDateTime: widget.departureDateTime,
                          selectedPrice: widget.selectedPrice,
                        );

                        await FirebaseFirestore.instance
                            .collection('booking_details')
                            .add(bookingDetails.toJson());
                      } catch (error) {
                      
                        print('Error confirming lift: $error');
                      }
                    }
                  },
                  child: const Text('Confirm lift'),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Checkbox(
                  value: isBooked,
                  onChanged: (value) {
                    setState(() {
                      isBooked = value!;
                    });
                  },
                ),
                const Text('Booked'),
                const SizedBox(width: 20),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
