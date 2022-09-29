import 'package:flutter/material.dart';
import 'ChangeNotifier.dart';

//##############################################################################
//########################## secondView ########################################
//##############################################################################
class secondView extends StatefulWidget {
  const secondView({super.key});

  @override
  State<secondView> createState() {
    return secondViewState();
  }
}

class secondViewState extends State<secondView> {
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TIG333 TODO"),
      ),
      body: Column(
        children: [
          todoInputField(),
          Container(height: 30),
          addButton(),
        ],
      ),
    );
  }

//############################ todoInputField start ###########################
  Widget todoInputField() {
    return Container(
      margin: const EdgeInsets.only(left: 30, right: 30, top: 45),
      child: TextField(
        controller: myController,
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 2)),
          labelText: "Enter a task to your list.",
          labelStyle: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

//############################# todoInputField slut ###########################
//############################### addButton start #############################
  Widget addButton() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      OutlinedButton(
          onPressed: () {
            Navigator.pop(context,
                todoItem(task: myController.text, id: "", isChecked: false));
          },
          style: OutlinedButton.styleFrom(
              side: const BorderSide(width: 2, color: Colors.black)),
          child: const Text(
            "+ ADD",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          )),
    ]);
  }
//############################ addButton slut #################################
}
