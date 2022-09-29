import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
          task: object["title"] ?? 'Bad input. Remove.',
          isChecked: object["done"] ?? false,
          id: object["id"]));
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
    http.Response answer = await http.put(Uri.parse('$homepage/$id$key'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"title": item.task, "done": !item.isChecked}));
    List itemlist = jsonDecode(answer.body);
    apiList(itemlist);
    notifyListeners();
  }

  void setFilterBy(String filterBy) {
    this._filterBy = filterBy;
    notifyListeners();
  }
}
//########### todoItem & ChangeNotifier/notifyListeners slut ###################


