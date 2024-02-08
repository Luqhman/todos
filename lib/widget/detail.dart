import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  // 1) Step 1 : Variable to store data from sender
  Map<String,dynamic> item;
  int index;

  // 2) Create constructor with item is inside parameter
  DetailPage({required this.item, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Page"),),
      body: Center(
        child: Column(
          children: [
            Text(item["name"]!),
            Text(item["description"]!),
            Text(item["place"]!),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){
                  print("To do delete for $index");
                  // 1 means delete,
                  // 2 means edit
                  var respond = {
                    "index":index,
                    "action":1
                  };
                  // Pass it back as second parameter
                  Navigator.pop(context,respond);

                }, child: const Text("Delete")),
                ElevatedButton(onPressed: (){

                  var respond = {
                    "index":index,
                    "action":2
                  };
                  Navigator.pop(context,respond);


                }, child: Text(item["completed"] != true ? "Mark as complete" : "Unmark completion"))
              ],
            )
          ],
        ),
      ),
    );
  }
}