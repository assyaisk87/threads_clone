import 'package:supabase/supabase.dart';
import 'package:threads_clone/data/models/comment_model.dart';

class RemoteCommentDataSource {
  final SupabaseClient _client;

  RemoteCommentDataSource(this._client);

  //getCommentsByPost
  Future<List<CommentModel>> getCommentsByPost(String postId) async {
    final response = await _client
        .from('comments')
        .select()
        .eq('post_id', postId)
        .order('created_at', ascending: true);

    final list = (response as List)
        .map((e) => CommentModel.fromJson(e))
        .toList();

    return list;
  }

  //saveComment
  Future<void> saveComment(CommentModel comment) async {
    await _client.from('comments').insert({
       'post_id': comment.postId,
      'content': comment.content,
      'author_id': comment.authorId,
    });
  }
}