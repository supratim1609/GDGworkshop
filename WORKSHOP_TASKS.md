# 🛠️ GDG Flutter Workshop: Zero to Cloud 🚀

Welcome! Today you will take a **Local Flutter App** and lift it to the **Cloud** using Google Cloud Platform (Firebase).

## 🎯 Your Mission

The app currently runs in "Simulation Mode". It works, but the data is fake and local.
**Your goal is to make it REAL.**

### ✅ Task 1: Initialize Firebase
Go to `lib/main.dart`.
1.  Find the **SECTION: Initialize Firebase**.
2.  Uncomment the code block `await Firebase.initializeApp(...)`.
3.  **Hot Restart** the app. Check the console for "Firebase Initialized" (or if it doesn't crash, you're good!).

### ✅ Task 2: Connect the Stream
Go to `lib/poll_store.dart`.
1.  Find `get pollsStream`.
2.  **Comment out** the "LOCAL SIMULATION" block.
3.  **Uncomment** the "FIRESTORE" block.
    *   This switches the data source from a fake list to the real `polls` collection in Cloud Firestore.

### ✅ Task 3: Implement Voting
Still in `lib/poll_store.dart`.
1.  Find `vote(...)`.
2.  **Comment out** the `debugPrint` line.
3.  **Uncomment** the Firestore update logic.
    *   This code uses `FieldValue.increment(1)` to atomically update the vote count on the server!

### ✅ Task 4: Enable Creation (Bonus)
Still in `lib/poll_store.dart`.
1.  Find `createPoll(...)`.
2.  **Uncomment** the Firestore add logic.
    *   Now you can create new polls that everyone else will see instantly!

---

## 🏆 Definition of Done
1.  Run the app on your device/simulator.
2.  You see the **"Which Cloud Service is your favorite?"** poll (from the Cloud, not the local one).
3.  Click a vote option. It should update instantly!
4.  Create a new poll. It should appear for everyone in the room.

**Good luck, and Happy Coding!** 💙
