import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'library_page.dart';
import 'map.dart';
import 'profile/profile_page.dart';
import 'profile/login.dart';
import 'search_page.dart';
import 'feed/feed_page.dart';
import 'models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  runApp(
    ChangeNotifierProvider<User>.value(
      value: User(id: null),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  Future<FirebaseApp> _initializeFirebase() async {
    return await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: FutureBuilder(
                future: _initializeFirebase(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return const LoginScreen();
                  }
                  return const Center(child: CircularProgressIndicator());
                })));
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Book Buddies'),
            bottom: const TabBar(
              isScrollable: true,
              tabAlignment: TabAlignment.center,
              tabs: [
                Tab(text: "Search"),
                Tab(text: "My Library"),
                Tab(text: "Social"),
                Tab(text: "Map"),
                Tab(text: "Profile"),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Center(child: SearchPage()),
              Center(child: LibraryPage()),
              Center(child: FeedPage()),
              Center(child: LibraryMapScreen()),
              Center(child: ProfilePage()),
            ],
          ),
        ),
      ),
    );
  }
}
