import 'package:flutter/material.dart';
// import 'profile.dart';
import '../models.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<User>(context, listen: true);
  return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(child:
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
          ))),
          Positioned(
            bottom: 0,
            right: 90,
            child: buildPhotoIcon(Theme.of(context).colorScheme.primary),
            //photo icon not functional !
            
          ),
          ]),

          const SizedBox(height: 24),
                TextField(
                  decoration: InputDecoration(
                  hintText: user.displayName,
                  labelText: 'Username',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
                  onChanged: (displayName) {
                    user.setDisplayName(displayName);
                  },
                ),
                const SizedBox(height: 24),
                TextField(
                  decoration: InputDecoration(
                  hintText: user.fullName,
                  labelText: 'Full Name',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
                  onChanged: (fullName) {
                    user.setFullName(fullName);
                  },
                ),
                const SizedBox(height: 24),
                TextField(
                  
                  decoration: InputDecoration(
                  hintText: user.about,
                  labelText: 'About',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
                  onChanged: (about) {
                    user.setAbout(about);
                  },
                ),
                const SizedBox(height: 10),
                


                
        ],
        
      ),
    )));
  }

}

Widget buildPhotoIcon(Color color) => 
        ClipOval(
        child: Container(
          padding: const EdgeInsets.all(8),
          color: color,
          child: const Icon(Icons.upload,
            color: Colors.white,
            size: 20,
          ),
        )

        ,
      );