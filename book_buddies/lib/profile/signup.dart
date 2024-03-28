import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'login.dart';
import '../models/user.dart' as bb_user;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static Future<User?> signupUsingEmailPassword(
      {required String email,
      required String password,
      required String displayName,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;

      bb_user.User.createUser(user, email, displayName);
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use" || e.code == "invalid-email") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Signup Error"),
              content: const Text("This email is invalid or in use."),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {},
                ),
              ],
            );
          },
        );
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Book Buddies",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold)),
                              const Text("Register User",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 38,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 44),
                              TextField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                    hintText: "Username",
                                    prefixIcon: Icon(Icons.alternate_email)),
                              ),
                              const SizedBox(height: 26),
                              TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    hintText: "Email",
                                    prefixIcon: Icon(Icons.mail)),
                              ),
                              const SizedBox(height: 26),
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                    hintText: "Password",
                                    prefixIcon: Icon(Icons.lock)),
                              ),
                              const SizedBox(height: 26),
                              Center(
                                  child: InkWell(
                                      child: const Text("Back to login",
                                          style: TextStyle(
                                              color: Colors.deepPurple)),
                                      onTap: () => Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen())))),
                              const SizedBox(height: 70),
                              Center(
                                  child: SizedBox(
                                      width: 120,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                            backgroundColor: Colors.deepPurple,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 15, horizontal: 25)),
                                        child: const Text("Sign Up",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20)),
                                        onPressed: () async {
                                          User? user =
                                              await signupUsingEmailPassword(
                                                  email: emailController.text,
                                                  password:
                                                      passwordController.text,
                                                  displayName:
                                                      usernameController.text,
                                                  context: context);
                                          if (user != null) {
                                            // await user.updateDisplayName(
                                            //     usernameController.text);
                                            Provider.of<bb_user.User>(context,
                                                    listen: false)
                                                .setId(user.uid);
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const MainScreen()));
                                          }
                                        },
                                      )))
                            ]))))));
  }
}
