// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiveDB.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiaryTypeAdapter extends TypeAdapter<DiaryType> {
  @override
  final int typeId = 1;

  @override
  DiaryType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DiaryType.Text;
      default:
        return DiaryType.Text;
    }
  }

  @override
  void write(BinaryWriter writer, DiaryType obj) {
    switch (obj) {
      case DiaryType.Text:
        writer.writeByte(0);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiaryTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DiaryAdapter extends TypeAdapter<Diary> {
  @override
  final int typeId = 0;

  @override
  Diary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Diary(
      fields[0] as DateTime,
      fields[1] as String,
      fields[2] as String,
      fields[3] as DateTime,
      fields[4] as DiaryType,
      fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Diary obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.dateCreated)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.dateUpdated)
      ..writeByte(4)
      ..write(obj.diaryType)
      ..writeByte(5)
      ..write(obj.position);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TextDiaryAdapter extends TypeAdapter<TextDiary> {
  @override
  final int typeId = 2;

  @override
  TextDiary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TextDiary(
      fields[0] as String,
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TextDiary obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.diaryParent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextDiaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
