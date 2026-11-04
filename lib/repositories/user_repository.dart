import '../models/user.dart';

/// Interface abstraksi untuk operasi data pengguna[cite: 10].
abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUserById(int id);
}