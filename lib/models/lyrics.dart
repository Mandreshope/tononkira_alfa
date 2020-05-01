import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:tononkira_alfa/tools/timestampSerializerPlugin.dart';
import 'package:built_value/serializer.dart';

part 'lyrics.g.dart';

@HiveType(typeId: 0)
class LyricsModel with ChangeNotifier {

  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  int favoris = 0;

  @HiveField(4)
  DateTime date;
  
  LyricsModel({this.id, this.title, this.content, this.favoris, this.date});

  factory LyricsModel.fromJson(var data) => data == null ? LyricsModel() : LyricsModel(
    id: data['id'] as String,
    title: data['title'] as String,
    content: data['content'],
    date: TimestampSerializerPlugin().afterDeserialize(data['date'], FullType(DateTime,)),
  );

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'title': this.title,
    'content': this.content,
    'date': this.date,
  };
  
}