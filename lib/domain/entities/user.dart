class User {
  final String id;
  final String username;
  final String avatarUrl;
  final String bio;
  final int postsCount;

  User({
    required this.id,
    required this.username,
    required this.avatarUrl,
    this.bio = '',
    this.postsCount = 0,
  });

  User copyWith({
    String? avatarUrl,
    String? username,
    String? bio,
    int? postsCount,
  }) {
    return User(
      id: id,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      postsCount: postsCount ?? this.postsCount,
    );
  }
}
