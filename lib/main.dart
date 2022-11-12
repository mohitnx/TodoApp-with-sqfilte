import 'package:flutter/material.dart';
import 'package:todo_provider/pages/home_page.dart';
import 'package:todo_provider/pages/login.dart';
import 'package:todo_provider/sqflite/todo_and_user_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.orange,
          scaffoldBackgroundColor: Color.fromARGB(216, 255, 255, 255),
        ),
        home: Testing());
  }
}

class Testing extends StatefulWidget {
  const Testing({super.key});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TodoServiceHelper().checkifLoggedIn(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasError) {
          print(snapshot.hasError);
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.data!.isNotEmpty) {
          print(snapshot.data);
          print(snapshot.data![0].username.toString());
          return HomePage(
            username: snapshot.data![0].username.toString(),
          );

          // returning HomePage gives null check operator used on null value error
        } else
          return Login();
      }),
    );
  }
}




