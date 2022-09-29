import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'mainView.dart';
import 'ChangeNotifier.dart';

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
