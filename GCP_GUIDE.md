# ☁️ GCP Integration: From Local to Cloud

This guide explains how to transition the workshop from **Local Simulation** to **Real-Time GCP (Firestore)** in the last 15 minutes.

## 1. The "Big Reveal" (Concept)
Explain to students:
> "Our app works, but the data is fake and stuck on one device. To make it a *real* live polling app, we need a cloud database. We will use **Google Cloud Firestore**."

---

## 2. Add Dependencies (Live Command)
Kill the app and run:
```bash
flutter pub add firebase_core cloud_firestore
```

*Tip: Have `flutterfire configure` pre-run or explain it as a prerequisite if time is tight.*

---

## 3. Initialize Firebase (Edit `main.dart`)
**Before:**
```dart
void main() {
  runApp(const MyApp());
}
```

**After (Live Code this):**
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // (Generated file)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

---

## 4. "Lift" the State to Cloud (Edit `poll_store.dart`)
We will replace the **Memory Logic** with **Firestore Logic**.

### Step A: Replace the Class Variables
Delete:
```dart
// PollModel poll = ...
// Timer? _simulationTimer;
```

Add:
```dart
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _db = FirebaseFirestore.instance;
final String pollId = 'workshop_poll'; // ID of document in Firestore
```

### Step B: Create the "Real-Time Stream"
Replace `startSimulation()` with a real listener.

```dart
Stream<PollModel> get pollStream {
  return _db.collection('polls').doc(pollId).snapshots().map((snapshot) {
    if (!snapshot.exists) return PollModel(question: "Loading...", options: {});
    
    // Convert Firestore Map to our PollModel
    final data = snapshot.data()!;
    // (Copy the safer parsing logic if created previously, or keep simple)
    return PollModel(
      question: data['question'] ?? '',
      options: Map<String, int>.from(data['options'] ?? {}),
    );
  });
}
```

### Step C: Update the Vote Logic
Replace `vote(String option)`:

```dart
Future<void> vote(String option) async {
  // GCP Magic: Atomic Increment
  await _db.collection('polls').doc(pollId).update({
    'options.$option': FieldValue.increment(1),
  });
}
```

---

## 5. Connect UI (Edit `poll_screen.dart`)
Refactor the `build` method to use `StreamBuilder` instead of `Timer`.

**Before:**
```dart
// In initState: _store.startSimulation();
// Body uses: _store.poll.question ...
```

**After:**
```dart
// Wrap Scaffold body in:
StreamBuilder<PollModel>(
  stream: _store.pollStream, // The stream we just made
  builder: (context, snapshot) {
    if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
    final poll = snapshot.data!;
    
    // ... Copy the existing ListView code here, using 'poll' variable ...
    return Column(...);
  }
)
```

## ✅ Result
You have now successfully migrated a local app to Google Cloud Platform in under 10 minutes of live coding!
