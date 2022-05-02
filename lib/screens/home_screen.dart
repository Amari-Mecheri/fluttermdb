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

    // if (maxSize > 0) {
    //   Image imToBeResized = Image.memory(im);
    //   double biggest = imToBeResized.height!;

    //   if (imToBeResized.width! > imToBeResized.height!) {
    //     biggest = imToBeResized.width!;
    //   }

    //   if (biggest > maxSize) {
    //     double ratio = biggest / maxSize;
    //     var im2 = Image(
    //       image: ResizeImage(
    //         MemoryImage(im),
    //         width: (imToBeResized.width!/ratio) as int?,
    //         height: (imToBeResized.height!/ratio) as int?,
    //       ),
    //     );
    //     im = im2.
    //   }
    // }