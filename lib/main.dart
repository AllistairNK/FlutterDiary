import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:testing/LoginForm.dart';
import 'package:testing/add_note.dart';
import 'package:testing/config.dart';
import 'package:testing/hiveDB.dart';
import 'package:testing/widgets/nav-drawer.dart';

void main() async {
  if (!kIsWeb) {
    await Hive.initFlutter();//waits to initialize path on flutter with the default path
  }
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(NoteTypeAdapter());
  Hive.registerAdapter(CheckListNoteAdapter());
  Hive.registerAdapter(TextNoteAdapter());
  await Hive.openBox<Note>(notesBox);//if it's the first time running, it will also create the "Box", else it will just open
  await Hive.openBox<TextNote>(textNotesBox);//this box will be used later for the Text Type entries
  await Hive.openBox<CheckListNote>(checkListNotesBox);//this box will be used later for the Check List Type entries
  runApp(MyApp());
}

bool isLoggedIn = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary Test',
      initialRoute: "/",
      //LoginCheck(),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => MyHomePage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/Login': (context) => Login(),
      },
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Diary test'),
      ),
      body: getNotes(),
        floatingActionButton: addNoteButton(),
    );
  }
}

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Login'),
      ),
      body: MyCustomForm()
    );
  }
}

getNotes() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Note>(notesBox).listenable(),
      builder: (context, Box<Note> box, _) {
        if (box.values.isEmpty) {
          return Center(
            child: Text("No Notes!"),
          );
        }
        List<Note> notes = getNotesList(); //get notes from box function
        return ReorderableListView(
            onReorder: (oldIndex, newIdenx) async {
              await reorderNotes(oldIndex, newIdenx, notes);
            },
            children: <Widget>[
              for (Note note in notes) ...[
                getNoteInfo(note),
              ],
            ]);
      },
    );
  }

getNotesList() {
    //get notes as a List
    List<Note> notes = Hive.box<Note>(notesBox).values.toList();
    notes = getNotesSortedByOrder(notes);
    return notes;
  }

  getNotesSortedByOrder(List<Note> notes) {
    //ordering note list by position
    notes.sort((a, b) {
      var aposition = a.position;
      var bposition = b.position;
      return aposition.compareTo(bposition);
    });
    return notes;
  }

getNoteInfo(Note note) {
    return ListTile(
      dense: true,
      key: Key(note.key.toString()),
      title: Text(note.title),
    );
  }

 reorderNotes(oldIndex, newIdenx, notes) async {
    Box<Note> hiveBox = Hive.box<Note>(notesBox);
    if (oldIndex < newIdenx) {
      notes[oldIndex].position = newIdenx - 1;
      await hiveBox.put(notes[oldIndex].key, notes[oldIndex]);
      for (int i = oldIndex + 1; i < newIdenx; i++) {
        notes[i].position = notes[i].position - 1;
        await hiveBox.put(notes[i].key, notes[i]);
      }
    } else {
      notes[oldIndex].position = newIdenx;
      await hiveBox.put(notes[oldIndex].key, notes[oldIndex]);
      for (int i = newIdenx; i < oldIndex; i++) {
        notes[i].position = notes[i].position + 1;
        await hiveBox.put(notes[i].key, notes[i]);
      }
    }
  }

 addNoteButton() {
    return Builder(
      builder: (context) {
        return FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddNote()));
          },
        );
      },
    );
  }

LoginCheck()
async {
  if (isLoggedIn == true)
  {
    return "/";
  }
  else
  {
    return "/Login";
  }
}