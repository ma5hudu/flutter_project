import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lift_sync/model/lift.dart';
import 'package:lift_sync/model/lifts_view_model.dart';
import 'package:lift_sync/pages/update_lift_info.dart';
import 'package:provider/provider.dart';

class ViewLifts extends StatefulWidget {
  const ViewLifts({Key? key});

  @override
  State<ViewLifts> createState() => _ViewLiftsState();
}

class _ViewLiftsState extends State<ViewLifts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Lifts',
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
            List<Lift> userLift = liftsViewModel.lifts
                .where((lift) =>
                    lift.ownerId == FirebaseAuth.instance.currentUser?.uid)
                .toList();
            return ListView.builder(
              itemCount: userLift.length,
              itemBuilder: (context, index) {
                final lift = userLift[index];
                return Card(
                  // color: Colors.gg, // Set your desired color here
                  child: ListTile(
                    title: Text('Departure: ${lift.departureTown}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('departureStreet: ${lift.departureStreet}'),
                        Text('Destination: ${lift.destination}'),
                        Text('destinationStreet: ${lift.destinationStreet}'),
                        Text('Date: ${lift.departureDateTime.toLocal()}'),
                        Text('Seats Available: ${lift.seats}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return UpdateLiftInformation(
                                  id: lift.id,
                                );
                              },
                            ));
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            _showDeleteConfirmationDialog(
                                context, liftsViewModel, lift.id);
                          },
                          icon: const Icon(Icons.delete),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, LiftsViewModel liftsViewModel, String liftId) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this lift?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirmed
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User canceled
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed != null && confirmed) {
        // Proceed with the deletion logic here
        liftsViewModel.deleteLift(liftId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lift deleted successfully..!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error deleting lift, Please try again'),
          ),
        );
      }
    });
  }
}
