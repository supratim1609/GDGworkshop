import 'package:flutter/material.dart';
import 'poll_store.dart';

class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({super.key});

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final _questionController = TextEditingController();
  // Start with 2 options by default
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  
  bool _isCreating = false;

  @override
  void dispose() {
    _questionController.dispose();
    for (var c in _optionControllers) c.dispose();
    super.dispose();
  }

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _create() async {
    // 1. Validate Question
    if (_questionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a question')),
      );
      return;
    }

    // 2. Validate Options (Must have at least 2 non-empty options)
    final validOptions = _optionControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (validOptions.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide at least 2 options')),
      );
      return;
    }

    setState(() => _isCreating = true);

    await PollStore().createPoll(
      question: _questionController.text.trim(),
      options: validOptions,
    );

    if (mounted) {
      Navigator.pop(context); // Go back to Home
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Poll')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: 'Poll Question',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.poll),
              ),
            ),
            const SizedBox(height: 20),
            
            // --- Dynamic Options List ---
            Expanded(
              child: ListView.separated(
                itemCount: _optionControllers.length + 1, // +1 for the Add Button
                separatorBuilder: (ctx, i) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  // The last item is the "Add Option" button
                  if (index == _optionControllers.length) {
                    return TextButton.icon(
                      onPressed: _addOption,
                      icon: const Icon(Icons.add),
                      label: const Text("Add Another Option"),
                    );
                  }

                  return TextField(
                    controller: _optionControllers[index],
                    decoration: InputDecoration(
                      labelText: 'Option ${index + 1}',
                      prefixIcon: const Icon(Icons.short_text),
                      suffixIcon: index > 1 
                        ? IconButton(
                            icon: const Icon(Icons.close, color: Colors.grey),
                            onPressed: () {
                              setState(() {
                                _optionControllers[index].dispose();
                                _optionControllers.removeAt(index);
                              });
                            },
                          ) 
                        : null, // Don't allow deleting first 2 options
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
            
            // --- Create Button ---
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isCreating ? null : _create,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  elevation: 4,
                ),
                child: _isCreating 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text('Start Live Poll 🚀', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
