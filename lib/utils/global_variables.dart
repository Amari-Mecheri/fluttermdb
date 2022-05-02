import 'package:flutter/material.dart';
import 'package:fluttermdb/screens/feed_screen.dart';

import '../screens/add_post_screen.dart';

const WebScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  Text('search'),
  AddPostScreen(),
  Text('notif'),
  Text('profile'),
];
