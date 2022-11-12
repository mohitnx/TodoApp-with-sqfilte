import 'package:flutter/material.dart';
import 'package:todo_provider/model/user_and_todo_model.dart';
import 'package:todo_provider/pages/login.dart';
import 'package:todo_provider/sqflite/todo_and_user_service.dart';
import 'package:todo_provider/widgets/show_snackbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 3,
            colors: [Colors.purple, Colors.cyan, Colors.green],
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
              'Register Screen',
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
                children: [
                  Padding(
                    padding: const EdgeInsets.all(22.0),
                    child: TextFormField(
                      validator: (title) =>
                          title!.isEmpty ? 'Username cannot be null' : null,
                      controller: usernameController,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                            borderSide:
                                BorderSide(color: Colors.orange, width: 4)),
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
                            color: Color.fromARGB(152, 255, 255, 255)),
                      ),
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'Register',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(255, 0, 70, 127),
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final FormState? form = formKey.currentState;
                      if (form!.validate()) {
                        //trim takes away the extra space at the end and beginning of the text
                        User newUser =
                            User(username: usernameController.text.trim());
//checkIfUserExists gives true if user with that name exists..so while regietring if it retuns true then
//the user with the name we are tryiing to register alraedy exists so we should login instead of registering

//..
//bool check ma if there was no await then we would get instance of future instead of acutual value
//by using await we first get hte instance of future and await helps to await till that future is replaced by the atual value
                        bool check = await TodoServiceHelper()
                            .checkIfUserExists(newUser.username);
                        if (!check) {
                          await TodoServiceHelper().createUser(newUser);
                          showSnackBar(
                              context, 'Your account was successfully created');

                          Navigator.pop(context);
                        } else {
                          showSnackBar(
                              context, 'A user with that name already exists');
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
                Text('Already Have an Account?',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Login()));
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'here',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
