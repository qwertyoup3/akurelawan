import 'package:flutter/material.dart';

import '../models/event_model.dart';

class DetailScreen extends StatelessWidget {
  final EventModel event;
  const DetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red, size: 20),
                const SizedBox(width: 4),
                Text(event.venue, style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue, size: 20),
                const SizedBox(width: 4),
                Text('${event.startDatetime} - ${event.endDatetime}'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Deskripsi Kegiatan:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              event.description.isEmpty
                  ? 'Belum ada deskripsi.'
                  : event.description,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Fitur pendaftaran (opsional) disimulasikan!',
                      ),
                    ),
                  );
                },
                child: const Text('Ikut Jadi Relawan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
