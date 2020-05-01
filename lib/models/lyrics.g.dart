// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LyricsModelAdapter extends TypeAdapter<LyricsModel> {
  @override
  final typeId = 0;

  @override
  LyricsModel read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LyricsModel(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      favoris: fields[3] as int,
      date: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, LyricsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.favoris)
      ..writeByte(4)
      ..write(obj.date);
  }
}
