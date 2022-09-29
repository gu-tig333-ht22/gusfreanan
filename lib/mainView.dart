import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'secondView.dart';
import 'ChangeNotifier.dart';

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
