import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:incog/signup_page.dart';
import 'chat_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController usernameOrEmailController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _loading = false;

  Future<void> _login(BuildContext context) async {
    try {
      setState(() {
        _loading = true;
      });

      final String input = usernameOrEmailController.text.trim();
      UserCredential userCredential;

      if (input.contains('@')) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: input,
          password: passwordController.text,
        );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(user: userCredential.user!, assignedUsername: '',),
        ),
      );
      } else {
        // Handle username login if applicable
      }
      
    } catch (e) {
      print('Failed to log in: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username or Email:'),
            TextField(
              controller: usernameOrEmailController,
              decoration: InputDecoration(
                hintText: 'Enter your username or email',
              ),
            ),
            SizedBox(height: 16.0),
            Text('Password:'),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter your password',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _loading ? null : () => _login(context),
              child: _loading ? CircularProgressIndicator() : Text('Log In'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupPage(),
                  ),
                );
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
