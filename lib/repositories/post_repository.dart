import '../models/post.dart';

/// Interface abstraksi untuk operasi data Post.
abstract class PostRepository {
  Future<List<Post>> getPosts();
}