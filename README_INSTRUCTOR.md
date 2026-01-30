# Flutter + GCP Workshop (Zero-Stress Edition)

This is a **fail-proof** version of the project.
You start with a **Local Simulation** and switch to **Google Cloud** by simply uncommenting code.

## 🏁 Phase 1: Local Simulation (The "Safe" Start)

1. **Run the App**:
   ```bash
   flutter pub get
   flutter run
   ```
2. **What you see**:
   - A poll about "Superpowers".
   - Votes increasing automatically (simulated).
   - You can vote, and the UI updates.

**Goal**: Explain to the audience that this is "Client-Side State" and "Local Simulation".

---

## ☁️ Phase 2: The "Cloud Lift" (The Magic Trick)

Say: *"Now, let's make this real using Google Cloud."*

### 🛠️ Instructor Prep (Do this BEFORE stage!)
Run these commands to link the project `fluttergdgdemoapp`:
```bash
# 1. Configure Firebase
./scripts/setup_firebase.sh

# 2. Seed the Database (Populate Question)
flutter run -t lib/main_admin.dart
```

### 🎬 Live on Stage:
1. **Uncomment Firebase Init** in `lib/main.dart` (Lines 11-13).
2. **Uncomment Firestore Logic** in `lib/poll_store.dart` (Bottom of file).
3. **Restart the App**.

That's it. No manual coding required. 
The database is already pre-filled with the "GCP Service" poll thanks to step 2 above.
