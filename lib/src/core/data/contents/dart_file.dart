class DartFile {
  String dartFile = """
import 'dart:io';

void main() {
  Directory src = Directory('lib/src');
  Directory features = Directory('lib/src/features');
  Directory core = Directory('lib/src/core');
  List<Directory> cleanStructure = [src, features, core];
  for (var dir in cleanStructure) {
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }
  File file = File('lib/main.dart');
  if (!file.existsSync()) {
    file.createSync();
  }
  file.writeAsString('''
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(),
    );
  }
}
''');
}
""";
}
