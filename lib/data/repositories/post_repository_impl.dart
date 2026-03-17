import 'package:threads_clone/data/datasources/local_post_data_source.dart';
import 'package:threads_clone/data/models/post_model.dart';
import 'package:threads_clone/domain/entities/post.dart';
import 'package:threads_clone/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final LocalPostDataSource _local;

  PostRepositoryImpl(this._local);

  @override
  Future<void> createPost(Post post) async{
    final model = PostModel.fromEntity(post);
    await _local.savePost(model);
  }

  @override
  Future<List<Post>> getFeed() async {
    final models = await _local.getPosts();

    return models.map((model) => model.toEntity()).toList();
  }
}
