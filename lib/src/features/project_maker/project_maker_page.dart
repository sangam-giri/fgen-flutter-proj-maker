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
  String selectedFolder = '';
  late TextEditingController _projectNameController;
  late TextEditingController _packageNameController;

  bool _showPlatformSelection = false;
  bool _showPackageNameField = false;

  final Map<PlatformEnum, bool> _platformSelection = {
    PlatformEnum.android: false,
    PlatformEnum.iOS: false,
    PlatformEnum.macOS: false,
    PlatformEnum.linux: false,
    PlatformEnum.windows: false,
  };

  @override
  void initState() {
    super.initState();
    _projectNameController = TextEditingController();
    _packageNameController = TextEditingController();
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _packageNameController.dispose();
    super.dispose();
  }

  Future<void> pickFolder() async {
    String? result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      setState(() {
        selectedFolder = result;
      });
    }
  }

  bool _isValidProjectName(String name) {
    final RegExp projectNameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    return projectNameRegex.hasMatch(name);
  }

  bool _isValidPackageName(String name) {
    final RegExp packageNameRegex = RegExp(r'^[a-z]+(\.[a-z][a-z0-9]*)+$');
    return packageNameRegex.hasMatch(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Project'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Project Info Section
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Project Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _projectNameController,
                      decoration: const InputDecoration(
                        labelText: 'Project Name',
                        hintText: 'Enter a valid project name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            // Platform Selection Section
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Platform Selection',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<bool>(
                      value: _showPlatformSelection,
                      items: const [
                        DropdownMenuItem(
                            value: false,
                            child: Text('Do not select platforms')),
                        DropdownMenuItem(
                            value: true, child: Text('Select platforms')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _showPlatformSelection = value ?? false;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Choose Platforms?',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_showPlatformSelection)
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: _platformSelection.keys.map((platform) {
                          return FilterChip(
                            label: Text(platform.name),
                            selected: _platformSelection[platform]!,
                            onSelected: (selected) {
                              setState(() {
                                _platformSelection[platform] = selected;
                              });
                            },
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),

            // Package Name Section
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Package Name',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<bool>(
                      value: _showPackageNameField,
                      items: const [
                        DropdownMenuItem(
                            value: false,
                            child: Text('Do not add package name')),
                        DropdownMenuItem(
                            value: true, child: Text('Add package name')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _showPackageNameField = value ?? false;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Specify Package Name?',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_showPackageNameField)
                      TextField(
                        controller: _packageNameController,
                        decoration: const InputDecoration(
                          labelText: 'Package Name',
                          hintText: 'e.g., com.example',
                          border: OutlineInputBorder(),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Destination Folder Section
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        selectedFolder.isEmpty
                            ? 'No folder selected'
                            : 'Selected Folder: $selectedFolder',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: pickFolder,
                      icon: const Icon(Icons.folder_open),
                    ),
                  ],
                ),
              ),
            ),

            // Create Project Button
            ElevatedButton(
              onPressed: () {
                if (_projectNameController.text.isEmpty ||
                    !_isValidProjectName(_projectNameController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Invalid project name. Use only alphanumeric characters and underscores.'),
                    ),
                  );
                  return;
                }

                if (_showPackageNameField &&
                    (_packageNameController.text.isEmpty ||
                        !_isValidPackageName(_packageNameController.text))) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Invalid package name. Use a valid format like com.example.app.'),
                    ),
                  );
                  return;
                }

                if (selectedFolder.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please select a destination folder'),
                    ),
                  );
                  return;
                }

                Execute.execute(
                  projectName: _projectNameController.text,
                  destDir: selectedFolder,
                  packageName: _showPackageNameField
                      ? _packageNameController.text
                      : null,
                  platforms: _showPlatformSelection
                      ? _platformSelection.entries
                          .where((entry) => entry.value)
                          .map((entry) => entry.key)
                          .toList()
                      : [],
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Create Project',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
