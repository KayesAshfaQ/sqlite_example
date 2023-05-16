import 'package:flutter/material.dart';
import 'package:sqlite_example/database_operation.dart';

import 'model/dog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MyButton(
              title: 'Insert',
              onPressed: () {
                dialogue('insert');
              },
            ),
            MyButton(
              title: 'Retrive',
              onPressed: () async {
                Operations operation = Operations.db;
                List<Dog> list = await operation.retriveDogs();
                dogsListDialogue(list);
              },
            ),
            MyButton(
              title: 'Update',
              onPressed: () {
                dialogue('update');
              },
            ),
            MyButton(
              title: 'Delete',
              onPressed: () {
                dialogue('delete');
              },
            ),
          ],
        ),
      ),
    );
  }

  // dialogue to get input from user
  void dialogue(String operation) {
    int dogId = 0;
    String dogName = '';
    int dogAge = 0;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Enter Dog Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter ID',
                  ),
                  onChanged: (value) {
                    setState(() {
                      dogId = int.parse(value);
                    });
                  },
                ),
                if (operation != 'delete')
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter Dog Name',
                    ),
                    onChanged: (value) {
                      setState(() {
                        dogName = value;
                      });
                    },
                  ),
                if (operation != 'delete')
                  TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter Dog Age',
                    ),
                    onChanged: (value) {
                      setState(() {
                        dogAge = int.parse(value);
                      });
                    },
                  ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  var fido = Dog(
                    id: dogId,
                    name: dogName,
                    age: dogAge,
                  );

                  debugPrint(fido.toString());
                  Operations database = Operations.db;

                  if (operation == 'insert') {
                    print('in insert');
                    await database.insertDog(fido);
                  } else if (operation == 'update') {
                    print('in update');
                    await database.updateDog(fido);
                  } else if (operation == 'delete') {
                    print('in delete');
                    await database.deleteDog(dogId);
                  }

                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
  }

  // dialogue to show list of dogs
  void dogsListDialogue(List<Dog> dogsList) {
    final height = MediaQuery.of(context).size.height;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: height * 0.8,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: dogsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("ID : ${dogsList[index].id.toString()}"),
                        Text("Name : ${dogsList[index].name}"),
                        Text("Age : ${dogsList[index].age.toString()}"),
                        const SizedBox(height: 16),
                        if (index != dogsList.length - 1)
                          const Divider(height: 1, thickness: 1),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        });
  }
}

class MyButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const MyButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Colors.white),
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
