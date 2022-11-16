import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:snacks_pro_app/core/app.widget.dart';
import './firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppWidget();
  }
}
