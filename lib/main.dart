import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sliding List with Edit & Delete',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SlidingList(),
    );
  }
}

class SlidingList extends StatefulWidget {
  @override
  _SlidingListState createState() => _SlidingListState();
}

class _SlidingListState extends State<SlidingList> {
  List<String> items = List.generate(10, (index) => 'Item ${index + 1}'); // Sample list of items

  // Function to handle the deletion of an item
  void deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
  }

  // Function to handle editing an item
  void editItem(int index) {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller =
            TextEditingController(text: items[index]);

        return AlertDialog(
          title: Text('Edit Item'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Item Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  items[index] = controller.text;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Right to Left Sliding List'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(items[index]),
            direction: DismissDirection.endToStart, // Right to Left slide
            onDismissed: (direction) {
              // Perform delete action when swiped
              deleteItem(index);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${items[index]} deleted')),
              );
            },
            background: Container(
              color: Colors.red, // Background color when swiped
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Delete', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            secondaryBackground: Container(
              color: Colors.blue, // Background color for the "edit" action
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Edit', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            child: ListTile(
              title: Text(items[index]),
              onTap: () => editItem(index), // Trigger edit action when tapped
            ),
          );
        },
      ),
    );
  }
}