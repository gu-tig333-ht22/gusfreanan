import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO-list',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'TIG333 TODO-list'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //FUNKTION SOM ANVÄNDS FÖR ATT ÖKA ANTALET I "TODO-list" PÅ SKÄRMEN
  int tal = 0;
  var _lista = <int>[];
  void _increaseList() {
    setState(() {
      _lista.add(tal);
      tal++;
    });
  }
  //SLUT FUNKTION

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.title),
        ),
        body: ListView.builder(
            itemCount: _lista.length,
            itemBuilder: (BuildContext context, int tal) {
              return ListTile(
                  leading: const Icon(Icons.check_box_outlined),
                  trailing: const Icon(Icons.close),
                  title: Text("Valfri uppgift nr. $tal"));
            }),
        floatingActionButton: FloatingActionButton(
            onPressed:
                _increaseList, //KALLAR FUNKTION SOM ÖKAR ANTALET I "TODO-list"
            tooltip: 'Add to list',
            child: const Icon(Icons.add)));
  }
}
