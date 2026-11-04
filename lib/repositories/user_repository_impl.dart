import '../models/user.dart';
import '../services/api_service.dart';
import 'user_repository.dart';

/// Implementasi konkret dari [UserRepository] menggunakan [ApiService][cite: 12].
class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService;

  UserRepositoryImpl({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  @override
  Future<List<User>> getUsers() async {
    return await _apiService.getUsers();
  }

  @override
  Future<User> getUserById(int id) async {
    return await _apiService.getUserById(id);
  }

  void dispose() {
    _apiService.dispose();
  }
}