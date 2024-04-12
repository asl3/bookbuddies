import 'package:book_buddies/profile/edit_profile_page.dart';
// import 'package:book_buddies/library_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:book_buddies/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../utils.dart';
import 'login.dart';
import 'friends_page.dart';
import 'stats_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: true);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: SafeArea(
            child: Center(
          child: ListView(
            children: [
              Stack(children: [
                Container(
                    alignment: Alignment.center,
                    child: ClipOval(
                        clipper: MyClip(),
                        child: Material(
                          color: Colors.transparent,
                          child: Image(
                            image: user.profilePicture,
                            fit: BoxFit.fitWidth,
                            width: 200,
                            height: 200,
                          ),
                        ))),
                Positioned(
                    bottom: 0,
                    right: 110,
                    child: ClipOval(
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Theme.of(context).colorScheme.primary,
                          child: SizedBox(
                            height: 25.0,
                            width: 25.0,
                            child: IconButton(
                              padding: const EdgeInsets.all(0.0),
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 25,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EditProfilePage()),
                                ).then((value) => setState(() {}));
                              },
                            ),
                          )),
                    )),
              ]),

              const SizedBox(height: 24),
              buildName(user),
              // const SizedBox(height: 24),

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FriendsPage()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Friends',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.add,
                            color: Colors.black,
                            size: 25,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.friends.length == 1
                            ? 'You have 1 friend'
                            : 'You have ${user.friends.length} friends',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              //maybe put some metrics regarding books read?
              // const SizedBox(height: 30),
              buildStats(),
              // const SizedBox(height: 30),
              buildAbout(user),
              // const SizedBox(height: 30),
              // buildLibrary(),
              buildLogout()
            ],
          ),
        )));
  }

  Widget buildLogout() => FittedBox(
      fit: BoxFit.scaleDown,
      child: TextButton(
        onPressed: () async {
          fb.FirebaseAuth auth = fb.FirebaseAuth.instance;
          await auth.signOut();
          Provider.of<User>(context, listen: false).setId(null);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        },
        style: TextButton.styleFrom(
            backgroundColor: Colors.redAccent.shade700,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25)),
        child: const Text(
          'Logout',
          style: TextStyle(color: Colors.white),
        ),
      ));

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
          ),
          const SizedBox(height: 4),
          /*Text(
            user.fullName,
            style: const TextStyle(fontSize: 24),
          ),*/
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout(User user) => Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              user.about,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );

  Widget buildLibrary() => Container(
        padding: const EdgeInsets.all(16.0),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Library',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 1000,
              child: LibraryPage(),
            ),
          ],
        ),
      );

  Widget buildStats() => InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StatsPage()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: const Row(
            children: [
              Text(
                'Stats',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.arrow_right,
                color: Colors.black,
                size: 25,
              ),
            ],
          ),
        ),
      );
}
