import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttermdb/screens/feed_screen.dart';
import 'package:fluttermdb/screens/profile_screen.dart';
import 'package:fluttermdb/screens/search_screen.dart';

import '../screens/add_post_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notif'),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
