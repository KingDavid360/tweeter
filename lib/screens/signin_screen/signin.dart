import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../components/controller/authentication.dart';
import '../../components/controller/singup_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Authentication());
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    final _key = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: ListView(
            children: [
              const Center(
                child: Text(
                  'Sign in',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 28),
                ),
              ),
              Form(
                key: _key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      // keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                          label: Text('Email address'),
                          prefixIcon: Icon(Icons.email)),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      // keyboardType: TextInputType.visiblePassword,
                      controller: passwordController,
                      decoration: const InputDecoration(
                          label: Text('Password'),
                          prefixIcon: Icon(Icons.lock)),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            controller.loginWithEmailAndPassword(
                                emailController.text.trim(),
                                passwordController.text.trim());
                          }
                        },
                        child: const Text('SIGN IN'),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
