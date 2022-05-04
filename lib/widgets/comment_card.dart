import 'package:flutter/material.dart';
import 'package:fluttermdb/providers/user_provider.dart';
import 'package:fluttermdb/ressources/firestore_methods.dart';
import 'package:fluttermdb/utils/colors.dart';
import 'package:fluttermdb/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final dynamic snap;
  const CommentCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap['profilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const TextSpan(
                          text: ' ',
                          style: TextStyle(
                            color: primaryColor,
                          ),
                        ),
                        TextSpan(
                          text: widget.snap['text'],
                          style: const TextStyle(
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .add_jms()
                          .format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: LikeAnimation(
              isAnimating: widget.snap['likes'] != null &&
                  widget.snap['likes'].contains(userProvider.getUser.uid),
              child: IconButton(
                onPressed: () async {
                  await FirestoreMethods().likeComment(
                    widget.snap['commentId'],
                    userProvider.getUser.uid,
                    widget.snap['likes'],
                  );
                  setState(() {
                    isLikeAnimating = true;
                  });
                },
                icon: widget.snap['likes'] != null &&
                        widget.snap['likes'].contains(userProvider.getUser.uid)
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 26,
                      )
                    : const Icon(
                        Icons.favorite_border,
                        size: 26,
                      ),
              ),
            ),
            //const Icon(Icons.favorite, size: 26),
          )
        ],
      ),
    );
  }
}
