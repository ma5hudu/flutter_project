import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lift_sync/model/firebase_user.dart';
import 'package:lift_sync/model/lift.dart';
import 'package:lift_sync/pages/confirm_bookings.dart';


class LiftDetails extends StatefulWidget {
  final Lift lift;

  const LiftDetails({Key? key, required this.lift}) : super(key: key);

  @override
  State<LiftDetails> createState() => _LiftDetailsState();
}

class _LiftDetailsState extends State<LiftDetails> {
  late final Lift lift;
  late Users liftCreator = Users(uid: '', email: '', fullName: '');
  int? _tripPrice;

  final List<int> price = [150, 200, 330, 400, 500, 630, 800];

  @override
  void initState() {
    super.initState();
    lift = widget.lift;
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Use the fromJson method to create Users object
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(lift.ownerId)
          .get();

      print('User Snapshot: $userSnapshot');

      Users userData =
          Users.fromJson(userSnapshot.data() as Map<String, Object?>);

      print('User Data: $userData');

      setState(() {
        liftCreator = userData;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lift Information',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Provider: ${liftCreator.fullName}',
            ),
            Text('Departure: ${lift.departureTown}'),
            Text('Destination: ${lift.destination}'),
            Text('Date and Time: ${lift.departureDateTime.toLocal()}'),
            Text('Available Seats: ${lift.seats}'),
            Row(
              children: [
                const Text(
                  'Payment cost:',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8.0),
                DropdownButton<int>(
                  value: _tripPrice,
                  items: price.map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      _tripPrice = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () async {
                await _handleBookings();
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Book your seat(s)'),
                  SizedBox(width: 8.0),
                  Icon(Icons.navigate_next_rounded),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _handleBookings() async {
    if (_tripPrice == null) {
      print('Please select a payment cost.');
    }
    try {
      Future<void> bookingSuccess = lift.bookSeats();

      if (bookingSuccess != null) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return  ConfrimBooking(
            passengerId:  FirebaseAuth.instance.currentUser!.uid,
             liftId: lift.id,
          departure: lift.departureTown,
          departureStreet: lift.departureStreet,
          destination: lift.destination,
          destinationStreet: lift.destinationStreet,
          departureDateTime: lift.departureDateTime,
          selectedPrice: _tripPrice ?? 0,
           driverUsername: liftCreator.fullName,
            passengerUsername:  '',
           
             );
        }));
      } else {
        print('Seats booking failed.');
      }
    } catch (error) {
      print('Error booking seats: $error');
    }
  }
}
