import 'package:book_me_mobile_app/app/router/app_router.dart';
import 'package:book_me_mobile_app/app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BookMeApp extends StatelessWidget {
  const BookMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Me',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRouter.roleSelection,
      routes: AppRouter.routes,
    );
  }
}
