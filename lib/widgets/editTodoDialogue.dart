import 'package:flutter/material.dart';
import 'package:todo_provider/model/user_and_todo_model.dart';
import 'package:todo_provider/sqflite/todo_and_user_service.dart';

class EditTodoDialogue extends StatefulWidget {
  String username;
  String? title;
  String? desc;
  String? id;
  bool? isDone;
  EditTodoDialogue(
      {required this.title,
      required this.username,
      required this.desc,
      required this.id,
      required this.isDone});

  @override
  State<EditTodoDialogue> createState() => _EditTodoDialogueState();
}

class _EditTodoDialogueState extends State<EditTodoDialogue> {
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
    titleController.text = widget.title.toString();
    detailsController.text = widget.desc.toString();
    return AlertDialog(
      scrollable: true,
      title: Text('Edit Todo'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
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
                      // Provider.of<TodosProvider>(context, listen: false)
                      //     .modifyTodo(titleController.text,
                      //         detailsController.text, widget.id.toString());
                      Todo updatedTodo = Todo(
                          username: widget.username,
                          title: titleController.text,
                          description: detailsController.text,
                          id: widget.id.toString());
                      TodoServiceHelper().updateTodo(updatedTodo);
                      Navigator.of(context).pop();
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
