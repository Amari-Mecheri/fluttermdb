import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttermdb/ressources/auth_methods.dart';
import 'package:fluttermdb/ressources/firestore_methods.dart';
import 'package:fluttermdb/screens/login_screen.dart';
import 'package:fluttermdb/utils/colors.dart';
import 'package:fluttermdb/utils/utils.dart';
import 'package:fluttermdb/widgets/follow_button.dart';
import 'package:fluttermdb/widgets/posts_grid.dart';

class ProfileScreen extends StatefulWidget {
  //final dynamic snap;
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = userSnap.data()!;
      // get post length
      // var postSnap = await FirebaseFirestore.instance
      //     .collection('posts')
      //     .where('uid', isEqualTo: userData['uid'])
      //     .get();
      // postLen = postSnap.docs.length;
      // followers = userSnap.data()!['followers'].length;
      // following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      showSnackBar(e.toString(), context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: _isLoading
            ? const RefreshProgressIndicator()
            : Text(userData['username']),
        centerTitle: false,
      ),
      body: ListView(
        children: [
          _isLoading
              ? const LinearProgressIndicator()
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                  userData['photoUrl'],
                                ),
                                radius: 40,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(
                                  top: 1,
                                ),
                                child: Center(
                                    child: Text(
                                  userData['bio'],
                                )),
                              ),
                            ],
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('posts')
                                          .where('uid',
                                              isEqualTo: userData['uid'])
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return buildStatColumn(
                                              postLen, 'posts');
                                        }
                                        postLen = (snapshot.data! as dynamic)
                                            .docs
                                            .length;
                                        return buildStatColumn(
                                            postLen, 'posts');
                                      },
                                    ),
                                    StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(userData['uid'])
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return buildStatColumn(
                                              followers, 'followers');
                                        }
                                        followers = (snapshot.data!
                                                as dynamic)['followers']
                                            .length;
                                        return buildStatColumn(
                                            followers, 'followers');
                                      },
                                    ),
                                    StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(userData['uid'])
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return buildStatColumn(
                                              following, 'following');
                                        }
                                        following = (snapshot.data!
                                                as dynamic)['following']
                                            .length;
                                        return buildStatColumn(
                                            following, 'following');
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            text: 'Sign out',
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            textColor: primaryColor,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              await AuthMethods().signOut();
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginScreen(),
                                                ),
                                              );
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                text: 'Unfollow',
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  FirestoreMethods().followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    widget.uid,
                                                  );
                                                  setState(() {
                                                    isFollowing = false;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                text: 'follow',
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                borderColor: Colors.blue,
                                                function: () async {
                                                  FirestoreMethods().followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    widget.uid,
                                                  );
                                                  setState(() {
                                                    isFollowing = true;
                                                  });
                                                },
                                              ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Container(
                      //   alignment: Alignment.centerLeft,
                      //   padding: const EdgeInsets.only(
                      //     top: 15,
                      //   ),
                      //   child: Text(
                      //     userData['username'],
                      //     style: const TextStyle(
                      //       fontWeight: FontWeight.bold,
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   alignment: Alignment.centerLeft,
                      //   padding: const EdgeInsets.only(
                      //     top: 1,
                      //   ),
                      //   child: Center(
                      //       child: Text(
                      //     userData['bio'],
                      //   )),
                      // ),
                    ],
                  ),
                ),
          const Divider(),
          PostsGrid(widget: widget)
        ],
      ),
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
