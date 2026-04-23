import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threads_clone/domain/repositories/auth_repository.dart';
import 'package:threads_clone/domain/repositories/comment_repository.dart';
import 'package:threads_clone/locator.dart';
import 'package:threads_clone/domain/entities/post.dart';
import 'package:threads_clone/presentation/bloc/comments/comments_cubit.dart';
import 'package:threads_clone/presentation/bloc/comments/comments_state.dart';
import 'package:threads_clone/presentation/widgets/comment_input.dart';
import 'package:threads_clone/presentation/widgets/comment_tile.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key, required this.post});

  final Post post;

  static Future<void> show(BuildContext context, Post post) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BlocProvider(
          create: (context) =>
              CommentsCubit(locator<CommentRepository>(), post.id!, locator<AuthRepository>())..loadComment(),
            
          
          child: CommentsScreen(post: post),
        );
      },
    );
  }

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CommentsCubit>().loadComment();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
            child: Row(
              children: [
                Text(
                  'Коментарий',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          Expanded(
            child: BlocBuilder<CommentsCubit, CommentsState>(
              builder: (context, state) {
                if (state.status == CommentStatus.loading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (state.comments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.mode_comment_outlined),
                        SizedBox(height: 12),
                        Text(
                          'Пока нет ответов',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemBuilder: (context, index) {
                    return CommentTile(comment: state.comments[index]);
                  },
                  separatorBuilder: (_, _) =>
                      Divider(height: 1, color: Colors.grey.shade100),
                  itemCount: state.comments.length,
                );
              },
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          CommentInput(),
        ],
      ),
    );
  }
}