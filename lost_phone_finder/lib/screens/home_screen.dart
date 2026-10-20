import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/sms_service.dart';
import '../services/alarm_service.dart';
import '../services/flash_service.dart';
import '../utils/permissions.dart';
import 'codes_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _serviceOn = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await AppPermissions.requestAll();
    final enabled = await StorageService.isServiceEnabled();
    final codes = await StorageService.loadCodes();
    SmsService.updateCodes(codes);
    if (enabled) {
      await SmsService.init();
    }
    setState(() => _serviceOn = enabled);
  }

  Future<void> _toggleService(bool value) async {
    setState(() => _serviceOn = value);
    await StorageService.setServiceEnabled(value);
    if (value) {
      final codes = await StorageService.loadCodes();
      SmsService.updateCodes(codes);
      await SmsService.init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lost Phone Finder'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: SwitchListTile(
                title: const Text('سرویس فعال'),
                subtitle: Text(_serviceOn ? 'در حال گوش دادن به پیامک‌ها' : 'غیرفعال'),
                value: _serviceOn,
                onChanged: _toggleService,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CodesScreen()),
                );
              },
              icon: const Icon(Icons.list),
              label: const Text('مدیریت کدهای دستوری'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                await AlarmService.stopAlarm();
                await FlashService.stopFlashing();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('آلارم متوقف شد')),
                );
              },
              icon: const Icon(Icons.stop),
              label: const Text('توقف فوری آلارم'),
            ),
          ],
        ),
      ),
    );
  }
}
