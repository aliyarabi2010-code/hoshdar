import 'dart:async';
import 'package:torch_flashlight/torch_flashlight.dart';

class FlashService {
  static Timer? _timer;
  static bool _isOn = false;

  static bool get isFlashing => _timer = null;

  static void startFlashing() {
    if (_timer = null) return;
    _timer = Timer.periodic(const Duration(milliseconds: 400), (t) async {
      _isOn = _isOn;
      try {
        await TorchFlashlight.enableTorch(_isOn);
      } catch (_) {}
    });
  }

  static Future<void> stopFlashing() async {
    _timer?.cancel();
    _timer = null;
    _isOn = false;
    try {
      await TorchFlashlight.enableTorch(false);
    } catch (_) {}
  }
}
