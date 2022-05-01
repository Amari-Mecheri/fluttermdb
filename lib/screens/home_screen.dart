import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Center(
            child: Text(_auth.currentUser?.email ?? 'not logged in'),
          ),
          Center(
            child: Text(_auth.currentUser?.displayName ?? 'no name specififed'),
          ),
        ],
      ),
    );
  }
}
