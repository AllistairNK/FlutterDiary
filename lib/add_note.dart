import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:testing/config.dart';
import 'package:testing/hiveDB.dart';

class AddDiary extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Diary Entry"),
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
                    "Fill Diary info",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
                  ),
                  getDivider(),
                  title(),
                  getDivider(),
                  description(),
                  getDivider(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.all(5),
                          child: OutlinedButton(
                            child: Text("Text Diary"),
                            onPressed: () {
                              createTextDiary(context);
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

  createTextDiary(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      Box<Diary> diaries = Hive.box<Diary>(diariesBox);
      reorderDiaries(diaries);
      int pk = await diaries.add(Diary(DateTime.now(), _titleController.text,
          _descriptionController.text, DateTime.now(), DiaryType.Text, 0));
      Box<TextDiary> tDiaries = Hive.box<TextDiary>(textDiariesBox);
      await tDiaries.add(TextDiary("", pk));
      Navigator.of(context).pop();
    }
  }

  reorderDiaries(Box<Diary> diaries) {
    for (Diary diaryOrder in diaries.values) {
      diaryOrder.position = diaryOrder.position + 1;
      diaries.put(diaryOrder.key, diaryOrder);
    }
  }
}