import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    @Default('buddy_light') String companionPersona,
    @Default('2') String toneLevel,
    @Default('2') String intimacyLevel,
    @Default('record_only') String reachFreq,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);
}

extension AppSettingsExtension on AppSettings {
  Map<String, String> toDbMap() {
    return {
      'companion_persona': companionPersona,
      'tone_level': toneLevel,
      'intimacy_level': intimacyLevel,
      'reach_freq': reachFreq,
    };
  }

  static AppSettings fromDbMap(Map<String, String> map) {
    return AppSettings(
      companionPersona: map['companion_persona'] ?? 'buddy_light',
      toneLevel: map['tone_level'] ?? '2',
      intimacyLevel: map['intimacy_level'] ?? '2',
      reachFreq: map['reach_freq'] ?? 'record_only',
    );
  }
}

