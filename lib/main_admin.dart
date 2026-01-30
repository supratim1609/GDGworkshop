import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; 

void main() {
  // 1. Run App IMMEDIATELY (Fixes white screen)
  runApp(const AdminApp());
}

class AdminApp extends StatefulWidget {
  const AdminApp({super.key});

  @override
  State<AdminApp> createState() => _AdminAppState();
}

class _AdminAppState extends State<AdminApp> {
  String _status = "⏳ Initializing Firebase...";
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _runSeeding();
  }

  Future<void> _runSeeding() async {
    try {
      // Initialize connection
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      setState(() => _status = "🔥 Connected! Creating Poll...");

      // Write to Firestore
      final db = FirebaseFirestore.instance;
      await db.collection('polls').doc('poll_1').set({
        'question': 'Which Cloud Service is your favorite?',
        'options': {
          'Cloud Run': 0,
          'Firebase': 0,
          'BigQuery': 0,
          'Vertex AI': 0,
        },
        'active': true,
      });

      setState(() {
        _status = "✅ SUCCESS! \nDatabase seeded successfully.\n\nYou can now STOP this command (Ctrl+C)\nand run 'flutter run' to start the workshop.";
        _isSuccess = true;
      });
      
    } catch (e) {
      setState(() => _status = "❌ ERROR: $e\n\nCheck browser console for more details.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: _isSuccess ? Colors.green.shade50 : Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_isSuccess) const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _isSuccess ? Colors.green.shade800 : Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
