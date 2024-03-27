import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Login Failed"),
              content: const Text("Incorrect password or user does not exist"),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {Navigator.pop(context);},
                ),
              ],
            );
          },
        );
      } else if (e.code == "invalid-email") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Login Failed"),
              content: const Text("Invalid Email"),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {Navigator.pop(context);},
                ),
              ],
            );
          },
        );
      } else if (e.code == "channel-error") {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Login Failed"),
              content: const Text("Please enter both an email and password"),
              actions: [
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {Navigator.pop(context);},
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
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    return Scaffold(
        body: SafeArea(child: SingleChildScrollView(child: Padding(
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
                  const Text("Login",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 38,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 44),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: "Email", prefixIcon: Icon(Icons.mail)),
                  ),
                  const SizedBox(height: 26),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: "Password", prefixIcon: Icon(Icons.lock)),
                  ),
                  const SizedBox(height: 26),
                  Center(
                      child: InkWell(
                          child: const Text(
                              "Don't have an account? Sign up here.",
                              style: TextStyle(color: Colors.deepPurple)),
                          onTap: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const SignupScreen())))),
                  const SizedBox(height: 88),
                  Center(
                      child: Container(
                          width: 120,
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 25)),
                              child: const Text("Login",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20)),
                              onPressed: () async {
                                User? user = await loginUsingEmailPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    context: context);
                                if (user != null) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => MainScreen()));
                                }
                              },)))
                ]))))));
  }
}
