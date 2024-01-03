import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lift_sync/model/lift.dart';
import 'package:lift_sync/model/lifts_view_model.dart';
import 'package:lift_sync/model/view_bookings.dart';
import 'package:provider/provider.dart';


class BookingsDetails extends StatefulWidget {
  final Lift lift;
  const BookingsDetails({Key? key, required this.lift}) : super(key: key);

  @override
  State<BookingsDetails> createState() => _BookingsDetailsState();
}

class _BookingsDetailsState extends State<BookingsDetails> {
  bool isBooked = false;
  bool isCanceled = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Bookings',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Consumer<LiftsViewModel>(
        builder: (context, liftsViewModel, child) {
          if (liftsViewModel.lifts.isEmpty) {
            liftsViewModel.loadLifts();
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return FutureBuilder<List<ViewMyBookings>>(
              future: liftsViewModel.fetchBookingsFromFirebase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No bookings available.'));
                } else {
                  final List<ViewMyBookings> bookings = snapshot.data!;
                  final currentUserBookings = bookings
                      .where((booking) =>
                          booking.passengerUsername ==
                          FirebaseAuth.instance.currentUser!.displayName)
                      .toList();

                  return ListView.builder(
                    itemCount: currentUserBookings.length,
                    itemBuilder: (context, index) {
                      final ViewMyBookings bookingDetails = currentUserBookings[index];

                      return ListTile(
                        title: Text('Driver: ${bookingDetails.driverUsername}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Passenger name : ${bookingDetails.passengerUsername}'),
                            Text('Departure: ${bookingDetails.departure}'),
                            Text(
                                'Departure Street: ${bookingDetails.departureStreet}'),
                            Text('Destination: ${bookingDetails.destination}'),
                            Text(
                                'Destination Street: ${bookingDetails.destinationStreet}'),
                            Text(
                                'Date: ${bookingDetails.departureDateTime.toLocal()}'),
                            Text('Lift Price: ${bookingDetails.selectedPrice}'),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () async{
                                    if (!isCanceled) {
                                      setState(() {
                                        isBooked = false;
                                        isCanceled = true;
                                      });
                                      await widget.lift.cancelBooking();
                                      liftsViewModel.fetchBookingsFromFirebase();
                                    }
                                  },
                                  child: const Text('Cancel Booking'),
                                ),
                                const SizedBox(height: 16.0),
                                Checkbox(
                                  value: isCanceled,
                                  onChanged: (value) {
                                    setState(() {
                                      isCanceled = value!;
                                    });
                                  },
                                ),
                                const Text('Canceled'),
                              ],
                            ),
                          ],
                        ),
                        // Add more details as needed
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
