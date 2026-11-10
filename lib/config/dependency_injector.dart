import 'package:flutter/widgets.dart';
import '../repositories/post_repository.dart';
import '../repositories/post_repository_impl.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../services/api_service.dart';

/// Penyedia dependency sederhana (Dependency Injection).
///
/// Menyimpan satu instance [ApiService] (singleton) yang dibagikan ke
/// [UserRepository] dan [PostRepository]. Semua dependency bisa
/// digantikan (mis. mock) lewat constructor untuk pengujian.
class DependencyInjector {
  /// Membuat injector. Parameter opsional untuk meng-override dependency.
  DependencyInjector({
    ApiService? apiService,
    UserRepository? userRepository,
    PostRepository? postRepository,
  })  : _apiService = apiService,
        _userRepository = userRepository,
        _postRepository = postRepository;

  /// Instance singleton default yang dipakai aplikasi.
  static final DependencyInjector instance = DependencyInjector();

  ApiService? _apiService;
  UserRepository? _userRepository;
  PostRepository? _postRepository;

  /// Instance tunggal [ApiService] (dibuat saat pertama kali dipakai).
  ApiService get apiService => _apiService ??= ApiService();

  /// Repository pengguna.
  UserRepository get userRepository =>
      _userRepository ??= UserRepositoryImpl(apiService: apiService);

  /// Repository post.
  PostRepository get postRepository =>
      _postRepository ??= PostRepositoryImpl(apiService: apiService);
}

/// [InheritedWidget] yang menyediakan [DependencyInjector] ke widget tree.
class DependencyProvider extends InheritedWidget {
  const DependencyProvider({
    super.key,
    required this.injector,
    required super.child,
  });

  /// Injector yang disediakan ke seluruh subtree.
  final DependencyInjector injector;

  /// Mengambil injector terdekat; jika tidak ada, memakai
  /// [DependencyInjector.instance].
  static DependencyInjector of(BuildContext context) {
    final provider =
        context.getInheritedWidgetOfExactType<DependencyProvider>();
    return provider?.injector ?? DependencyInjector.instance;
  }

  @override
  bool updateShouldNotify(DependencyProvider oldWidget) =>
      injector != oldWidget.injector;
}
