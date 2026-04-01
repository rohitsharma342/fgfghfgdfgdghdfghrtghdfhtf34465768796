import '../models/user_model.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  Future<Map<String, dynamic>> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (email == 'test@test.com' && password == 'password123') {
      _currentUser = UserModel(
        id: 'user_1',
        name: 'John Doe',
        email: email,
        bio: 'Passionate about connecting people and building communities.',
        profileImageUrl: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
        followersCount: 1234,
        followingCount: 567,
        postsCount: 89,
      );
      return {'success': true, 'user': _currentUser};
    }
    
    if (email.isNotEmpty && password.length >= 6) {
      _currentUser = UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@').first,
        email: email,
        bio: 'New to Social Connect!',
        profileImageUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
        followersCount: 0,
        followingCount: 0,
        postsCount: 0,
      );
      return {'success': true, 'user': _currentUser};
    }
    
    return {'success': false, 'error': 'Invalid email or password'};
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (email == 'test@test.com') {
      return {'success': false, 'error': 'Email already exists'};
    }
    
    _currentUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      bio: 'New member of Social Connect!',
      profileImageUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
      followersCount: 0,
      followingCount: 0,
      postsCount: 0,
    );
    
    return {'success': true, 'user': _currentUser};
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  bool get isLoggedIn => _currentUser != null;
}