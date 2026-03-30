import 'package:threads_clone/data/datasources/local_comment_data_source.dart';
import 'package:threads_clone/data/models/comment_model.dart';
import 'package:threads_clone/domain/entities/comment.dart';
import 'package:threads_clone/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final LocalCommentDataSource _local;

  CommentRepositoryImpl(this._local);

  @override
  Future<void> addComment(Comment comment) async {
    final model = CommentModel.fromEntity(comment);
    _local.saveComment(model);
  }

  @override
  Future<List<Comment>> getComments(String postId) async {
    final models = await _local.getCommentsByPost(postId);

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<int> getCommentsCount(String postId) async {
    return await _local.getCountByPost(postId);
  }
}