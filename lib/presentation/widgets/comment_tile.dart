import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:threads_clone/domain/entities/comment.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey.shade200,
            child: Text(
              comment.authorId![0],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Text(comment.authorId ?? 'NO DATA'),
                    Spacer(),
                    Text(_formatTime(comment.createdAt!)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(comment.content ?? '', style: TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final diff = DateTime.now().difference(date);

      if (diff.inMinutes < 1) return 'только что';
      if (diff.inHours < 1) return '${diff.inMinutes} м.';
      if (diff.inDays < 1) return '${diff.inHours} ч.';

      return '${diff.inDays} д';
    } catch (_) {
      return '';
    }
  }
}