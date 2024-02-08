import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todos/widget/add.dart';
import 'package:todos/widget/detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// Beacause the usage of Shared preference
  List<dynamic> _todos = [

  ];

  // Inialization of the page is done here
  // When the page is loaded

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    // Obtain shared preferences. / open file manager
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var todosString  = prefs.getString("todos");
    if (todosString != null){
      setState(() {
        // transform from String to List of Map<String,dynamic>
        // setState => refresh the UI
        _todos = jsonDecode(todosString) ;
      });
    }
  }

  void saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // SHared preference can only store basic data type
    // String, int, double, boolean , List<String>
    // If i am storing other data type, I can transform to String
    // Map, Array of Map can be transformed Using jsonEncode ('dart:convert')
    // Saving inside shared preference item _todos
    // using filename/key "todos"
    prefs.setString("todos", jsonEncode(_todos));

    setState(() {
      _todos; // _todos = _todos;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("To do app"),),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          // how many rows are there -> It has the same number of rows as the data
          itemCount: _todos.length,

          // What to show on each row ->
          // For every row (represented by index)
          // Show a container (box/div) of colour amber, of height 50
          // in which has a centered text labeled with the todos of each row
          // if row/index 0 => todos[0] row/index 1 =>todos[1]
          itemBuilder: (BuildContext context, int index) {
            // return Container(
            //   height: 50,
            //   color: Colors.amber,
            //   child: Center(child: Text('Entry: ${_todos[index]["name"]}')),
            // );
            return Card(
              child: ListTile(
                leading: _todos[index]["completed"] == true ? const Icon(Icons.check) : const SizedBox(),
                title: Text(_todos[index]["name"]!),
                subtitle: Text(_todos[index]["place"]!),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  // 3) Pass the data to second page through the constructor
                  var respond = await Navigator.push(context,MaterialPageRoute(builder:
                      (context)=>DetailPage(item: _todos[index], index: index,)));
                  if (respond != null){
                    if (respond["action"] == 1){
                      //delete
                      _todos.removeAt(respond["index"]);
                      saveData();
                      setState(() {
                        _todos;
                      });
                    }
                    else {
                      //edit
                      // reverse the value of completed
                      _todos[respond["index"]]["completed"] =   !_todos[respond["index"]]["completed"] ;
                      saveData();
                      setState(() {
                        _todos;
                      });

                    }
                  }
                },
              ),
            );
          }
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // Open add page
          // WAIT FOR THE SECOND PAGE TO END
          // RETRIEVE THE ITEM PASSED FROM THE SECOND PAGE
          // in dart, whenever there is the word await (a way of process asynchronous programming)
          // add async to the nearest function {}
          var newItem =  await Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPage()));

          if (newItem != null) {
            // 3rd) Process the item and refresh the UI
            _todos.add(newItem);

            ///SAVE!!!
            ///// Obtain shared preferences./ file manager
            saveData();
          }
        },
      ),
    );
  }
}