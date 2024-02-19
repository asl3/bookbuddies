import 'package:flutter/material.dart';

class User {
  final String profilePicture;
  final String fullName;
  final String displayName;
  final String email;
  final String about;

  const User({
    required this.profilePicture,
    required this.fullName,
    required this.displayName,
    required this.email,
    required this.about,
  });
}

class UserPreferences {
  static const myUser = User(
    profilePicture:
        'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
    fullName: 'Name',
    displayName: 'ireadbooks123',
    email: 'example@umd.edu',
    about: "I'm currently reading The Great Gatsby!",
  );
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    const user = UserPreferences.myUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        children: [
          Center(
            child: ClipOval(
                clipper: MyClip(),
                child: Material(
                  color: Colors.transparent,
                  child: Ink.image(
                    image: NetworkImage(user.profilePicture),
                    fit: BoxFit.fitWidth,
                    width: 200,
                    height: 200,
                  ),
                )),
          ),
          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(height: 24),
          //maybe put some metrics regarding books read?
          const SizedBox(height: 48),
          buildAbout(user),
        ],
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.displayName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
          ),
          const SizedBox(height: 4),
          Text(
            user.fullName,
            style: const TextStyle(fontSize: 24),
          ),
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
}

class MyClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return const Rect.fromLTWH(0, 0, 200, 200);
  }

  @override
  bool shouldReclip(oldClipper) {
    return true;
  }
}
