import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_flutter_clone/screens/add_post_screen.dart';
import 'package:insta_flutter_clone/screens/feed_screen.dart';
import 'package:insta_flutter_clone/screens/profile_screene.dart';
import 'package:insta_flutter_clone/screens/search_screen.dart';

const webScreenSize = 600;

 List<Widget> homeScreenItems = [
      const FeedScreen(),
      const SearchScreen(),
      const AddPageScreen(),
      const Center(
        child: Text("Favorite"),
        ),
      ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,)
];
