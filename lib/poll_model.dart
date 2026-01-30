import 'package:cloud_firestore/cloud_firestore.dart';

class PollModel {
  final String id; // New: To identify polls
  final String question;
  final Map<String, int> options;
  final bool active; // New: To show if voting is open

  PollModel({
    required this.id,
    required this.question,
    required this.options,
    this.active = true,
  });

  // Getter for total votes
  int get totalVotes {
    return options.values.fold(0, (sum, count) => sum + count);
  }

  factory PollModel.fromMap(String id, Map<String, dynamic> map) {
    return PollModel(
      id: id,
      question: map['question'] as String? ?? 'Loading...',
      options: Map<String, int>.from(map['options'] ?? {}),
      active: map['active'] as bool? ?? true,
    );
  }
  
  // Helper to create empty map for new polls
  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'active': active,
      'created_at': FieldValue.serverTimestamp(), // For sorting later
    };
  }
}
