import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threads_clone/presentation/bloc/create_post/create_post_cubit.dart';
import 'package:threads_clone/presentation/bloc/create_post/create_post_state.dart';
import 'package:threads_clone/presentation/bloc/feed_cubit.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Новый пост'),
        actions: [
          BlocConsumer<CreatePostCubit, CreatePostState>(
            listenWhen: (prev, curr) => prev.status != curr.status,
            listener: (context, state) {
              if (state.status == CreatePostStatus.success) {
                context.read<FeedCubit>().loadFeed();
                Navigator.pop(context);
              }

              if (state.status == CreatePostStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage ?? 'Ошибка'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },

            builder: (context, state) {
              return TextButton(
                onPressed: state.canSubmit
                    ? () {
                        context.read<CreatePostCubit>().submit();
                      }
                    : null,
                child: Text(
                  'Опубликовать',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 20, child: Icon(Icons.person)),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Что у вас нового?',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      context.read<CreatePostCubit>().contentChanged(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            BlocBuilder<CreatePostCubit, CreatePostState>(
              builder: (context, state) {
                if (state.imageUrl == null) {
                  return SizedBox.shrink();
                }
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(state.imageUrl!),
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          context.read<CreatePostCubit>().removeImage();
                        },
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.read<CreatePostCubit>().pickFromGallery();
                  },
                  icon: Icon(Icons.photo_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}