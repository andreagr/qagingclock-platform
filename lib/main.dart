import 'package:flutter/material.dart';
import 'package:qagingclock/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qagingclock/pages/login_page.dart';
import 'package:qagingclock/pages/menu.dart';
import 'package:qagingclock/pages/previous_submissions.dart';
import 'package:qagingclock/providers/auth_provider.dart';
import 'package:qagingclock/stepper_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Q-AgingClock',
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(),
          useMaterial3: true,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (_) => LoginScreen(),
          '/register': (_) => RegisterScreen(),
          '/home': (_) => UserChoiceScreen(),
          '/analysis': (_) => StepperScreen(),
          '/submissions': (_) => PreviousSubmissionsScreen()
        },
      ),
    );
  }
}
