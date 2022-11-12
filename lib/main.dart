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




//.fromMap is used to read data from db and display them on app
//.toMap is used to store data from app to db as db ma data can be only stored as maps
//.toString is optional as it is used for testing by printing itmes of db on console..without it , the console would only show instance of db instead of actually showing the value