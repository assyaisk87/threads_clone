import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:threads_clone/data/models/comment_model.dart';

class LocalCommentDataSource {
  static const _boxName = 'comments';

  Future<Box<CommentModel>> get _box async =>
      Hive.openBox<CommentModel>(_boxName);

  Future<List<CommentModel>> getCommentsByPost(String postId) async {
    final box = await _box;

    final comments = box.values.where((c) => c.postId == postId).toList();

    comments.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

    return comments;
  }

  Future<void> saveComment(CommentModel comment) async {
    final box = await _box;
    await box.put(comment.id, comment);
  }

 Future<int> getCountByPost(String id) async {
    final box = await _box;

    final comments = box.values.where((c) => c.id == id).toList();

    return comments.length;
  }

    Future<void> clear() async {
    final box = await _box;
    await box.clear();
  }
}