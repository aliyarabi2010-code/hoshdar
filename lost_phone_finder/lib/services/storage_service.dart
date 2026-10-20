import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/command_code.dart';
import '../utils/constants.dart';

class StorageService {
  static Future<List<CommandCode>> loadCodes() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(AppConstants.prefCodesKey);
    if (raw == null || raw.isEmpty) {
      return [
        CommandCode(code: AppConstants.defaultActivateCode, isActivate: true),
        CommandCode(code: AppConstants.defaultDeactivateCode, isActivate: false),
      ];
    }
    final List list = jsonDecode(raw);
    return list.map((e) => CommandCode.fromJson(e)).toList();
  }

  static Future<void> saveCodes(List<CommandCode> codes) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(codes.map((e) => e.toJson()).toList());
    await prefs.setString(AppConstants.prefCodesKey, raw);
  }

  static Future<bool> isServiceEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.prefServiceKey) ?? false;
  }

  static Future<void> setServiceEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefServiceKey, value);
  }
}
