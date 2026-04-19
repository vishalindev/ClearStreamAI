import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/roles.dart';
import 'features/auth/auth_controller.dart';
import 'features/dashboard/home_page.dart';
import 'features/routes/app_routes.dart';
import 'widgets/placeholder_page.dart';

class ClearStreamApp extends StatefulWidget {
  const ClearStreamApp({super.key});

  @override
  State<ClearStreamApp> createState() => _ClearStreamAppState();
}

class _ClearStreamAppState extends State<ClearStreamApp> {
  final authController = AuthController();

  late final GoRouter router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) => '/dashboard',
      ),
      ...appRouteDefinitions.map(_mapRoute),
    ],
    errorBuilder: (_, state) => PlaceholderPage(
      title: 'Route not found',
      description: 'No route for ${state.uri}',
    ),
  );

  GoRoute _mapRoute(AppRouteDef routeDef) {
    return GoRoute(
      path: routeDef.path,
      redirect: (_, __) {
        if (!routeDef.roles.contains(authController.activeRole)) {
          return '/dashboard';
        }
        return null;
      },
      builder: (context, state) {
        if (routeDef.path == '/dashboard') {
          return HomePage(authController: authController);
        }

        return PlaceholderPage(
          title: routeDef.title,
          description:
              'Allowed roles: ${routeDef.roles.map((r) => r.label).join(', ')}\nPath params: ${state.pathParameters}',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ClearStreamAI SaaS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0B2D78)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF061D4D),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A2B72),
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFF0E397F),
          labelStyle: TextStyle(color: Colors.white70),
        ),
        textTheme: Typography.whiteMountainView,
      ),
      routerConfig: router,
    );
  }
}
