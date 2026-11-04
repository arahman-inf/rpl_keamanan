import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/secure_storage_service.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../repositories/post_repository.dart';
import '../repositories/post_repository_impl.dart';

/// Injeksi dependensi terpusat berbasis InheritedWidget untuk menyediakan
/// instance Service dan Repository ke seluruh hirarki widget.
class DependencyInjector extends InheritedWidget {
  final ApiService apiService;
  final SecureStorageService secureStorageService;
  final UserRepository userRepository;
  final PostRepository postRepository;

  DependencyInjector({
    super.key,
    required super.child,
    ApiService? apiService,
    SecureStorageService? secureStorageService,
    UserRepository? userRepository,
    PostRepository? postRepository,
  })  : apiService = apiService ?? ApiService(),
        secureStorageService = secureStorageService ?? SecureStorageService(),
        userRepository = userRepository ??
            UserRepositoryImpl(apiService: apiService ?? ApiService()),
        postRepository = postRepository ??
            PostRepositoryImpl(apiService: apiService ?? ApiService());

  static DependencyInjector of(BuildContext context) {
    final DependencyInjector? result =
        context.dependOnInheritedWidgetOfExactType<DependencyInjector>();
    assert(result != null, 'DependencyInjector tidak ditemukan pada BuildContext');
    return result!;
  }

  @override
  bool updateShouldNotify(DependencyInjector oldWidget) => false;
}