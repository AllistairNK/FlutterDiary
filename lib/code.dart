import 'package:hive/hive.dart';
import 'package:testing/hiveDB.dart';
import 'config.dart';
import 'package:intl/intl.dart' as intl;

class Code {
  changeUpdatedDate(int diaryKey) async {
    Box<Diary> diaries = Hive.box<Diary>(diariesBox);
    Diary diary = Hive.box<Diary>(diariesBox)
        .values
        .singleWhere((value) => value.key == diaryKey);
    diary.dateUpdated = DateTime.now();
    await diaries.put(diaryKey, diary);
  }
  String getDateFormated(DateTime date) {
    return intl.DateFormat('dd-MM-yyyy HH:mm:ss').format(date);
  }
}