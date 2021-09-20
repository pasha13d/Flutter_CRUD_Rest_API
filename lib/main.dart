import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:live_data/services/notes_service.dart';
import 'package:live_data/views/note_list.dart';

void setUpLocator() {
  GetIt.instance.registerLazySingleton(() => NotesService());
  // GetIt.instance<NotesService>();
}
void main() {
  setUpLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NoteList(),
    );
  }
}

