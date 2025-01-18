import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_f/pages/auth_screen.dart';
import 'package:test_f/pages/home_screen.dart';
import 'package:test_f/pages/registration_screen.dart';  // Add this import
import 'package:test_f/services/auth_service.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(MyApp());
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthService>(
            create: (_) => AuthService(),
            lazy: false,
          ),
        ],
        child: MaterialApp(
            title: 'Time Health',
            theme: ThemeData(
              primaryColor: Color(0xFF6C63FF),
              scaffoldBackgroundColor: Colors.white,
              fontFamily: 'Poppins',
              // Add more theme customization
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C63FF),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            debugShowCheckedModeBanner: false,  // Removes debug banner
            initialRoute: '/register',
            routes: {
              '/': (context) => Consumer<AuthService>(
                builder: (context, authService, child) {
                  return authService.user != null
                      ? HomeScreen()
                      : AuthScreen();
                },
              ),
              '/home': (context) => HomeScreen(),
              '/register': (context) => RegistrationScreen(),  // Add registration route
            },
            ),
        );
    }
}