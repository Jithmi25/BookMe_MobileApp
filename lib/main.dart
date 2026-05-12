import 'package:book_me_mobile_app/app/app.dart';
// Backend initialization is commented out for UI-only prototype work.
// To re-enable backend, restore the firebase_bootstrap import and await call.
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await FirebaseBootstrap.initialize(); // disabled for frontend-only prototype
  runApp(const BookMeApp());
}
