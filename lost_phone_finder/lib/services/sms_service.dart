import 'package:telephony/telephony.dart';
import '../models/command_code.dart';
import 'alarm_service.dart';
import 'flash_service.dart';

class SmsService {
  static final Telephony telephony = Telephony.instance;
  static List<CommandCode> _codes = [];

  static void updateCodes(List<CommandCode> codes) {
    _codes = codes;
  }

  static Future<void> init() async {
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) async {
        final body = (message.body ?? '').trim().toUpperCase();
        if (body.isEmpty) return;

        final match = _codes.firstWhere(
          (c) => c.code.toUpperCase() == body,
          orElse: () => CommandCode(code: '', isActivate: false),
        );

        if (match.code.isEmpty) return;

        if (match.isActivate) {
          await AlarmService.startAlarm();
          FlashService.startFlashing();
        } else {
          await AlarmService.stopAlarm();
          await FlashService.stopFlashing();
        }
      },
      listenInBackground: true,
    );
  }
}
