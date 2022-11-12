import 'package:flutter/material.dart';
import 'package:todo_provider/model/user_and_todo_model.dart';
import 'package:todo_provider/pages/home_page.dart';
import 'package:todo_provider/pages/register.dart';
import 'package:todo_provider/sqflite/todo_and_user_service.dart';

import '../widgets/show_snackbar.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //formState is used to set, reset and validate a form
  final GlobalKey<FormState>? formKey = GlobalKey();
  TextEditingController usernameController = TextEditingController();
  @override
  void dispose() {
    usernameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 2,
            colors: [Colors.red, Colors.orange, Colors.pink],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Todo With Sqflite and Provider',
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Login Screen',
              style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 100,
            ),
            Text(
              'Welcome',
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 80,
            ),
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: usernameController,
                      validator: (user) =>
                          user!.isEmpty ? 'Username cannot be null' : null,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 4)),
                        focusColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide:
                                BorderSide(color: Colors.white, width: 4)),
                        hintText: 'xyz',
                        labelText: 'Username',
                        labelStyle: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255)),
                        hintStyle: TextStyle(
                            color: Color.fromARGB(121, 255, 255, 255)),
                      ),
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 80, 146),
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      //formKey is a gGlobal key of ForamState type..we can get current state, currrent widget,etc from it
                      //we get the current state of the form and store it in var form
                      //then check if the current state meets the validator's requiremet
                      final FormState? form = formKey!.currentState;
                      if (form!.validate() == true) {
                        bool check = await TodoServiceHelper()
                            .checkIfUserExists(usernameController.text.trim());

                        if (check) {
                          //if user exists then we update the user to have isLogged in to true..it is false by default
                          //then we take the user to the home screen
                          User loginUser = User(
                              username: usernameController.text,
                              isLoggedIn: true);
                          TodoServiceHelper().updateUserName(loginUser);
                          showSnackBar(
                              context, 'Welcome ${usernameController.text}');
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => HomePage(
                                        username: usernameController.text,
                                      )));
                        } else {
                          showSnackBar(context,
                              'No user exists with that username. Maybe register a new one?');
                        }
                        print(usernameController.text);
                      }
                    },
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not Registered Yet?',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => RegisterPage()));
                  },
                  child: Text(
                    'Register',
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  'here',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
