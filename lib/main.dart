import 'package:book_me_mobile_app/app/app.dart';
import 'package:book_me_mobile_app/app/bootstrap/firebase_bootstrap.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseBootstrap.initialize();
  runApp(const BookMeApp());
}
