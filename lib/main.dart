import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'providers/recipe_provider.dart';
import 'providers/favorites_provider.dart';
import 'services/auth_service.dart';
import 'utils/theme.dart';
import 'firebase_options.dart';
import 'screens/favorites/favorites_screen.dart';
import 'providers/shopping_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => RecipeProvider()),
            ChangeNotifierProvider(create: (_) => FavoritesProvider()),
            ChangeNotifierProvider(create: (_) => ShoppingProvider()),
            StreamProvider<User?>.value(
              value: FirebaseAuth.instance.authStateChanges(),
              initialData: null,
            ),
          ],
          child:  MaterialApp(
            title: 'Recipes App',
            debugShowCheckedModeBanner: false,
            home: AuthGate(),
            routes: {
              '/favorites': (_) => FavoritesScreen(), // add this line
            },
          ),
        );
      },
    );
  }
}

// AuthGate.dart
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user == null) {
      return const SignInScreen();
    }

    return const HomeScreen();
  }
}