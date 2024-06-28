import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_ambw/hive.dart';
import 'package:uas_ambw/notes.dart';
import 'package:uas_ambw/screens/pin.dart';
import 'package:uas_ambw/widgets/add_note_button.dart';
import 'package:uas_ambw/widgets/note_grid.dart';
import 'package:uas_ambw/widgets/note_list.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool galleryMode = false;

  @override
  Widget build(BuildContext context) {
    Notes notes = Provider.of<Notes>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(200, 0, 0, 0),
        title: const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: Text(
            'Notes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: IconButton(
              onPressed: () {
                setState(() {
                  galleryMode = !galleryMode;
                });
              },
              padding: EdgeInsets.zero,
              icon: Icon(
                galleryMode == false
                    ? CupertinoIcons.square_grid_2x2
                    : CupertinoIcons.list_bullet,
                color: Colors.amber,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InputPin(isEditing: true),
                  ),
                );
              },
              icon: const Icon(
                CupertinoIcons.lock,
                color: Colors.amber,
              ),
            ),
          ),
        ],
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 50),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
      bottomNavigationBar: Consumer<Notes>(
        builder: (context, notes, child) => ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 100, sigmaY: 80),
            child: Container(
              padding: EdgeInsets.zero,
              height: 80,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(
                      flex: 4,
                    ),
                    Text(
                      notes.notes.isEmpty
                          ? "No notes"
                          : "${noteBoxes.length.toString()} ${notes.notes.length == 1 ? "note" : "notes"}",
                      textAlign: TextAlign.end,
                    ),
                    const Spacer(
                      flex: 3,
                    ),
                    const AddNoteButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 128, bottom: 128),
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: noteBoxes.length > 0
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: CupertinoSearchTextField(
                        itemColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(top: 4.0, left: 4.0),
                          child: Icon(CupertinoIcons.search,
                              color: Colors.white, size: 20),
                        ),
                        autocorrect: false,
                        onChanged: (value) {
                          notes.search(value);
                        },
                      ),
                    ),
                    galleryMode ? NoteGrid() : NoteList(),
                  ],
                )
              : const Center(
                  child: Text(
                    "No notes",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 24,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
