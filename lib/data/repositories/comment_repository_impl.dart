import 'package:threads_clone/data/datasources/local_comment_data_source.dart';
import 'package:threads_clone/data/datasources/remote_comment_data_source.dart';
import 'package:threads_clone/data/models/comment_model.dart';
import 'package:threads_clone/domain/entities/comment.dart';
import 'package:threads_clone/domain/repositories/comment_repository.dart';

class CommentRepositoryImpl implements CommentRepository {
  final LocalCommentDataSource _local;
  final RemoteCommentDataSource _remote;

  CommentRepositoryImpl(this._local, this._remote);

  @override
  Future<void> addComment(Comment comment) async {
    final model = CommentModel.fromEntity(comment);
     await _remote.saveComment(model);
    await _local.saveComment(model);
  }

  @override
  Future<List<Comment>> getComments(String postId) async {
     try {
      final remoteComments = await _remote.getCommentsByPost(postId);

      _local.clear();
      for (final comment in remoteComments) {
        await _local.saveComment(comment);
      }
      return remoteComments.map((model) => model.toEntity()).toList();
    } catch (e, s) {
      print('object $s');
      final models = await _local.getCommentsByPost(postId);

   return models.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<int> getCommentsCount(String postId) async {
    return await _local.getCountByPost(postId);
  }
}