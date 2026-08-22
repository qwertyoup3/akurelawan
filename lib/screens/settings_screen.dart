import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isNotifEnabled = true;
  String _fcmToken = "Menunggu token dari Firebase...";

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Default true jika belum pernah diset
      _isNotifEnabled = prefs.getBool('notif_enabled') ?? true;
      _fcmToken = prefs.getString('fcm_token') ?? "Token belum digenerate...";
    });
  }

  void _toggleNotif(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_enabled', value);
    setState(() => _isNotifEnabled = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SwitchListTile(
            title: const Text('Terima Notifikasi'),
            subtitle: const Text(
              'Aktifkan untuk menerima update event relawan',
            ),
            value: _isNotifEnabled,
            onChanged: _toggleNotif,
          ),
          const Divider(),
          ListTile(
            title: const Text('FCM Token'),
            subtitle: Text(_fcmToken),
            trailing: IconButton(
              icon: const Icon(Icons.copy),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _fcmToken));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('FCM Token berhasil disalin!')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
