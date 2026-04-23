import 'dart:io';

import 'package:supabase/supabase.dart';
import 'package:threads_clone/data/models/post_model.dart';

class RemotePostDataSource {
  final SupabaseClient _client;

  RemotePostDataSource(this._client);

  Future<List<PostModel>> getPosts() async {
    final response = await _client
        .from('posts')
        .select()
        .order('created_at', ascending: false);

    final list = (response as List)
        .map((element) => PostModel.fromJson(element))
        .toList();

    return list;
  }

  Future<void> createPost(PostModel post) async {
    await _client.from('posts').insert({
      'content': post.content,
      'author_id': post.authorId,
      'image_url': post.imageUrl,
      'likes': 0,
    });
  }

  Future<String> uploadImage(String locatPath) async{
    final file = File(locatPath);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';    

    await _client.storage.from('posts').upload(fileName, file, fileOptions: FileOptions(contentType: 'image/jpeg', upsert: true));
    final publicUrl = _client.storage.from('posts').getPublicUrl(fileName);
    return publicUrl;
  }

  Future<List<PostModel>> getPostsByUser(String authorId) async {
    final response = await _client
        .from('posts')
        .select()
        .eq('author_id', authorId)
        .order('created_at', ascending: false);

    final list = (response as List)
        .map((element) => PostModel.fromJson(element))
        .toList();

    return list;
  }
}