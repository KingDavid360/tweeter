import 'package:flutter/material.dart';
import 'package:twitter_app/components/signup_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: ListView(
            children: [
              Text(
                'Create your account',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 28),
              ),
              SignUpWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
