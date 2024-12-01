import 'package:aad_oauth/aad_oauth.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AadOAuth oauth;

  AuthBloc(this.oauth) : super(AuthInitial()) {
    on<AuthEvent>((event, emit) {});
    on<AppStarted>((event, emit) => _onAppStarted(emit));
    on<LoginRequested>((event, emit) => _onLoginRequested(emit));
    on<LogoutRequested>((event, emit) => _onLogoutRequested(emit));
  }

  void _onAppStarted(Emitter<AuthState> emit) async {
    // Check if a stored access token exists
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');

    if (accessToken != null) {
      emit(Authenticated(accessToken));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await oauth.login();
      final accessToken = await oauth.getAccessToken();

      // Persist the access token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', accessToken!);

      emit(Authenticated(accessToken));
    } catch (e) {
      emit(AuthError("Login failed: $e"));
    }
  }

  Future<void> _onLogoutRequested(Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await oauth.logout();

      // Remove the stored token
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('access_token');

      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError("Logout failed: $e"));
    }
  }
}
