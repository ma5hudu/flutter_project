import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:lift_sync/model/lifts_view_model.dart';
import 'package:lift_sync/pages/home_page.dart';
import 'package:provider/provider.dart';


class OnBording extends StatelessWidget {
  const OnBording({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SignInScreen(
              providers: [
                EmailAuthProvider(),
              ],
              headerBuilder: (context, constraints, shrinkOffset) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset('assets/images/first.jpg'),
                  ),
                );
              },
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: action == AuthAction.signIn
                      ? const Text('Welcome to LiftSync, please sign in!')
                      : const Text('Welcome to LiftSync, please sign up!'),
                );
              },
              sideBuilder: (context, shrinkOffset) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.asset(
                      'assets/images/first.jpg',
                      width: 400,
                      height: 200,
                    ),
                  ),
                );
              },
            );
          }
          // Users.addCurrentUserToFirestore();

          return ChangeNotifierProvider(
            create: (_) => LiftsViewModel(),
            child: const MyHomePage(),
          );
        });
  }
}
