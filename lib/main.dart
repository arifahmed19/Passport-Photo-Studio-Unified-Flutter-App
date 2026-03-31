import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme.dart';
import 'providers/passport_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/editor_screen.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // REPLACE with your Project URL and Anon Key from Supabase Dashboard
  await Supabase.initialize(
    url: 'https://dvxncyptzoeblzengbfk.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR2eG5jeXB0em9lYmx6ZW5nYmZrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ4OTg3NTAsImV4cCI6MjA5MDQ3NDc1MH0.4bk9ofpvZH8vfLsgk9pnBh3v87LXHM5sw6JU_SdiUC4',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PassportProvider()),
      ],
      child: const PassportPhotoStudioApp(),
    ),
  );
}

class PassportPhotoStudioApp extends StatelessWidget {
  const PassportPhotoStudioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Passport Photo Studio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return auth.isAuthenticated ? const HomeScreen() : const AuthScreen();
        },
      ),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/editor': (context) => const EditorScreen(),
        '/auth': (context) => const AuthScreen(),
      },
    );
  }
}
