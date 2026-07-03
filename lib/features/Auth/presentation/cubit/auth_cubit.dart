import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repo.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

class AuthEmailUnverified extends AuthState {
  final User user;
  AuthEmailUnverified(this.user);
}

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  Timer? _verificationTimer;

  AuthCubit(this._repository) : super(AuthInitial()) {
    _repository.user.listen((user) {
      if (user != null) {
        if (user.emailVerified) {
          _verificationTimer?.cancel();
          emit(AuthAuthenticated(user));
        } else {
          emit(AuthEmailUnverified(user));
          _startVerificationCheck();
        }
      } else {
        _verificationTimer?.cancel();
        emit(AuthUnauthenticated());
      }
    });
  }

  void _startVerificationCheck() {
    _verificationTimer?.cancel();
    _verificationTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _repository.reloadUser();
    });
  }

  Future<void> resendVerificationEmail() async {
    try {
      await _repository.resendVerificationEmail();
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await _repository.signIn(email, password);
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Authentication failed"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      await _repository.signUp(email, password, name);
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Registration failed"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final credential = await _repository.signInWithGoogle();
      if (credential == null) emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> sendPasswordReset(String email) async {
    emit(AuthLoading());
    try {
      await _repository.sendPasswordReset(email);
      emit(AuthUnauthenticated()); // Reset state to allow fresh login
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signOut() async {
    _verificationTimer?.cancel();
    await _repository.signOut();
  }

  @override
  Future<void> close() {
    _verificationTimer?.cancel();
    return super.close();
  }
}
