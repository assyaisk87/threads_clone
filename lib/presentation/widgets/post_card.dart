import 'package:flutter/material.dart';
import 'package:threads_clone/domain/entities/post.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(radius: 20, child: Icon(Icons.person)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.authorId,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(post.content, style: TextStyle(fontSize: 15)),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Icon(Icons.favorite_border, size: 20),
                    const SizedBox(width: 20),
                    Icon(Icons.mode_comment_outlined, size: 20),
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
