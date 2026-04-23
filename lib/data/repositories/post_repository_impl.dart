import 'package:threads_clone/data/datasources/local_post_data_source.dart';
import 'package:threads_clone/data/datasources/remote_post_data_source.dart';
import 'package:threads_clone/data/models/post_model.dart';
import 'package:threads_clone/domain/entities/post.dart';
import 'package:threads_clone/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final LocalPostDataSource _local;
  final RemotePostDataSource _remote;

  PostRepositoryImpl(this._local, this._remote);

  @override
  Future<void> createPost(Post post) async {
    
    String? finalImageUrl;
    if(post.imageUrl != null && post.imageUrl!.startsWith('/')){
      finalImageUrl = await _remote.uploadImage(post.imageUrl!);
    }

    final model = PostModel.fromEntity(post.copyWith(imageUrl: finalImageUrl));
    await _remote.createPost(model);
    await _local.savePost(model);
  }

  @override
  Future<List<Post>> getFeed() async {
    try {
      final remotePosts = await _remote.getPosts();

      await _local.clear();

      for (final post in remotePosts) {
        await _local.savePost(post);
      }

      return remotePosts.map((model) => model.toEntity()).toList();
    } catch (e) {
      final cached = await _local.getPosts();
      return cached.map((model) => model.toEntity()).toList();
    }
  }

  @override
  Future<void> likePost(String postId) async {
    final box = await _local.getPosts();

    final model = box.firstWhere((m) => m.id == postId);

    final likes = model.likes ?? 0;

    final updated = model.copyWith(
      likes: model.isLiked ? likes - 1 : likes + 1,
      isLiked: !model.isLiked,
    );

    await _local.updatePost(updated);
  }

   @override
  Future<List<Post>> getPostsByUser(String authorId) async {
    final models = await _local.getPostByUser(authorId);
    return models.map((m) => m.toEntity()).toList();
  }
}