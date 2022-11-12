import 'package:flutter/material.dart';

import '../model/user_and_todo_model.dart';
import '../sqflite/todo_and_user_service.dart';
import 'editTodoDialogue.dart';

class ShowingSerachedTitle extends StatefulWidget {
  String userNamee;
  String searchTerm;
  ShowingSerachedTitle({required this.userNamee, required this.searchTerm});

  @override
  State<ShowingSerachedTitle> createState() => _ShowingSerachedTitleState();
}

class _ShowingSerachedTitleState extends State<ShowingSerachedTitle> {
  @override
  Widget build(BuildContext context) {
    print('testing');
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Todo>>(
        future:
            TodoServiceHelper().searchTerm(widget.searchTerm, widget.userNamee),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(children: [
              SizedBox(
                height: 100,
              ),
              Text(
                'There are/is ${snapshot.data!.length} items with that search term',
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
                        onTap: () async {
                          await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: ((context) {
                              return EditTodoDialogue(
                                username: widget.userNamee,
                                title: snapshot.data![index].title.toString(),
                                desc: snapshot.data![index].description
                                    .toString(),
                                id: snapshot.data![index].id.toString(),
                                isDone: snapshot.data![index].isDone,
                              );
                            }),
                          );
                          setState(() {});
                          print('trying to update');
                        },
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
                              color: Colors.black87,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          snapshot.data![index].description.toString(),
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                            alignment: Alignment.center,
                            icon: Icon(
                              Icons.delete,
                              size: 30,
                              color: Color.fromARGB(198, 209, 40, 40),
                            ),
                            onPressed: () {
                              setState(() {
                                TodoServiceHelper().deleteTodo(
                                    snapshot.data![index].id.toString());
                                print('trying to delete');
                              });
                            }),
                      ),
                    );
                  },
                ),
              ))
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
