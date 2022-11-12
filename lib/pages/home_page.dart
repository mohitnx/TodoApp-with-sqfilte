import 'package:flutter/material.dart';

import 'package:todo_provider/pages/login.dart';
import 'package:todo_provider/sqflite/todo_and_user_service.dart';
import 'package:todo_provider/widgets/add_todo_dialogue.dart';

import 'package:todo_provider/widgets/todo_list.dart';

import '../model/user_and_todo_model.dart';
import '../widgets/searching_Items.dart';

class HomePage extends StatefulWidget {
  String? username;
  HomePage({required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController termController = TextEditingController();
  void clearText() {
    termController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: () {
              User loginUser =
                  User(username: widget.username.toString(), isLoggedIn: false);
              TodoServiceHelper().updateUserName(loginUser);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Login()));
            },
            icon: Icon(Icons.logout),
            color: Colors.white,
          )
        ],
        title: FutureBuilder(
            future: TodoServiceHelper().getTheUser(widget.username ?? ''),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Text(
                'Welcome ${snapshot.data!.username}',
                style: TextStyle(color: Colors.white),
              );
            }),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: termController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(),
                          labelText: 'search todos',
                        ),
                      ),
                      TextButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowingSerachedTitle(
                                        userNamee: widget.username ?? '',
                                        searchTerm: termController.text,
                                      )),
                            );

                            print(termController.text);
                            clearText();
                            setState(() {});
                          },
                          child: Text(
                            'Search',
                          )),
                      Divider(
                        thickness: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Stack(children: [
              Positioned(
                bottom: 0,
                child: Text(
                  ' done Todos',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              IconButton(
                //for why we need async await https://docs.flutter.dev/cookbook/navigation/returning-data
                //basically navigator.push is a future method that pushes a screen (here checkingStuff)
                //and waits a result from navigator.pop in checkingstuff
                //i.e when we press back from Checking Stuff, navigator awaits and gets the results
                //and with setSTate we can show those results on the screen as it rebuilds the widget with those changes
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CheckingStuff(userNamee: widget.username ?? '')),
                  );
                  setState(() {});
                },
                icon: Icon(Icons.filter),
              ),
            ]),
          ),
          Divider(
            thickness: 3,
          ),
          Container(
            child: TodoListWidget(name: widget.username ?? ''),
            height: 1000,
            width: 380,
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 255, 132, 0),
        //without async await and setState...we have to refresh the app to see the changes
        //show dialogue is a future so async await...and setState to rebuild this widget..so that after
        //rebuild we can see the added todo
        onPressed: () async {
          await showDialog(
            barrierDismissible: false,
            context: context,
            builder: ((context) {
              return AddNewTodoDialogue(name: widget.username ?? '');
            }),
          );
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class CheckingStuff extends StatefulWidget {
  String userNamee;
  CheckingStuff({required this.userNamee});

  @override
  State<CheckingStuff> createState() => _CheckingStuffState();
}

class _CheckingStuffState extends State<CheckingStuff> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Todo>>(
        future: TodoServiceHelper().filteredList(widget.userNamee),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(children: [
              SizedBox(
                height: 100,
              ),
              Text(
                'There are/isr ${snapshot.data!.length} with that search term',
                style: TextStyle(fontSize: 50),
              ),
              SizedBox(
                height: 100,
              ),
              Flexible(
                child: Container(
                  height: 1000,
                  color: Color.fromARGB(255, 125, 125, 125),
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(
                      thickness: 3,
                      color: Colors.orange,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: 7, top: 19, right: 7, bottom: 7),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          dense: false,
                          visualDensity:
                              VisualDensity(vertical: -3, horizontal: -3),
                          contentPadding: EdgeInsets.only(
                              left: 32, right: 32, top: 8, bottom: 8),
                          title: Text(
                            snapshot.data![index].title.toString(),
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Color.fromARGB(141, 0, 0, 0),
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            snapshot.data![index].description.toString(),
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Color.fromARGB(39, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                              alignment: Alignment.center,
                              icon: Icon(
                                Icons.delete,
                                size: 30,
                                color: Color.fromARGB(121, 77, 77, 77),
                              ),
                              onPressed: () {
                                setState(() {
                                  TodoServiceHelper().deleteTodo(
                                      snapshot.data![index].id.toString());
                                });
                              }),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ]);
          } else if (snapshot.hasError) {
            return Text("Oops!");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
