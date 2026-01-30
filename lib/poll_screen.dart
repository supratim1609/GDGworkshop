import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'poll_store.dart';
import 'poll_model.dart';
import 'create_poll_screen.dart';

class PollScreen extends StatefulWidget {
  const PollScreen({super.key});

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  final PollStore _store = PollStore();
  bool _hasVoted = false;
  int _currentIndex = 0; // 0 = Newest

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Live Poll 📊"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, size: 32, color: Colors.deepPurple),
            tooltip: 'Create New Poll',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreatePollScreen()),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder<List<PollModel>>(
        stream: _store.pollsStream, 
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text("⚠️ Error: ${snapshot.error}"));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator()); 

          final polls = snapshot.data!;
          
          if (polls.isEmpty) return const Center(child: Text("Waiting for polls..."));

          // Sort by creation time (optional, as Firestore can do this too, but we keep it safe)
          // Note: Since we are in local mode returning a simple list, this just works.
          // For Cloud, we might rely on the list order or sort here.
          // Let's assume the Store gives us a List, we can just show them.
          
          // Safety Check for Index
          if (_currentIndex >= polls.length) _currentIndex = polls.length - 1;
          if (_currentIndex < 0) _currentIndex = 0;

          final poll = polls[_currentIndex];
          final totalVotes = poll.totalVotes;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      poll.question,
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    ...poll.options.entries.map((entry) {
                       final option = entry.key;
                       final count = entry.value;
                       final percentage = totalVotes == 0 ? 0.0 : count / totalVotes;
                       return Card(
                         margin: const EdgeInsets.symmetric(vertical: 8),
                         child: ListTile(
                           title: Text(option),
                           subtitle: _hasVoted 
                             ? LinearProgressIndicator(value: percentage, minHeight: 6)
                             : null,
                           trailing: _hasVoted 
                              ? Text("$count votes") 
                              : const Icon(Icons.touch_app),
                           onTap: _hasVoted ? null : () {
                              _store.vote(poll.id, option);
                              setState(() => _hasVoted = true);
                           },
                         ),
                       );
                    }),
                  ],
                ),
              ),
              
              // --- PAGINATION CONTROLS ---
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _currentIndex > 0 
                        ? () => setState(() {
                            _currentIndex--; 
                            _hasVoted = false; 
                          }) 
                        : null,
                    ),
                    Text(
                      "Poll ${_currentIndex + 1} of ${polls.length}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: _currentIndex < polls.length - 1 
                        ? () => setState(() {
                            _currentIndex++; 
                            _hasVoted = false;
                          }) 
                        : null,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
