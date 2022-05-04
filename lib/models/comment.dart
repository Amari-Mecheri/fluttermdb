import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String text;
  final String uid;
  final String name;
  final String commentId;
  final DateTime datePublished;
  final String profilePic;
  final dynamic likes;

  const Comment({
    required this.text,
    required this.uid,
    required this.name,
    required this.commentId,
    required this.datePublished,
    required this.profilePic,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'uid': uid,
        'name': name,
        'commentId': commentId,
        'datePublished': datePublished,
        'profilePic': profilePic,
        'likes': likes,
      };

  static Comment fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Comment(
      text: snapshot['text'],
      uid: snapshot['uid'],
      name: snapshot['name'],
      commentId: snapshot['commentId'],
      datePublished: snapshot['datePublished'],
      profilePic: snapshot['profilePic'],
      likes: snapshot['likes'],
    );
  }
}
