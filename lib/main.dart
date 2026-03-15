import 'package:flutter/material.dart';
import 'widget_lab.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ArchitektApplication());
}

class ArchitektApplication extends StatelessWidget {
  const ArchitektApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project: Architekt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const ArchitektLab(),
    );
  }
}
