import 'package:flutter/material.dart';
import 'package:flutter_todo_app/components/button.dart';
import 'package:flutter_todo_app/components/colors.dart';
import 'package:flutter_todo_app/controller/auth_controller.dart';
import 'package:flutter_todo_app/db/users.dart';
import 'package:flutter_todo_app/helper/user_helper.dart';
import 'package:flutter_todo_app/views/login.dart';
import 'package:get/get.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //Controllers
  final fullName = TextEditingController();
  final email = TextEditingController();
  final usrName = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final db = DatabaseHelper();

  final formKey = GlobalKey<FormState>();

  signUp() async {
    var res = await db.createUser(Users(
        fullName: fullName.text,
        email: email.text,
        usrName: usrName.text,
        password: password.text));
    if (res > 0) {
      if (!mounted) return;
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Register New Account",
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 55,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      fillColor: backgroundColor,
                      prefixIcon: Icon(Icons.person_outlined),
                      hintText: 'FullName',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    controller: fullName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter FullName';
                      } else if (value.length < 5) {
                        return 'at least enter 5 characters';
                      } else if (value.length > 13) {
                        return 'maximum character is 13';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      fillColor: backgroundColor,
                      prefixIcon: Icon(Icons.email_outlined),
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    controller: email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter gmail';
                      } else if (!value.endsWith('@gmail.com')) {
                        return 'please enter valid gmail';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      fillColor: backgroundColor,
                      prefixIcon: Icon(Icons.account_circle_outlined),
                      hintText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                    ),
                    controller: usrName,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter username';
                      } else if (value.length < 5) {
                        return 'at least enter 5 characters';
                      } else if (value.length > 13) {
                        return 'maximum character is 13';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Obx(
                    () => TextFormField(
                      controller: password,
                      obscureText: authController.isObscure.value,
                      decoration: InputDecoration(
                        fillColor: backgroundColor,
                        prefixIcon: const Icon(Icons.lock_open),
                        suffixIcon: IconButton(
                          icon: Icon(
                            authController.isObscure.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            authController.isObscureActive();
                          },
                        ),
                        hintText: 'Password',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        } else if (value.length < 7) {
                          return 'at least enter 6 characters';
                        } else if (value.length > 13) {
                          return 'maximum character is 13';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Button(
                    label: "SIGN UP",
                    press: () {
                      if (formKey.currentState!.validate()) {
                        signUp();
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Text("LOGIN"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
