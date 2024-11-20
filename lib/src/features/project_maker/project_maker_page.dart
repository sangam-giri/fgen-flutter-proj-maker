import 'package:fgen/src/core/enums/platform_enum.dart';
import 'package:fgen/src/core/services/execute.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ProjectMakerPage extends StatefulWidget {
  const ProjectMakerPage({super.key});

  @override
  State<ProjectMakerPage> createState() => _ProjectMakerPageState();
}

class _ProjectMakerPageState extends State<ProjectMakerPage> {
  String selectedFolder = ''; // Variable to store the selected folder path
  late TextEditingController _projectName;
  List<PlatformEnum> platformEnum = [];

  @override
  void initState() {
    super.initState();
    _projectName = TextEditingController();
  }

  // Function to pick the folder
  Future<void> pickFolder() async {
    String? result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      setState(() {
        selectedFolder = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Folder Picker Example')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _projectName,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Project Name'),
            ),
            // Display the selected folder path
            Text(
              selectedFolder.isEmpty
                  ? 'No folder selected'
                  : 'Selected Folder: $selectedFolder',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Button to pick the folder
            ElevatedButton(
              onPressed: pickFolder,
              child: const Text('Pick Folder'),
            ),
            const SizedBox(height: 20),

            // Button to execute the task
            ElevatedButton(
              onPressed: () {
                if (selectedFolder.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select a folder first')),
                  );
                  return;
                }

                Execute.execute(
                  projectName:
                      _projectName.text.toLowerCase().replaceAll(' ', '_'),
                  destDir: selectedFolder,
                );
              },
              child: const Text('Create Project'),
            ),
          ],
        ),
      ),
    );
  }
}
