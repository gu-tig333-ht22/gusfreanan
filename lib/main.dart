import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//##############################################################################
//############################ Main / MyApp ####################################
//##############################################################################
void main() {
  var state = MyState();

  runApp(
    ChangeNotifierProvider(
      create: (context) => state,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TODO List',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const mainView(),
    );
  }
}

//##############################################################################
//############################## mainView ######################################
//##############################################################################

class mainView extends StatelessWidget {
  const mainView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TIG 333 TODO"),
        actions: [
          Consumer<MyState>(
            builder: (context, state, child) => Row(
              children: [
                Text(
                  state.filterBy,
                  style: const TextStyle(fontSize: 18),
                ),
//########################### Many för filtrering start ########################
                PopupMenuButton(
                  onSelected: (value) =>
                      Provider.of<MyState>(context, listen: false)
                          .setFilterBy(value as String),
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'All', child: Text("All")),
                    const PopupMenuItem(value: 'Done', child: Text("Done")),
                    const PopupMenuItem(value: 'Undone', child: Text("Undone")),
                  ],
                )
//########################## Many för filtrering slut ##########################
              ],
            ),
          )
        ],
      ),
      body: Consumer<MyState>(builder: (context, state, child) {
        return todoList(filterList(state.list, state.filterBy));
      }),
//##########################  FloatingActionButton start #######################
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          var newItem = await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const secondView()));
          if (newItem != null && newItem.task != "") {
            Provider.of<MyState>(context, listen: false).addTodo(newItem);
          }
        },
      ),
//########################### FloatingActionButton slut ########################
    );
  }
}

//########################### Meny för filtrering IF-sats start ################
List<todoItem> filterList(list, filterBy) {
  if (filterBy == 'All') {
    return list;
  }
  if (filterBy == 'Done') {
    return list.where((item) => item.isChecked == true).toList();
  }
  if (filterBy == 'Undone') {
    return list.where((item) => item.isChecked == false).toList();
  }
  return list;
}

//######################### Meny för filtrering IF-sats slut ###################
//######################### todoList start #####################################
class todoList extends StatelessWidget {
  final List<todoItem> list;
  todoList(this.list);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: kFloatingActionButtonMargin + 55,
      ),
      children: list.map((item) => todoListTile(context, item)).toList(),
    );
  }

  //####################### todoList slut ######################################
  //####################### todoListTile start ##################################
  Widget todoListTile(context, item) {
    return Column(
      children: [
        ListTile(
          leading: Checkbox(
            value: item.isChecked,
            onChanged: (value) {
              Provider.of<MyState>(context, listen: false).setIsDone(item);
            },
          ),
          title: Text(
            item.task,
            style: item.isChecked
                ? const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.black)
                : const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.clear, size: 30),
            onPressed: () {
              Provider.of<MyState>(context, listen: false).deleteEntry(item);
            },
          ),
        ),
        const Divider(height: 20, thickness: 1),
      ],
    );
  }
}

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
          labelText: "Enter a task or go back to start page.",
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

//####################### todoItem & ChangeNotifier/notifyListeners start ######
class todoItem {
  String task;
  String id;
  bool isChecked;

  todoItem({required this.task, required this.id, required this.isChecked});
}

class MyState extends ChangeNotifier {
  List<todoItem> _list = [];
  String _filterBy = 'All';

  String homepage = "https://todoapp-api.apps.k8s.gu.se/todos";
  String key = "?key=a0017e4a-5008-42fb-9f72-3258d07304bb";

  List<todoItem> get list => _list;
  String get filterBy => _filterBy;

  MyState() {
    getApiList();
  }

  void getApiList() async {
    http.Response answer = await http.get(Uri.parse('$homepage$key'));
    List itemlist = jsonDecode(answer.body);
    apiList(itemlist);
  }

  void apiList(itemlist) {
    _list.clear();
    itemlist.forEach((object) {
      _list.add(todoItem(
          task: object["title"], isChecked: object["done"], id: object["id"]));
    });
    notifyListeners();
  }

  void addTodo(todoItem item) async {
    http.Response answer = await http.post(Uri.parse('$homepage$key'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"title": item.task, "done": item.isChecked}));
    List itemlist = jsonDecode(answer.body);
    apiList(itemlist);
    notifyListeners();
  }

  void deleteEntry(todoItem item) async {
    String id = item.id;
    http.Response answer = await http.delete(Uri.parse('$homepage/$id$key'));
    List itemlist = jsonDecode(answer.body);
    apiList(itemlist);
    notifyListeners();
  }

  void setIsDone(todoItem item) async {
    String id = item.id;
    http.Response answer = await http.put(Uri.parse('$homepage/$id$key'));
    List itemlist = jsonDecode(answer.body);
    item.isChecked = !item.isChecked;
    notifyListeners();
  }

  void setFilterBy(String filterBy) {
    this._filterBy = filterBy;
    notifyListeners();
  }
}
//########### todoItem & ChangeNotifier/notifyListeners slut ###################


