import 'package:flutter/material.dart';

// Named Routes မှ pass လာသော data ကို ပြသသည်
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Route arguments ကို ModalRoute မှ ရယူ
    final args = ModalRoute.of(context)?.settings.arguments;
    Map<String, dynamic>? data;

    if (args is Map<String, dynamic>) {
      data = args;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF0),
      appBar: AppBar(
        title: const Text('Detail Screen'),
        backgroundColor: const Color(0xFFFFAA00),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFAA00), Color(0xFFFF8800)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.info_outline, color: Colors.white, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    data?['title']?.toString() ?? 'Detail Screen',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (data != null) ...[
              const Text(
                '📦 Received Arguments:',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142)),
              ),
              const SizedBox(height: 12),
              ...data.entries.map((entry) => _ArgumentItem(
                    key_: entry.key,
                    value: entry.value.toString(),
                  )),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info, color: Color(0xFFFFAA00)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Arguments မပါဘဲ navigate လုပ်သည်။\n'
                        '"pushNamed + Arguments" ကို နှိပ်ကြည့်ပါ',
                        style: TextStyle(
                            color: Color(0xFFFF8800), fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('ပြန်သွား'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFAA00),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArgumentItem extends StatelessWidget {
  final String key_;
  final String value;

  const _ArgumentItem({required this.key_, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFAA00).withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              key_,
              style: const TextStyle(
                fontFamily: 'monospace',
                color: Color(0xFFFF8800),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFF2D3142), fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
