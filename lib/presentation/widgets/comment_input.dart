import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threads_clone/presentation/bloc/comments/comments_cubit.dart';
import 'package:threads_clone/presentation/bloc/comments/comments_state.dart';

class CommentInput extends StatefulWidget {
  const CommentInput({super.key});

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return 
    Padding(
      padding: EdgeInsets.all(8),
      child: BlocBuilder<CommentsCubit, CommentsState>(
        builder: (context, state) {return Row(
          children: [
            CircleAvatar(radius: 20, child: Icon(Icons.person)),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                hintText: 'Напишите комментарий...',
                
                ),onChanged: (value) {
                      context.read<CommentsCubit>().inputChanged(_textController.text);
                    },
              ),
            ),
            IconButton(onPressed: () {
              context.read<CommentsCubit>().addComment();
              _textController.clear();
              context.read<CommentsCubit>().inputChanged('');
            }, icon: Icon(Icons.send)),
          ],
        );}
      )
    );
  }
}
