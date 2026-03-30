import 'package:threads_clone/domain/entities/post.dart';
import 'package:threads_clone/domain/repositories/post_repository.dart';
import 'package:threads_clone/presentation/bloc/feed_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedCubit extends Cubit<FeedState> {
  final PostRepository _repository;

  FeedCubit(this._repository) : super(const FeedState());

  Future<void> loadFeed() async {
    emit(state.copyWith(status: FeedStatus.loading));

    try {
      final posts = await _repository.getFeed();

      emit(
        state.copyWith(
          status: FeedStatus.success,
          posts: posts,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FeedStatus.error,
          errorMessage: 'Ошибка загрузки ленты',
        ),
      );
    }
  }

  Future<void> createPost(String content) async {
    final newPost = Post(
      id: DateTime.now().millisecond.toString(),
      content: content,
      authorId: 'me',
      createdAt: '',
      likes: 0,
    );

    try {
      await _repository.createPost(newPost);
      loadFeed();
    } catch (e) {
      emit(
        state.copyWith(
          status: FeedStatus.error,
          errorMessage: 'Ошибка создания поста',
        ),
      );
    }
  }

  Future<void> likePost(String postId) async {
    final updatedPosts = state.posts.map((post) {
      if (post.id != postId) return post;

        final likes = post.likes ?? 0;

      return post.copyWith(
        likes: post.isLiked ? likes - 1 : likes + 1,
        isLiked: !post.isLiked,
      );
    }).toList();

    try {
      await _repository.likePost(postId);
      emit(state.copyWith(posts: updatedPosts));
    } catch (e) {
      await loadFeed();
    }
  }
}