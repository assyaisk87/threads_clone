import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:threads_clone/data/datasources/local_post_data_source.dart';
import 'package:threads_clone/data/repositories/post_repository_impl.dart';
import 'package:threads_clone/domain/entities/post.dart';
import 'package:threads_clone/presentation/bloc/create_post/create_post_cubit.dart';
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
              final local = LocalPostDataSource();
              final repository = PostRepositoryImpl(local);
              final imagePicker = ImagePicker();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => CreatePostCubit(repository, imagePicker),
                    child: CreatePostScreen(),
                  ),
                ),
              );
            },
            icon: Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: BlocConsumer<FeedCubit, FeedState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state.status == FeedStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state.posts.isEmpty) {
            return Text('Список пуст');
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final post = state.posts[index];
              return PostCard(post: post);
            },
            separatorBuilder: (_, _) => Divider(height: 1),
            itemCount: state.posts.length,
          );
        },
      ),
    );
  }
}

