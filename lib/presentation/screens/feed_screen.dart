import 'package:flutter/material.dart';
import 'package:threads_clone/domain/entities/post.dart';
import 'package:threads_clone/presentation/screens/create_post_screen.dart';
import 'package:threads_clone/presentation/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = [
      Post(
        id: '1',
        content: 'content1',
        authorId: '1',
        createdAt: DateTime.now().toString(),
        likes: 3,
      ),
      Post(
        id: '2',
        content: 'content2',
        authorId: '2',
        createdAt: DateTime.now().toString(),
        likes: 6,
      ),
      Post(
        id: '3',
        content: 'content3',
        authorId: '3',
        createdAt: DateTime.now().toString(),
        likes: 9,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Threads v2.0',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CreatePostScreen()),
              );
            },
            icon: Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) {
          final post = posts[index];
          return PostCard(post: post);
        },
        separatorBuilder: (_, _) => Divider(height: 1),
        itemCount: posts.length,
      ),
    );
  }
}
