import 'package:flutter/material.dart';
import 'package:fluttermdb/screens/feed_screen.dart';
import 'package:fluttermdb/screens/profile_screen.dart';
import 'package:fluttermdb/screens/search_screen.dart';

import '../screens/add_post_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('notif'),
  ProfileScreen(),
];
