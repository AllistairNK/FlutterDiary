import 'package:hive/hive.dart';

part 'hiveDB.g.dart';

@HiveType(typeId: 0)
class Diary extends HiveObject {
  @HiveField(0)
  DateTime dateCreated;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime dateUpdated;

  @HiveField(4)
  DiaryType diaryType;

  @HiveField(5)
  int position;

  Diary(this.dateCreated, this.title, this.description, this.dateUpdated,
      this.diaryType, this.position);
}

@HiveType(typeId: 1)
enum DiaryType {
  @HiveField(0)
  Text,
}
const diaryType = <DiaryType, int>{
  DiaryType.Text: 1,
};


@HiveType(typeId: 2)
class TextDiary extends HiveObject {
  @HiveField(0)
  String text;

  @HiveField(1)
  int diaryParent;

  TextDiary(this.text, this.diaryParent);
}