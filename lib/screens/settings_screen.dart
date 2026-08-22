import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _fcmToken = 'Memuat token...';
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _getFcmToken();
  }

  // Fungsi untuk mengambil token FCM dari Firebase
  Future<void> _getFcmToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      setState(() {
        _fcmToken = token ?? 'Gagal mendapatkan token';
      });
    } catch (e) {
      setState(() {
        _fcmToken = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Bagian Switch Notifikasi
          SwitchListTile(
            title: const Text('Terima Notifikasi'),
            subtitle: const Text(
              'Aktifkan untuk menerima update event relawan',
            ),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          const Divider(height: 32),

          // Bagian Tampil & Copy FCM Token
          const Text(
            'FCM Token',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(_fcmToken, style: const TextStyle(fontSize: 12)),
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    if (_fcmToken.isNotEmpty &&
                        !_fcmToken.startsWith('Memuat') &&
                        !_fcmToken.startsWith('Error')) {
                      Clipboard.setData(ClipboardData(text: _fcmToken));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Token berhasil disalin ke clipboard!'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
