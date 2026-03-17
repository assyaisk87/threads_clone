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
      emit(state.copyWith(
        status: FeedStatus.error,
        errorMessage: 'Ошибка создания поста'));
    }
  }
}
