
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:lift_sync/model/lifts_view_model.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  User? currentUser = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: currentUser != null
              ? Text(currentUser?.displayName ?? '')
              : const Text(''),
          accountEmail: currentUser != null
              ? Text(currentUser?.email ?? '')
              : const Text(''),
          currentAccountPicture: GestureDetector(
            onTap: ()  {
              
            },
            child: CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),
          decoration: const BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                    'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.person_sharp),
          title: const Text('Profile'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<ProfileScreen>(
                builder: (context) => ProfileScreen(
                    appBar: AppBar(
                      title: const Text('User Profile'),
                    ),
                    actions: [
                      SignedOutAction((context) {
                        Navigator.of(context).pop();
                      })
                    ],
                    children: const [
                      Divider(),
                      Padding(
                        padding: EdgeInsets.all(2),
                      ),
                    ]),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.car_rental),
          title: const Text('Your Lifts'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return ChangeNotifierProvider(
                    create: (context) => LiftsViewModel(),
                    // child: const ViewLifts(),
                  );
                },
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.perm_contact_cal_outlined),
          title: const Text('My Bookings'),
          onTap: () {

          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          onTap: () {},
        ),
        const ListTile(
          leading: SignOutButton(),
        )
      ],
    );
  }
}
