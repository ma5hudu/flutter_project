import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lift_sync/model/lifts_view_model.dart';
import 'package:lift_sync/pages/my_lifts.dart';
import 'package:provider/provider.dart';

class UpdateLiftInformation extends StatefulWidget {
  const UpdateLiftInformation({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  State<UpdateLiftInformation> createState() => _UpdateLiftInformationState();
}

class _UpdateLiftInformationState extends State<UpdateLiftInformation> {
  DateTime selectedDate = DateTime.now();

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
          // Update both the dateTimeController and selectedDate
          dateTimeController.text = "${pickedDateTime.toLocal()}".split(' ')[0];
        });
      }
    }
  }

  final departureController = TextEditingController();
  final dateTimeController = TextEditingController();
  final destinationController = TextEditingController();
  final seatsController = TextEditingController();
  final departureStreet = TextEditingController();
  final destinationStreet = TextEditingController();

  late CollectionReference liftsCollection;

  @override
  void initState() {
    super.initState();
    liftsCollection = FirebaseFirestore.instance.collection('lifts');
    getLiftData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Update Lift Information',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
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
                  controller: dateTimeController,
                  onTap: () => _selectDate(context),
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
                    labelText: 'Destination Street: ',
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
              const SizedBox(
                height: 16.0,
              ),
              ElevatedButton(
                onPressed: () {
                  _updateLiftInformation();
                  ChangeNotifierProvider(
                    create: (context) => LiftsViewModel(),
                    child: const ViewLifts(),
                  );
                },
                child: const Text(
                  'Update',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateLiftInformation() {
    Map<String, dynamic> lifts = {
      'departure': departureController.text,
      'departureStreet': departureStreet.text,
      'departureDateTime': dateTimeController.text,
      'destination': destinationController.text,
      'destinationStreet': destinationStreet.text,
      'seats': int.parse(seatsController.text),
    };

    liftsCollection.doc(widget.id).update(lifts).then((value) {
      Navigator.pop(context);
    });
  }

  void getLiftData() async {
    DocumentSnapshot liftSnapshot = await liftsCollection.doc(widget.id).get();

    Map<String, dynamic> liftData = liftSnapshot.data() as Map<String, dynamic>;

    departureController.text = liftData['departure'];
    departureStreet.text = liftData['departureStreet'];
    dateTimeController.text = liftData['departureDateTime'];
    destinationController.text = liftData['destination'];
    destinationStreet.text = liftData['destinationStreet'];
    seatsController.text = liftData['seats'].toString();
  }
}
