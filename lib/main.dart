import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lms/authentication/Screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'models/provider_notifier.dart';
import 'quiz/services/quiz_state.dart';
import 'widget/welcome.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  kIsWeb
      ? await Firebase.initializeApp(
          options: FirebaseOptions(
              apiKey: "AIzaSyCzVAw9yZYOsXL1n5iFL1Ppowza2Xcpd_A",
              authDomain: "projectwork-322110.firebaseapp.com",
              projectId: "projectwork-322110",
              storageBucket: "projectwork-322110.appspot.com",
              messagingSenderId: "475125349650",
              appId: "1:475125349650:web:9591241ed70cd0df7e47cb"),
        )
      : await Firebase.initializeApp();

  setPathUrlStrategy();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProviderNotifier>(
          create: (context) => ProviderNotifier(),
        ),
        ChangeNotifierProvider<QuizState>(
          create: (context) => QuizState(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                return WelcomeScreen();
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Unknown Error Occurred'),
                );
              } else {
                return SignIn();
              }
            },
          )),
    );
  }
}
