import 'package:firebase_auth/firebase_auth.dart' as auth;
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
      value: User(id: null, loadFull: true),
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
    User myUser = Provider.of<User>(context, listen: true);

    Future<int> initializeUser(String uid) async {
      if (myUser.id == uid) return 1;
      myUser.setId(uid);
      await myUser.loadData();
      return 1;
    }

    return MaterialApp(
        home: Scaffold(
            body: FutureBuilder(
                future: _initializeFirebase(),
                builder: (context, snapshot) {
                  if (Firebase.apps.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (auth.FirebaseAuth.instance.currentUser != null) {
                    return FutureBuilder(
                      future: initializeUser(auth.FirebaseAuth.instance.currentUser!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return const MainScreen();
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    );
                  } else {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return const LoginScreen();
                    }
                    return const Center(child: CircularProgressIndicator());
                  }
                })));
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User myUser = Provider.of<User>(context, listen: true);

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
          body: TabBarView(
            children: [
              const Center(child: SearchPage()),
              Center(child: LibraryPage(owner: myUser)),
              const Center(child: FeedPage()),
              const Center(child: LibraryMapScreen()),
              const Center(child: ProfilePage()),
            ],
          ),
        ),
      ),
    );
  }
}
