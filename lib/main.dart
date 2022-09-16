import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO List',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MainView(),
    );
  }
}

//###################################################################################################
//########################################## MainView ###############################################
//###################################################################################################
class MainView extends StatefulWidget {
  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final List<String> todos = <String>["Exempeluppgift 1", "Exemppeluppgift 2"];
  final List<bool> isChecked = <bool>[false, false];
  var filterby =
      ""; //Hänger ihop med kommande filterfunktion. Används ej just nu.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text("TIG 333 TODO"),
          actions: [
//############################################################################## Meny för filtrering start
            PopupMenuButton(
                onSelected: (value) {
                  //Behöver uppdateras med funktion / Skapa ny lista baserat på isChecked bool-värde. Används ej.
                  setState(() {
                    if (value = true) {}
                    if (value = false) {
                    } else {}
                  });
                },
                itemBuilder: (context) => [
                      PopupMenuItem(child: Text("View All"), value: bool),
                      PopupMenuItem(child: Text("View Done"), value: true),
                      PopupMenuItem(child: Text("View Undone"), value: false),
                    ])
//############################################################################## Meny för filtrering slut
          ]),
      body: todoList(),
//############################################################################## FloatingActionButton start
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final String recievedText = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => secondView()));
          if (recievedText != null) {
            setState(() {
              todos.add(recievedText);
              isChecked.add(false);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
//############################################################################## FloatingActionButton slut
    );
  }

//############################################################################## Todolist start
  Widget todoList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, int index) {
              return todoContainer(index);
            },
          ),
        ),
        const SizedBox(height: 50)
      ],
    );
  }

//############################################################################## Todolist slut
//############################################################################## Todo/container & tillhörande widgets start
  Widget todoContainer(int index) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        children: [
          todoCheckbox(index),
          todoText(index),
          todoDelete(index),
        ],
      ),
    );
  }

  Widget todoCheckbox(int index) {
    return Checkbox(
      value: isChecked[index],
      onChanged: (bool? newValue) {
        setState(
          () {
            isChecked[index] = newValue!;
          },
        );
      },
    );
  }

  Widget todoText(int index) {
    return Expanded(
      child: Text(
        todos[index],
        style: isChecked[index]
            ? const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.lineThrough,
                color: Colors.black)
            : const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget todoDelete(int index) {
    return IconButton(
      icon: const Icon(
        Icons.clear,
        size: 30,
      ),
      onPressed: () {
        deleteEntry(todos, index);
      },
    );
  }

  void deleteEntry(List entryList, int index) {
    setState(() {
      entryList.removeAt(index);
      isChecked.removeAt(index);
    });
  }
}
//############################################################################## Todo/container & tillhörande widgets slut

//#########################################################################################################
//######################################## SecondView #####################################################
//#########################################################################################################
class secondView extends StatelessWidget {
  secondView({super.key});
  String textInput = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TIG333 TODO"),
      ),
      body: Column(
        children: [
          Container(height: 45),
          //#################################################################### Textfield input start
          TextField(
            onChanged: (text) {
              textInput = text;
            },
            decoration: const InputDecoration(
              enabledBorder:
                  OutlineInputBorder(borderSide: BorderSide(width: 2)),
              contentPadding: EdgeInsets.all(10.0),
              hintText: 'What are you going to do?',
            ),
          ),
          //#################################################################### Textfield slut
          Container(height: 30),
          //#################################################################### "+Add"-knapp start
          //#################################################################### (Går också tillbaka till mainView
          //####################################################################  med Navigator.pop)
          OutlinedButton(
              onPressed: () {
                Navigator.pop(context, textInput);
              },
              style: OutlinedButton.styleFrom(
                  side: const BorderSide(width: 2, color: Colors.black)),
              child: const Text(
                "+ Add",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ))
          //#################################################################### "+Add"-knapp slut
        ],
      ),
    );
  }
}
