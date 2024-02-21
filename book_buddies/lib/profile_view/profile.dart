import 'package:book_buddies/profile_view/profile_edit.dart';
import 'package:flutter/material.dart';

class User {
  final AssetImage profilePicture;
  String fullName;
  String displayName;
  String email;
  String about;

  User({
    required this.profilePicture,
    required this.fullName,
    required this.displayName,
    required this.email,
    required this.about,
  });
}

class UserPreferences {
  static final User myUser = User(
    profilePicture:
        const AssetImage('assets/images/blankpfp.webp'),
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
    User user = UserPreferences.myUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(child:
      ListView(
        children: [
          Stack(
            children: [
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
                    )
                )
              ),
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
                        icon: const Icon(Icons.edit,
                          color: Colors.white,
                          size: 25,
                        ),
                        onPressed: () {
                                Navigator.push( context, MaterialPageRoute( builder: (context) => 
                                EditProfilePage()), ).then((value) => setState(() {}));
                              
                            },
                      ),
                    )
                  ),
                )
              ),
            ]
          ),

          const SizedBox(height: 24),
          buildName(user),
          const SizedBox(height: 24),
          //maybe put some metrics regarding books read?
          const SizedBox(height: 48),
          buildAbout(user),
        ],
        
      ),
    ));
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
