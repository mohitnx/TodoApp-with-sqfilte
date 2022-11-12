import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/user_and_todo_model.dart';

class TodoServiceHelper {
  //initializeing and opening database
  initializeDB() async {
    final Database database = await openDatabase(
      //getDAtabasePath() gets the default databaselocation
      join(await getDatabasesPath(), 'todo_database.db'),
      //yo line( join(await getDatabasesPath(), 'todo_database.db'),) ko code le  full path dinche ani tyo path lera yo bhanda thyakka mathi ko line le database kholcha
      //onCreate describes the schema of the database...table "todos" with columns id, title and descrpiotn is created when the databse todo_database is created

      //onCreate is called if the databse (todo_database.db) didn't exist prior to callingopendDAtabase...once the database exists...it is not called
      //as we can see in other methods like cerateUser, getTheUser, etc...at first when we run [ final Database db = await initializeDB();] onCreate runs...we creaet two tables
      //and return databse...after that whenever  final Database db = await initializeDB(); runs...we just return the databse as it has already been cerated
      onCreate: ((db, version) async {
        await db.execute(
            'CREATE TABLE users(username TEXT PRIMARY KEY, isLoggedIn BOOLEAN)');
        await db.execute(
            'CREATE TABLE todos(id TEXT PRIMARY KEY, username TEXT, title TEXT, description TEXT, isDone BOOLEAN)');
        //to use foreign key we need this
      }),
      version: 10,
    );
    return database;
  }

////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
//////////////////////USER/////////////////////////////////
//////////////////////////////////
  Future<int> createUser(User user) async {
    final Database db = await initializeDB();
    int a = await db.insert(
      'users',
      user.toMap(),
    );
    return a;
  }

  ////////////////////////////////////////////

  //////////////////////////////////////////
//username = databsee ko column , givenUserNmae = hamle supply garya name
  Future<User> getTheUser(String givenUserName) async {
    final Database db = await initializeDB();

    final result = await db
        .query('users', where: 'username = ?', whereArgs: [givenUserName]);

    if (result.length > 0)
      return User.fromMap(result.first);
    else
      throw Exception('$givenUserName not found. Maybe register a new user?');
  }

/////////////////////////////////////////////////////////////////////////////////////
  Future<bool> checkIfUserExists(String givenUserName) async {
    final Database db = await initializeDB();
    bool? check;
    final result = await db
        .query('users', where: 'username = ?', whereArgs: [givenUserName]);

    if (result.length > 0)
      check = true;
    else
      check = false;
    return check;
  }

  ////////////////////////////////////////////////
  ///VVI NOTE ///VVI NOTE// .update function if we hover on it..we can see it returns a future of int
/////which shows how many times the update function was perfored..so if we needded to know
  ///how many times the update function was done..instead of void we could make Futuer<int> and return int
////instead of void
  Future<void> updateUserName(User user) async {
    final Database db = await initializeDB();
    try {
      db.update(
        'users',
        user.toMap(),
        where: 'username = ?',
        whereArgs: [user.username],
      );
    } catch (error) {
      print('$error');
    }
  }

  ///////////////////////////////////////////////
  Future<void> deleteuser(User user) async {
    final Database db = await initializeDB();
    try {
      db.delete(
        'users',
        whereArgs: [user.username],
      );
    } catch (error) {
      print('$error');
    }
  }

  Future<List<User>> checkifLoggedIn() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> result = await db.query(
      'users',
      where: 'isLoggedIn = ?',
      whereArgs: ['1'],
    );
    List<User> filtered = [];
    for (var item in result) {
      filtered.add(User.fromMap(item));
    }
    return filtered;
  }
  ///////////////////////////////////////////////////
  /////////////////////////////////////////////////////
  ///////////////////TODO//////////////////////////
  ////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////
  Future<int> insertTodo(Todo todo) async {
    // final Database db = await database;
    final Database db = await initializeDB();

    //insert takes 2 arguments sting table name (todos) and map of values (todo.map())
    int a = await db.insert('todos', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return a;
  }

///////////////////////////////////////////////////////////////////
/////queryResult returns a list of map, so wwe use the map() method to change the list of map to a list of todos
  Future<List<Todo>> getTodos(String username) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResult = await db.query(
      'todos',
      where: 'username = ? ',
      whereArgs: [username],
    );

    return queryResult.map((e) => Todo.fromMap(e)).toList();
  }

////////////////////////////////////////////////////////////////////////////
  Future<List<Todo>> filteredList(String usernamee) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> result = await db.query(
      'todos',
      where: 'username = ? AND isDone = ?',
      whereArgs: [usernamee, '1'],
    );
    List<Todo> filtered = [];
    for (var item in result) {
      filtered.add(Todo.fromMap(item));
    }

    return filtered;
  }

  ///////////////////////////////////////////////////////////////////////
  /////
//search title and descprioton column and return if a todo is present based on provided substring..so the
//term can be in middle of the string,. beginning..anywhere
  Future<List<Todo>> searchTerm(String term, String username) async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> result = await db.query(
      'todos',
      where: 'title || description LIKE ? AND username =?',
      whereArgs: ['%$term%', username],
    );
    List<Todo> filtered = [];
    for (var item in result) {
      filtered.add(Todo.fromMap(item));
    }

    return filtered;
  }

  ///////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////
  Future<void> updateTodo(Todo todo) async {
    final Database db = await initializeDB();
    try {
      await db
          .update('todos', todo.toMap(), where: 'id= ?', whereArgs: [todo.id]);
    } catch (e) {
      print('$e');
    }
  }

/////////////////////////////////////////////////////////////////////////
  Future<void> deleteTodo(String? idd) async {
    final Database db = await initializeDB();

    try {
      await db.delete(
        'todos',
        where: 'id = ?',
        whereArgs: [idd],
      );
    } catch (e) {
      print('$e');
    }
  }
}
