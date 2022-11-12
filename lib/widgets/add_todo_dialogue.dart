import 'package:flutter/material.dart';
import 'package:todo_provider/model/user_and_todo_model.dart';
import 'package:todo_provider/sqflite/todo_and_user_service.dart';

class AddNewTodoDialogue extends StatefulWidget {
  String name;
  AddNewTodoDialogue({required this.name});

  @override
  State<AddNewTodoDialogue> createState() => _AddNewTodoDialogueState();
}

class _AddNewTodoDialogueState extends State<AddNewTodoDialogue> {
  final GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  @override
  void dispose() {
    titleController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text('Add New Todo'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                validator: (title) =>
                    title!.isEmpty ? 'Title cannot be null' : null,
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextFormField(
                controller: detailsController,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Details',
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style:
                          TextStyle(color: Color.fromARGB(165, 150, 141, 126)),
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      final FormState? form = formKey.currentState;
                      if (form!.validate()) {
                        // Provider.of<TodosProvider>(context, listen: false)
                        //     .addTodo(
                        //   titleController.text,
                        //   detailsController.text,
                        // );
                        setState(() {
                          Todo? newItmem = Todo(
                              username: widget.name,
                              title: titleController.text,
                              isDone: false,
                              description: detailsController.text,
                              id: DateTime.now().toString());

                          TodoServiceHelper().insertTodo(newItmem);
                          print(newItmem.toString());
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    child: Text('OK'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
