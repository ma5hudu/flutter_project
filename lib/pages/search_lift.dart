import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lift_sync/model/lifts_view_model.dart';
import 'package:lift_sync/pages/lift_details.dart';
import 'package:provider/provider.dart';

class SearchLift extends StatefulWidget {
  const SearchLift({super.key});

  @override
  State<SearchLift> createState() => _SearchLiftState();
}

class _SearchLiftState extends State<SearchLift> {
  TextEditingController _searchController = TextEditingController();

  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUsersPastTripsStreamSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      for (var lift in _allResults) {
        var destination = lift.destination.toLowerCase();

        if (destination.contains(_searchController.text.toLowerCase()) &&
            lift.ownerId != FirebaseAuth.instance.currentUser?.uid) {
          showResults.add(lift);
        }
      }
    } else {
      showResults = _allResults
          .where(
              (lift) => lift.ownerId != FirebaseAuth.instance.currentUser?.uid)
          .toList();
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getUsersPastTripsStreamSnapshots() async {
    // Assuming liftsViewModel is an instance of LiftsViewModel
    await Provider.of<LiftsViewModel>(context, listen: false).loadLifts();
    setState(() {
      _allResults = Provider.of<LiftsViewModel>(context, listen: false).lifts;
    });
    searchResultsList();
    return "complete";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(
          'Search for your Lift',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 400,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Where to?',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              // Use Expanded to allow the Consumer to take the remaining space
              child: Consumer<LiftsViewModel>(
                builder: (context, liftsViewModel, child) {
                  if (liftsViewModel.lifts.isEmpty) {
                    liftsViewModel.loadLifts();
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: _resultsList.length,
                      itemBuilder: (context, index) {
                        final lift = _resultsList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ChangeNotifierProvider(
                                    create: (context) => LiftsViewModel(),
                                    child: LiftDetails(lift: lift),
                                  );
                                },
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              'Departure: ${lift.departureTown}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16.0),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Destination: ${lift.destination}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                ),
                                Text(
                                    'Date: ${lift.departureDateTime.toLocal()}'),
                                Text('Seats Available: ${lift.seats}'),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
