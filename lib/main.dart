import 'package:auth_azure/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:auth_azure/features/auth/presentation/pages/auth_page.dart';
import 'package:auth_azure/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => locator<AuthBloc>()..add(AppStarted()),
          )
        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const AuthPage(),
        ));
  }
}
