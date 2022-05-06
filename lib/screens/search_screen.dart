import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttermdb/screens/profile_screen.dart';
import 'package:fluttermdb/utils/colors.dart';
import 'package:fluttermdb/utils/global_variables.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = true;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search for a user',
          ),
          onChanged: (String _) {
            setState(() {
              isShowUsers = true;
            });
            // if (searchController.text != '') {
            //   setState(() {
            //     isShowUsers = true;
            //   });
            // } else {
            //   setState(() {
            //     isShowUsers = false;
            //   });
            // }
          },
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (contex, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List<dynamic> listUsers = <dynamic>[];
                if ((snapshot.data! as dynamic).docs.length > 0) {
                  listUsers = (snapshot.data! as dynamic).docs;
                  listUsers = listUsers
                      .where((x) =>
                          x['username'].startsWith(searchController.text))
                      .toList();
                  //print(listUsers[0]);
                }
                return ListView.builder(
                  //itemCount: (snapshot.data! as dynamic).docs.length,
                  itemCount: listUsers.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(uid: listUsers[index]['uid']),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            listUsers[index]['photoUrl'],
                          ),
                        ),
                        title: Text(
                          listUsers[index]['username'],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                final width = MediaQuery.of(context).size.width;
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => Image.network(
                      (snapshot.data! as dynamic).docs[index]['postUrl']),
                  staggeredTileBuilder: (index) => width > webScreenSize
                      ? StaggeredTile.count(
                          (index % 7 == 0) ? 1 : 1,
                          (index % 7 == 0) ? 1 : 1,
                        )
                      : StaggeredTile.count(
                          (index % 7 == 0) ? 2 : 1,
                          (index % 7 == 0) ? 2 : 1,
                        ),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                );
              },
            ),
    );
  }
}
