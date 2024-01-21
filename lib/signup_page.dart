import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_page.dart';
import 'chat_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _loading = false;

  Future<Map<String, dynamic>> fetchUserData() async {
    final String apiUrl = 'https://doppelme-avatars.p.rapidapi.com/assets/1101/eye';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': 'c25f076e58msh09208d2ca1d495ap1d5bf5jsna2ca651105cc',
      'X-RapidAPI-Host': 'doppelme-avatars.p.rapidapi.com',
    };

    final http.Response response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> userData = json.decode(response.body);
      return userData;
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> _signUp(BuildContext context) async {
    try {
      setState(() {
        _loading = true;
      });

      // Fetch user data (username and avatar)
      Map<String, dynamic> userData = await fetchUserData();

      // Perform signup
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Save additional user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userCredential.user?.uid).set({
        'avatar': userData['avatar'],
        'username': userData['username'],
        'email': emailController.text,
      });

      // Navigate to the chat page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatPage(user: userCredential.user!, assignedUsername: userData['username']),
        ),
      );
    } catch (e) {
      print('Failed to register user: $e');
      // Handle registration failure, show error message, etc.
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
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email:'),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Enter your email',
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
              onPressed: _loading ? null : () => _signUp(context),
              child: _loading ? CircularProgressIndicator() : Text('Sign Up'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: Text('Already have an account? Log In'),
            ),
          ],
        ),
      ),
    );
  }
}
