import 'package:book_me_mobile_app/app/router/app_router.dart';
import 'package:book_me_mobile_app/app/theme/app_theme.dart';
import 'package:book_me_mobile_app/features/auth/application/auth_controller.dart';
import 'package:flutter/material.dart';

class BookMeApp extends StatefulWidget {
  const BookMeApp({super.key});

  @override
  State<BookMeApp> createState() => _BookMeAppState();
}

class _BookMeAppState extends State<BookMeApp> {
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController();
  }

  @override
  void dispose() {
    _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _authController,
      builder: (context, child) {
        return MaterialApp(
          title: 'Book Me',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          initialRoute: AppRouter.roleSelection,
          onGenerateRoute: (settings) => AppRouter.generateRoute(
            settings: settings,
            authController: _authController,
          ),
        );
      },
    );
  }
}
