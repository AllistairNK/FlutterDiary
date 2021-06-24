import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:testing/code.dart';
import 'package:testing/config.dart';
import 'package:testing/hiveDB.dart';

class EditDiary extends StatelessWidget {
  final int diaryKey;
  EditDiary({Key? key, required this.diaryKey}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Diary diary = Hive.box<Diary>(diariesBox)
        .values
        .singleWhere((value) => value.key == diaryKey);
    _titleController.text = diary.title;
    _descriptionController.text = diary.description;
    return Scaffold(
      appBar: AppBar(
        title: Text("Editing diary"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Info",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                  ),
                  getDivider(),
                  title(),
                  getDivider(),
                  description(),
                  getDivider(),
                  Row(
                    children: <Widget>[
                      Text(
                        "Updated: ",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        Code().getDateFormated(diary.dateUpdated),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  getDivider(),
                  Row(
                    children: <Widget>[
                      Text(
                        "Created: ",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        Code().getDateFormated(diary.dateCreated),
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  getDivider(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                            primary: Colors.red,
                            ),
                            child: Text("Delete"),
                            onPressed: () {
                              deleteDiary(context);
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                          primary: Colors.blue,
                          ),
                            child: Text("Save"),
                            onPressed: () {
                              updateDiaryInfo(diary, context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  updateDiaryInfo(Diary diary, context) async {
    if (_formKey.currentState!.validate()) {
      diary.title = _titleController.text;
      diary.description = _descriptionController.text;
      diary.dateUpdated = DateTime.now();
      Box<Diary> diaries = Hive.box<Diary>(diariesBox);
      await diaries.put(diaryKey, diary);
      Navigator.of(context).pop();
    }
  }

  deleteDiary(context) async {
    bool? continueDelete = await alertConfirmDialog(context);
    if (continueDelete != null && continueDelete) {
      Box<Diary> diaries = Hive.box<Diary>(diariesBox);
      await diaries.delete(diaryKey);
      Navigator.of(context).pop();
    }
  }

  Future<bool?> alertConfirmDialog(context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Diary Entry"),
          content: Text("Are you sure you want to delete this Entry?"),
          actions: <Widget>[
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    );
  }

  getDivider() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
    );
  }

  final TextEditingController _titleController = TextEditingController();
  title() {
    return TextFormField(
      controller: _titleController,
      validator: (value) {
        if (value == null) {
          return "Please fill the title";
        }
        return null;
      },
      style: TextStyle(fontSize: 18),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
          hintText: "Title",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );
  }

  final TextEditingController _descriptionController = TextEditingController();
  description() {
    return TextFormField(
      controller: _descriptionController,
      style: TextStyle(fontSize: 18),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
          hintText: "Description (optional)",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );
  }
}