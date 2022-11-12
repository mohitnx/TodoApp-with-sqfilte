class Todo {
  String? username;
  String? title;
  String? description;
  String? id;
  bool isDone;

  Todo({
    this.username,
    this.title,
    this.description,
    this.id,
    this.isDone = false,
  });

//table ma store garna we need to convert the object to a map
//table ma insert garda we insert in the form of map so when toMap is called we provide a Todo object to it and .toMap()
//eg Todo todo....insert (todo.toMap() )...insert le table ma todo.toMap()lai rakhcha see todo_service.dart

//todo.toMap garechi todo object ko username is storead in 'username' title in 'title' and so on
//it converts the class object to a map
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'title': title,
      'description': description,
      'id': id,
      'isDone': isDone ? 1 : 0,
    };
  }

//to read from the table we need to convert the map to an object..can be done in 2 ways
////1: by a method
  // Todo fromMap(Map<String, dynamic> json) {
  //   return Todo(
  //     id: json['id'].toString(),
  //     title: json['title'].toString(),
  //     description: json['description'].toString(),
  //   );
  // }
  //2: by a named constructor
  //frmMap uses garda uta ko List of Map i.e item['title'], item['descriptio'],item['id] are put into an object of Todo
  //so we create a list of Todos from a list of Map
  //(Map<String, dynamic> item) means Map where the LHS is strng, RHS is dynamic and each element is refered as item
  Todo.fromMap(Map<String, dynamic> item)
      : title = item['title'],
        username = item['username'],
        description = item['description'],
        id = item['id'],
        isDone = item['isDone'] == 0 ? false : true;

  ///futurebuilder ma print snapshot.data garda we only get 'instance of todo' without this override
  ///this override converts
  @override
  String toString() {
    return toMap().toString();
  }
//NOTE NOTE here we didn't seach using == operator so no need to override it...incase we had to override
//this is the way::

//
//
//
//
//
//overriding == operator so that we can compare two instances of Todo class
//so to be true both username and the title must be same...so if it is same it is the same user
//other wise it can be a different user
//   @override
//   bool operator ==(covariant Todo todo) {
//     return (this.username == todo.username) &&
//         //if this.tile == todo.title then return 0 i.e true
//         (this.title!.toUpperCase().compareTo(todo.title!.toUpperCase()) == 0);
//   }

// //to override == it is also recommended to override hashCode
//   @override
//   int get hashCode {
//     return Object.hash(username, title);
//   }
}

class User {
  bool isLoggedIn;
  String username;
  User({required this.username, this.isLoggedIn = false});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'isLoggedIn': isLoggedIn ? 1 : 0,
    };
  }

  User.fromMap(Map<String, dynamic> item)
      : username = item['username'],
        isLoggedIn = item['isLoggedIn'] == 0 ? false : true;
  @override
  String toString() {
    return toMap().toString();
  }
}
