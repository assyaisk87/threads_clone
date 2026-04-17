import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threads_clone/domain/entities/user.dart';
import 'package:threads_clone/domain/repositories/post_repository.dart';
import 'package:threads_clone/presentation/bloc/profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final PostRepository _postRepository;

  ProfileCubit(this._postRepository) : super(const ProfileState());

  Future<void> loadProfile(String userId) async {
    emit(state.copyWith(status: ProfileStatus.loading));

    try {
      final posts = await _postRepository.getPostsByUser(userId);

      final user = _getMockUser(userId, posts.length);

      emit(
        state.copyWith(status: ProfileStatus.loaded, posts: posts, user: user),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: 'Не удалось загрузить профиль',
        ),
      );
    }
  }

  User _getMockUser(String userId, int postCount) {
    final mockUsers = {
      'me': User(
        id: 'me',
        username: 'Me',
        avatarUrl: '',
        bio: 'Flutter Dev',
        postsCount: postCount,
      ),
      '1': User(
        id: '1',
        username: 'Aizhan',
        avatarUrl: '',
        bio: 'Люблю кофе и Flutter',
        postsCount: postCount,
      ),
      '2': User(
        id: '2',
        username: 'Dani',
        avatarUrl: '',
        bio: 'Backend Developer',
        postsCount: postCount,
      ),
      '3': User(
        id: '3',
        username: 'Qana',
        avatarUrl: '',
        bio: 'IT user',
        postsCount: postCount,
      ),
    };
    return mockUsers[userId] ??
        User(
          id: userId,
          username: userId,
          avatarUrl: '',
          postsCount: postCount,
        );
  }
}