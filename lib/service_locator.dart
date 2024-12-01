import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:auth_azure/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;
final navigatorKey = GlobalKey<NavigatorState>();

void setupLocator() {
  // Configure Azure AD OAuth
  final AadOAuth oauth = AadOAuth(Config(
    tenant: 'YOUR_TENANT_ID',
    clientId: 'YOUR_CLIENT_ID',
    scope: 'openid profile offline_access',
    redirectUri: 'https://login.live.com/oauth20_desktop.srf',
    navigatorKey: navigatorKey,
    webUseRedirect: true,
    loader: const Center(child: CircularProgressIndicator()),
  ));

  // Register services and bloc
  locator.registerSingleton<AadOAuth>(oauth);
  locator.registerFactory(() => AuthBloc(oauth));
}
