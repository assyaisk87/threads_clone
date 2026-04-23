import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threads_clone/domain/entities/comment.dart';
import 'package:threads_clone/domain/repositories/auth_repository.dart';
import 'package:threads_clone/domain/repositories/comment_repository.dart';
import 'package:threads_clone/presentation/bloc/comments/comments_state.dart';

class CommentsCubit extends Cubit<CommentsState> {
  final CommentRepository _repository;
  final String _postId;
  final AuthRepository _authRepository;

  CommentsCubit(this._repository, this._postId, this._authRepository): super(const CommentsState());

  Future<void> loadComment() async {
    emit(state.copyWith(status: CommentStatus.loading));

    try {
      final comments = await _repository.getComments(_postId);

      emit(state.copyWith(comments: comments, status: CommentStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: CommentStatus.failure,
          errorMessage: 'Ошибка загрузки',
        ),
      );
    }
  }

  void inputChanged(String value) {
    emit(state.copyWith(inputText: value));
  }

  Future<void> addComment() async {
    if (!state.canSubmit) return;

    final authUser = _authRepository.currentUser;

    final comment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: _postId,
      authorId: authUser!.id,
      content: state.inputText.trim(),
      createdAt: DateTime.now().toIso8601String(),
    );

    try {
      await _repository.addComment(comment);

      emit(
        state.copyWith(
          status: CommentStatus.success,
          inputText: '',
          comments: [...state.comments, comment],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CommentStatus.failure,
          errorMessage: 'Ошибка при отправке коментарий',
        ),
      );
    }
  }
}