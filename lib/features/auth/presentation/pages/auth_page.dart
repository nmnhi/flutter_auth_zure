import 'package:auth_azure/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Azure AD Login"),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Login success"),
              ),
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthInitial || state is Unauthenticated) {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<AuthBloc>().add(LoginRequested());
                },
                child: const Text("Login with Azure AD"),
              ),
            );
          } else if (state is AuthLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is Authenticated) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Access token: ${state.accessToken}"),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutRequested());
                    },
                    child: const Text("Logout"),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text("No data"));
        },
      ),
    );
  }
}
