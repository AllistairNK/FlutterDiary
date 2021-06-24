
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:testing/LoginForm.dart';
import 'package:testing/add_note.dart';
import 'package:testing/config.dart';
import 'package:testing/edit_note.dart';
import 'package:testing/hiveDB.dart';
import 'package:testing/widgets/nav-drawer.dart';

void main() async {
  if (!kIsWeb) {
    await Hive.initFlutter();
  }
  Hive.registerAdapter(DiaryAdapter());
  Hive.registerAdapter(DiaryTypeAdapter());
  Hive.registerAdapter(TextDiaryAdapter());
  await Hive.openBox<Diary>(diariesBox);
  await Hive.openBox<TextDiary>(textDiariesBox);
  runApp(MyApp());
}

bool isLoggedIn = false;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diary Test',
      initialRoute: "/",
      //loginCheck(),
      routes: {
        '/': (context) => MyHomePage(),
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
      body: getDiaries(),
        floatingActionButton: addDiaryButton(),
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

getDiaries() {
    return ValueListenableBuilder(
      valueListenable: Hive.box<Diary>(diariesBox).listenable(),
      builder: (context, Box<Diary> box, _) {
        if (box.values.isEmpty) {
          return Center(
            child: Text("No Diary Entries!"),
          );
        }
        List<Diary> diaries = getDiariesList();
        return ReorderableListView(
          buildDefaultDragHandles: false,
            onReorder: (oldIndex, newIdenx) async {
              await reorderDiaries(oldIndex, newIdenx, diaries);
            },
            children: <Widget>[
              for (Diary diary in diaries) ...[
                getDiaryInfo(diary, context),
              ],
            ]);
      },
    );
  }

getDiariesList() {
    List<Diary> diaries = Hive.box<Diary>(diariesBox).values.toList();
    diaries = getDiariesSortedByOrder(diaries);
    return diaries;
  }

  getDiariesSortedByOrder(List<Diary> diaries) {
    diaries.sort((a, b) {
      var aposition = a.position;
      var bposition = b.position;
      return aposition.compareTo(bposition);
    });
    return diaries;
  }

getDiaryInfo(Diary diary, BuildContext context) {
    return ListTile(
      dense: true,
      key: Key(diary.key.toString()),
      title: Text(diary.title),
      leading: ReorderableDragStartListener(
      index: diary.position,
      child: const Icon(Icons.drag_handle),
      ),
      trailing: IconButton(
        icon: Icon(Icons.arrow_forward, size: 22, color: Colors.grey[200]),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditDiary(
                diaryKey: diary.key,
              ),
            ),
          );
        },
      ),
    );
  }

 reorderDiaries(oldIndex, newIdenx, diaries) async {
    Box<Diary> hiveBox = Hive.box<Diary>(diariesBox);
    if (oldIndex < newIdenx) {
      diaries[oldIndex].position = newIdenx - 1;
      await hiveBox.put(diaries[oldIndex].key, diaries[oldIndex]);
      for (int i = oldIndex + 1; i < newIdenx; i++) {
        diaries[i].position = diaries[i].position - 1;
        await hiveBox.put(diaries[i].key, diaries[i]);
      }
    } else {
      diaries[oldIndex].position = newIdenx;
      await hiveBox.put(diaries[oldIndex].key, diaries[oldIndex]);
      for (int i = newIdenx; i < oldIndex; i++) {
        diaries[i].position = diaries[i].position + 1;
        await hiveBox.put(diaries[i].key, diaries[i]);
      }
    }
  }

 addDiaryButton() {
    return Builder(
      builder: (context) {
        return FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddDiary()));
          },
        );
      },
    );
  }

loginCheck()
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