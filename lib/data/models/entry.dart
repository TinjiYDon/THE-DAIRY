import 'package:freezed_annotation/freezed_annotation.dart';

part 'entry.freezed.dart';
part 'entry.g.dart';

@freezed
class Entry with _$Entry {
  const factory Entry({
    required int id,
    required int date,
    String? text,
    int? moodScore,
    @Default([]) List<String> tags,
    @Default([]) List<String> mediaRefs,
    required int createdAt,
    int? updatedAt,
  }) = _Entry;

  factory Entry.fromJson(Map<String, dynamic> json) => _$EntryFromJson(json);
}

extension EntryExtension on Entry {
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'date': date,
      'text': text,
      'mood_score': moodScore,
      'tags': tags.isNotEmpty ? tags.join(',') : null,
      'media_refs': mediaRefs.isNotEmpty ? mediaRefs.join(',') : null,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static Entry fromDbMap(Map<String, dynamic> map) {
    return Entry(
      id: map['id'] as int,
      date: map['date'] as int,
      text: map['text'] as String?,
      moodScore: map['mood_score'] as int?,
      tags: map['tags'] != null
          ? (map['tags'] as String).split(',').where((e) => e.isNotEmpty).toList()
          : [],
      mediaRefs: map['media_refs'] != null
          ? (map['media_refs'] as String).split(',').where((e) => e.isNotEmpty).toList()
          : [],
      createdAt: map['created_at'] as int,
      updatedAt: map['updated_at'] as int?,
    );
  }
}

