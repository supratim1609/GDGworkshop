# Flutter Live Polling Workshop (Starter)

Welcome to the **Hands-on Flutter Workshop**! 
Today you will build a real-time polling app *without* a backend server, allowing you to focus purely on Flutter logic and UI state mastery.

## 🎯 What You Will Build
A beautifully simple app where users can:
- See a pre-defined poll question.
- Vote on an option.
- See "Live" updates as other "simulated" users vote in real-time.

## 🚀 How to Run
1. **Get Dependencies**:
   Open your terminal in this folder and run:
   ```bash
   flutter pub get
   ```

2. **Run the App**:
   Start an Android Emulator or iOS Simulator, then run:
   ```bash
   flutter run
   ```

## 🛠️ Your Mission (Live Coding Steps)
You will find **TODO** comments in the code. Your goal is to make the app interactive!

### 1. `poll_model.dart`
- **Task**: Implement the `totalVotes` getter.
- **Why**: We need the total sum to calculate percentages.

### 2. `poll_store.dart`
- **Task**: Implement the `vote(String option)` method.
- **Why**: Tapping a button currently does nothing. You need to update the data map.

### 3. `poll_screen.dart`
- **Task**: Initialize a `Timer.periodic`.
- **Why**: "Live" updates won't show up on screen unless you tell the UI to rebuild periodically.
- **Task**: Calculate `percentage` for the progress bars.
- **Why**: Displaying `5/10` is okay, but a progress bar needs a value between `0.0` and `1.0`.

## 📂 Project Structure
- `main.dart` -> App entry point.
- `poll_screen.dart` -> The beautiful UI (Material 3).
- `poll_store.dart` -> The "Brain" (Holds data + Simulation logic).
- `poll_model.dart` -> The Data Structure.

## 🆘 Troubleshooting
- **Updates not showing?** Did you remember to call `setState()` inside your Timer?
- **Crash on percentage?** Did you divide by zero? (Check if `totalVotes` is 0!)
