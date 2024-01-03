import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lift_sync/model/firebase_user.dart';
import 'package:lift_sync/model/lift.dart';
import 'package:lift_sync/model/lifts_view_model.dart';
import 'package:lift_sync/pages/my_lifts.dart';
import 'package:provider/provider.dart';

class CreateLift extends StatefulWidget {
  const CreateLift({super.key});

  @override
  State<CreateLift> createState() => _CreateLiftState();
}

class _CreateLiftState extends State<CreateLift> {
  DateTime selectedDate = DateTime.now();

  final departureController = TextEditingController();
  final dateTimeController = TextEditingController();
  final destinationController = TextEditingController();
  final seatsController = TextEditingController();
  final departureStreet = TextEditingController();
  final destinationStreet = TextEditingController();

  void _selectDate(BuildContext context) async {
    DateTime currentDate = selectedDate;

    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != currentDate) {
      // User picked a date, now show time picker
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentDate),
      );

      if (pickedTime != null) {
        // User picked a time, combine date and time
        DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          selectedDate = pickedDateTime;
        });
      }
    }
  }

  Future<void> _addLift() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    Users currentUserData = await getCurrentUserData(currentUser!.uid);
    final lift = Lift(
        id: '',
        ownerId: currentUserData.uid,
        departureTown: departureController.text,
        departureStreet: departureStreet.text,
        departureDateTime: selectedDate,
        destination: destinationController.text,
        destinationStreet: destinationStreet.text,
        seats: int.parse(seatsController.text));

    await FirebaseFirestore.instance.collection('lifts').add(lift.toJson());
    _resetForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Offer a Lift',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Container(
        //  decoration: const BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/images/offer.jpg'), // Change to your image path
        //     fit: BoxFit.cover,
        //   ),
        // ),
        child: Center(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: departureController,
                    decoration: const InputDecoration(
                      hintText: 'departure town',
                      labelText: 'Departure:',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: departureStreet,
                    decoration: const InputDecoration(
                      hintText: 'departure street name',
                      labelText: 'Departure Street:',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: TextEditingController(
                      text: "${selectedDate.toLocal()}".split(' ')[0],
                    ),
                    onTap: () => _selectDate(context),
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Select Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: destinationController,
                    decoration: const InputDecoration(
                      hintText: 'destination town',
                      labelText: 'Destination',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: destinationStreet,
                    decoration: const InputDecoration(
                      hintText: 'destination street name',
                      labelText: 'Destination Street:',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: seatsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'Seats available',
                      labelText: 'Seats',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _addLift();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return ChangeNotifierProvider(
                            create: (context) => LiftsViewModel(),
                            child: const ViewLifts(),
                          );
                        },
                      ),
                    );
                  },
                  child: const Text(
                    'Create a Lift',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetForm() {
    departureController.clear();
    departureStreet.clear();
    selectedDate = DateTime.now(); // Reset the date to the current date
    destinationController.clear();
    destinationStreet.clear();
    seatsController.clear();
  }

  Future<Users> getCurrentUserData(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        return Users.fromJson(userSnapshot.data() as Map<String, dynamic>);
      } else {
        print('User not found in the Users collection.');
        return Users(
            uid: '',
            email: '',
            fullName:
                ''); // Return a default value or handle the case appropriately
      }
    } catch (e) {
      print('Error retrieving user data: $e');
      return Users(
          uid: '',
          email: '',
          fullName:
              ''); // Return a default value or handle the error appropriately
    }
  }
}
