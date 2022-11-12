import 'package:flutter/material.dart';
import 'package:todo_provider/model/user_and_todo_model.dart';
import 'package:todo_provider/sqflite/todo_and_user_service.dart';
import 'package:todo_provider/widgets/editTodoDialogue.dart';

class TodoListWidget extends StatefulWidget {
  String name;
  TodoListWidget({required this.name});

  @override
  State<TodoListWidget> createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  int? vv;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Todo>>(
          future: TodoServiceHelper().getTodos(widget.name),
          builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text("Oops!");
            }
//if else kina yei tarika le enter garna paryo?
            return snapshot.data!.isEmpty
                ? Text(
                    'Time to enter some Todos!!',
                    style: TextStyle(fontSize: 40),
                  )
                : Column(
                    children: [
                      Flexible(
                        child: Text(
                          "The total number of Todos is ${snapshot.data!.length}",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Flexible(
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
                                        username: widget.name,
                                        title: snapshot.data![index].title
                                            .toString(),
                                        desc: snapshot.data![index].description
                                            .toString(),
                                        id: snapshot.data![index].id.toString(),
                                        isDone: snapshot.data![index].isDone,
                                      );
                                    }),
                                  );
                                  setState(() {});
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
                                leading: IconButton(
                                    color: Colors.blue,
                                    icon: Icon(
                                      !snapshot.data![index].isDone
                                          ? Icons.check_box_outline_blank
                                          : Icons.check_box,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        //if the task is done and  the icon is pressed then update the Todo with isDone false
                                        if (snapshot.data![index].isDone) {
                                          Todo update = Todo(
                                            username: widget.name,
                                            title: snapshot.data![index].title
                                                .toString(),
                                            description: snapshot
                                                .data![index].description
                                                .toString(),
                                            id: snapshot.data![index].id
                                                .toString(),
                                            isDone: false,
                                          );
                                          TodoServiceHelper()
                                              .updateTodo(update);
                                        } else
                                        //if the task is not done and the icon is pressed then update the Todo with isDone true
                                        {
                                          Todo update = Todo(
                                            username: widget.name,
                                            title: snapshot.data![index].title
                                                .toString(),
                                            description: snapshot
                                                .data![index].description
                                                .toString(),
                                            id: snapshot.data![index].id
                                                .toString(),
                                            isDone: true,
                                          );
                                          TodoServiceHelper()
                                              .updateTodo(update);
                                        }
                                      });
                                    }),
                                trailing: IconButton(
                                    alignment: Alignment.center,
                                    icon: Icon(
                                      Icons.delete,
                                      size: 30,
                                      color: Color.fromARGB(198, 209, 40, 40),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        TodoServiceHelper().deleteTodo(snapshot
                                            .data![index].id
                                            .toString());
                                      });
                                    }),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
          }),
    );
  }
}
