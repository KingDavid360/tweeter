import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:twitter_app/components/controller/authentication.dart';
import 'package:twitter_app/components/controller/singup_controller.dart';
import 'package:twitter_app/components/controller/user.dart';
import 'package:twitter_app/screens/signin_screen/signin.dart';

import '../models/user_model/user.dart';

class SignUpWidget extends StatelessWidget {
  const SignUpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Authentication());
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var usernameController = TextEditingController();
    var displayNameController = TextEditingController();
    var phoneNoController = TextEditingController();
    final userController = Get.put(User());
    final _formKey = GlobalKey<FormState>();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  label: Text('Email address'), prefixIcon: Icon(Icons.email)),
            ),
            const SizedBox(height: 20),
            TextFormField(
              // keyboardType: TextInputType.visiblePassword,
              controller: passwordController,
              decoration: const InputDecoration(
                  label: Text('Password'), prefixIcon: Icon(Icons.lock)),
            ),
            const SizedBox(height: 20),
            TextFormField(
              // keyboardType: TextInputType.text,
              controller: usernameController,
              decoration: const InputDecoration(
                  label: Text('Username'), prefixIcon: Icon(Icons.person)),
            ),
            const SizedBox(height: 20),
            TextFormField(
              // keyboardType: TextInputType.name,
              controller: displayNameController,
              decoration: const InputDecoration(
                label: Text('Display name'),
                prefixIcon: Icon(
                  Icons.assignment_ind_outlined,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              // keyboardType: TextInputType.phone,
              controller: phoneNoController,
              decoration: const InputDecoration(
                  label: Text('Phone number'), prefixIcon: Icon(Icons.phone)),
            ),
            const SizedBox(height: 10),
            ListTile(
              trailing: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                },
                child: const Text(
                  'Already have an account?',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w700,
                      fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    controller.signupUser(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        usernameController.text.trim(),
                        phoneNoController.text.trim(),
                        displayNameController.text.trim());
                  }
                },
                child: const Text('SIGN UP'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
