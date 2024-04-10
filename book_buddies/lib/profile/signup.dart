import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import 'login.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  static Future<User?> signupUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
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
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(16.0),
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
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: "Email", prefixIcon: Icon(Icons.mail)),
                  ),
                  const SizedBox(height: 26),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        hintText: "Password", prefixIcon: Icon(Icons.lock)),
                  ),
                  const SizedBox(height: 26),
                  Center(
                      child: InkWell(
                          child: const Text(
                              "Back to login",
                              style: TextStyle(color: Colors.deepPurple)),
                          onTap: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginScreen())))),
                  const SizedBox(height: 88),
                  Center(
                      child: SizedBox(
                          width: 120,
                          child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 25)),
                              child: const Text("Sign Up",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20)),
                              onPressed: () async {
                                User? user = await signupUsingEmailPassword(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    context: context);
                                if (user != null) {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => const MainScreen()));
                                }
                              },)))
                ])));
  }
}
