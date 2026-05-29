import 'package:flutter/material.dart';
import 'package:flutter_todo_app/components/button.dart';
import 'package:flutter_todo_app/components/colors.dart';
import 'package:flutter_todo_app/controller/auth_controller.dart';
import 'package:flutter_todo_app/db/users.dart';
import 'package:flutter_todo_app/helper/user_helper.dart';
import 'package:flutter_todo_app/views/profile.dart';
import 'package:flutter_todo_app/views/signup.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Our controllers
  //Controller is used to take the value from user and pass it to database
  final usrName = TextEditingController();
  final password = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isChecked = false;
  bool isLoginTrue = false;

  final db = DatabaseHelper();
  //Login Method
  //We will take the value of text fields using controllers in order to verify whether details are correct or not
  login() async {
    Users? usrDetails = await db.getUser(usrName.text);
    var res = await db
        .authenticate(Users(usrName: usrName.text, password: password.text));
    if (res == true) {
      //If result is correct then go to profile or home
      if (!mounted) return;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Profile(profile: usrDetails)));
    } else {
      //Otherwise show the error message
      setState(() {
        isLoginTrue = true;
      });
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
                  const Text(
                    "LOGIN",
                    style: TextStyle(color: primaryColor, fontSize: 40),
                  ),
                  Image.asset("assets/background.jpg"),
                  TextFormField(
                    decoration: const InputDecoration(
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

                  //Our login button
                  Button(
                    label: "LOGIN",
                    press: () {
                      if (formKey.currentState!.validate()) {
                        login();
                      }
                    },
                  ),

                  //Because we don't have account, we must create one to authenticate
                  //lets go to sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignupScreen()));
                          },
                          child: const Text("SIGN UP"))
                    ],
                  ),

                  // Access denied message in case when your username and password is incorrect
                  //By default we must hide it
                  //When login is not true then display the message
                  isLoginTrue
                      ? Text(
                          "Username or password is incorrect",
                          style: TextStyle(color: Colors.red.shade900),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
