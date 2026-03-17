import 'package:flutter/material.dart';

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
          TextButton(
            onPressed: () {
              
            },
            child: Text(
              'Опубликовать',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
