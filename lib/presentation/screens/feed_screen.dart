import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threads_clone/presentation/bloc/feed_cubit.dart';
import 'package:threads_clone/presentation/bloc/feed_state.dart';
import 'package:threads_clone/presentation/screens/create_post_screen.dart';
import 'package:threads_clone/presentation/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {

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
      body: BlocConsumer<FeedCubit, FeedState>(
        listener: (context, state) {
           if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) { 
          var posts = state.posts;
          if (state.status == FeedStatus.loading && state.posts.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else if (state.status == FeedStatus.error) {
            return Center(child: Text(state.errorMessage ?? 'Ошибка'));
          } else if (posts.isEmpty) {
            return Center(child: Text('Нет постов'));
          }

         return ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 8),
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostCard(post: post);
          },
          separatorBuilder: (_, _) => Divider(height: 1),
          itemCount: posts.length,
        );},
      ),
    );
  }
}
