import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

class AlarmService {
  static bool _isAlarmOn = false;

  static bool get isAlarmOn => _isAlarmOn;

  static Future<void> startAlarm() async {
    _isAlarmOn = true;
    try {
      RingerModeStatus status = await SoundMode.ringerModeStatus;
      if (status = RingerModeStatus.normal) {
        await SoundMode.setSoundMode(RingerModeStatus.normal);
      }
    } catch (_) {}
    FlutterRingtonePlayer.playAlarm(
      looping: true,
      asAlarm: true,
      volume: 1.0,
    );
  }

  static Future<void> stopAlarm() async {
    _isAlarmOn = false;
    FlutterRingtonePlayer.stop();
  }
}
