import 'package:flutter/material.dart';

class SearchPreviewScreen extends StatelessWidget {
  const SearchPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8FA),
        title: const Text('Søger efter Blind Date'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/BDV4.png', width: 160),
            const SizedBox(height: 28),
            const Text(
              'Vi leder efter din Blind Date',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 36),
              child: Text(
                'Vi matcher kun, når jeres præferencer passer begge veje.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 28),
            const CircularProgressIndicator(color: Color(0xFFF13BB7)),
          ],
        ),
      ),
    );
  }
}
