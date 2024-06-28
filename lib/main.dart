import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uas_ambw/hive.dart';
import 'package:uas_ambw/models/note.dart';
import 'package:uas_ambw/notes.dart';
import 'package:uas_ambw/screens/home.dart';
import 'package:uas_ambw/screens/pin.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());

  // Hive.deleteBoxFromDisk("notes");
  // Hive.deleteBoxFromDisk("pin");

  noteBoxes = await Hive.openBox<Note>('notes');
  pinBox = await Hive.openBox<String>('pin');

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Notes>(
      create: (context) => Notes(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.purple,
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Color.fromARGB(192, 0, 0, 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.zero,
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Colors.grey.shade800),
            ),
          ),
        ),
        routes: {
          '/home': (context) => const Home(),
        },
        home: const InputPin(
          isEditing: false,
        ),
      ),
    );
  }
}
