import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'poll_model.dart';

class PollStore {
  static final PollStore _instance = PollStore._internal();
  factory PollStore() => _instance;
  PollStore._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// -------------------------------------------------------------
  /// 🛠️ WORKSHOP MISSION: SWITCH TO CLOUD MODE
  /// -------------------------------------------------------------
  /// Currently, this app runs in "Local Simulation Mode".
  /// Your goal is to uncomment the Firebase code to make it real!
  /// -------------------------------------------------------------

  // 👇 MISSION 2: Connect to Real-Time Data
  // Replace this local stream with the Firestore stream below
  Stream<List<PollModel>> get pollsStream {
    // --- [START] LOCAL SIMULATION ---
    return Stream.periodic(const Duration(seconds: 1), (count) {
      return [
        PollModel(
          id: 'local_1',
          question: 'Is this running locally? (Simulated)',
          options: {'Yes': count, 'No': 0},
        ),
      ];
    });
    // --- [END] LOCAL SIMULATION ---

    // --- [START] FIRESTORE (UNCOMMENT FOR WORKSHOP) ---
    // return _db.collection('polls').snapshots().map((snapshot) {
    //   return snapshot.docs.map((doc) {
    //     return PollModel.fromMap(doc.id, doc.data());
    //   }).toList();
    // });
    // --- [END] FIRESTORE ---
  }

  // 👇 MISSION 3: Implement Voting
  Future<void> vote(String pollId, String option) async {
    // --- [START] LOCAL SIMULATION ---
    debugPrint("Simulated Vote: $option");
    // --- [END] LOCAL SIMULATION ---

    // --- [START] FIRESTORE (UNCOMMENT FOR WORKSHOP) ---
    // await _db.collection('polls').doc(pollId).update({
    //   'options.$option': FieldValue.increment(1),
    // });
    // --- [END] FIRESTORE ---
  }

  // 👇 MISSION 4: Create Polls
  Future<void> createPoll({required String question, required List<String> options}) async {
    // --- [START] LOCAL SIMULATION ---
    debugPrint("Simulated Create Poll: $question");
    // --- [END] LOCAL SIMULATION ---

    // --- [START] FIRESTORE (UNCOMMENT FOR WORKSHOP) ---
    // final optionsMap = {for (var e in options) e: 0};
    // await _db.collection('polls').add({
    //   'question': question,
    //   'options': optionsMap,
    //   'active': true,
    //   'created_at': FieldValue.serverTimestamp(),
    // });
    // --- [END] FIRESTORE ---
  }
}
