import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('TODO'),
            TextButton(
              onPressed: () {
                setState(() {
                  FirebaseAuth.instance.signOut();
                });
              },
              child: Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
