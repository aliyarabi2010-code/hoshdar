import 'package:flutter/material.dart';
import '../models/command_code.dart';
import '../services/storage_service.dart';
import '../services/sms_service.dart';

class CodesScreen extends StatefulWidget {
  const CodesScreen({super.key});

  @override
  State<CodesScreen> createState() => _CodesScreenState();
}

class _CodesScreenState extends State<CodesScreen> {
  List<CommandCode> _codes = [];
  final _controller = TextEditingController();
  bool _isActivate = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final codes = await StorageService.loadCodes();
    setState(() => _codes = codes);
  }

  Future<void> _save() async {
    await StorageService.saveCodes(_codes);
    SmsService.updateCodes(_codes);
  }

  Future<void> _add() async {
    final text = _controller.text.trim().toUpperCase();
    if (text.isEmpty) return;
    setState(() {
      _codes.add(CommandCode(code: text, isActivate: _isActivate));
      _controller.clear();
    });
    await _save();
  }

  Future<void> _remove(int index) async {
    setState(() => _codes.removeAt(index));
    await _save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('کدهای دستوری')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'کد جدید',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<bool>(
                  value: _isActivate,
                  items: const [
                    DropdownMenuItem(value: true, child: Text('فعال')),
                    DropdownMenuItem(value: false, child: Text('غیرفعال')),
                  ],
                  onChanged: (v) => setState(() => _isActivate = v ?? true),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _add,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _codes.length,
                itemBuilder: (_, i) {
                  final c = _codes[i];
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        c.isActivate ? Icons.play_arrow : Icons.stop,
                        color: c.isActivate ? Colors.green : Colors.red,
                      ),
                      title: Text(c.code),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _remove(i),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
