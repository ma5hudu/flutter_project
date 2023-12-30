import 'package:flutter/material.dart';
import 'package:lift_sync/pages/on_bording.dart';


class MyFirstPage extends StatefulWidget {
  const MyFirstPage({super.key, required this.title});

  final String title;

  @override
  State<MyFirstPage> createState() => _MyFirstPage();
}

class _MyFirstPage extends State<MyFirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.cyan,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 16.0,
            ),
            Image.asset("assets/images/first.jpg",
              width: 800,
              height: 400,
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () {
                _openLoginPage(context);
              },
              child: const Text(
                'Get Started',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
            ),
          ], 
        ),
      ),
    );
  }

  _openLoginPage(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const OnBording();
    }));
  }
}
