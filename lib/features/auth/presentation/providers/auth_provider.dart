import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/logger.dart';

// Current User Provider
final userProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Auth Controller
class AuthController extends StateNotifier<AsyncValue<void>> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthController() : super(const AsyncValue.data(null));

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      logger.i('User signed in: ${_auth.currentUser?.email}');
    });
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      logger.i('User signed up: ${_auth.currentUser?.email}');
    });
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _auth.signOut();
      logger.i('User signed out');
    });
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
      return AuthController();
    });
