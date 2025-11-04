import 'package:freezed_annotation/freezed_annotation.dart';

part 'insight.freezed.dart';
part 'insight.g.dart';

@freezed
class Insight with _$Insight {
  const factory Insight({
    required int id,
    required int entryId,
    String? sentiment,
    double? sentimentStrength,
    @Default([]) List<String> symptoms,
    @Default([]) List<String> factors,
    int? companionLastTriggeredAt,
    @Default([]) List<String> lastScenarioTags,
  }) = _Insight;

  factory Insight.fromJson(Map<String, dynamic> json) => _$InsightFromJson(json);
}

extension InsightExtension on Insight {
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'entry_id': entryId,
      'sentiment': sentiment,
      'sentiment_strength': sentimentStrength,
      'symptoms': symptoms.isNotEmpty ? symptoms.join(',') : null,
      'factors': factors.isNotEmpty ? factors.join(',') : null,
      'companion_last_triggered_at': companionLastTriggeredAt,
      'last_scenario_tags': lastScenarioTags.isNotEmpty ? lastScenarioTags.join(',') : null,
    };
  }

  static Insight fromDbMap(Map<String, dynamic> map) {
    return Insight(
      id: map['id'] as int,
      entryId: map['entry_id'] as int,
      sentiment: map['sentiment'] as String?,
      sentimentStrength: map['sentiment_strength'] as double?,
      symptoms: map['symptoms'] != null
          ? (map['symptoms'] as String).split(',').where((e) => e.isNotEmpty).toList()
          : [],
      factors: map['factors'] != null
          ? (map['factors'] as String).split(',').where((e) => e.isNotEmpty).toList()
          : [],
      companionLastTriggeredAt: map['companion_last_triggered_at'] as int?,
      lastScenarioTags: map['last_scenario_tags'] != null
          ? (map['last_scenario_tags'] as String).split(',').where((e) => e.isNotEmpty).toList()
          : [],
    );
  }
}

