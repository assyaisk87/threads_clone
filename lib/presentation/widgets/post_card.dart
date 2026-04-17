import 'package:flutter/material.dart';
import 'package:threads_clone/domain/entities/post.dart';
import 'package:threads_clone/presentation/screens/comments_screen.dart';
import 'package:threads_clone/presentation/widgets/like_button.dart';
import 'package:threads_clone/presentation/screens/profile_screen.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                ProfileScreen.route(context, post.authorId!),
              );
            },
            child: CircleAvatar(radius: 20, child: Icon(Icons.person)),
          ),          
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.authorId ?? 'null',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(post.content ?? '', style: TextStyle(fontSize: 15)),
                const SizedBox(height: 10),

                Row(
                  children: [
                    LikeButton(post: post),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => CommentsScreen.show(context, post),
                      child: Icon(Icons.mode_comment_outlined, size: 20),
                    ),
                    const SizedBox(width: 20),
                    Icon(Icons.repeat, size: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}