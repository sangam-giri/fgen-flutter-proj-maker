import 'dart:io';
import 'package:fgen/src/core/data/contents/dart_file.dart';
import 'package:fgen/src/core/enums/platform_enum.dart';
import 'package:fgen/src/core/services/generator.dart';
import 'package:path_provider/path_provider.dart';

class Execute {
  Execute._();

  static Future<void> execute(
      {required String projectName,
      required String destDir,
      List<PlatformEnum>? platforms,
      String? packageName}) async {
    String createCommand = 'call flutter create';

    if (packageName != null) {
      createCommand = '--org $packageName';
    }
    if (platforms != null && platforms.isNotEmpty) {
      List<String> selectedPlatforms = [];
      for (var platform in platforms) {
        selectedPlatforms.add(platform.key);
      }
      createCommand =
          '$createCommand --platforms ${selectedPlatforms.join(',')}';
    }
    createCommand = '$createCommand $projectName';

    // Generate the Dart script to create the folder inside the Flutter project
    String script = dartFile;

    // Create a temporary Dart file to execute later
    Directory tempDir = await getTemporaryDirectory();
    File tempDartFile = File('${tempDir.path}/temp_dart.dart');
    await tempDartFile.writeAsString(script);

    // Generate the batch script that will handle the folder creation and Dart script execution
    String command = '''
@echo off
setlocal

REM Set target directory and project details
set "targetDirectory=$destDir"
set "fullPath=%targetDirectory%"

REM Check if the folder already exists
if not exist "%fullPath%" (
    mkdir "%fullPath%"
    echo Folder created successfully: %fullPath%
)

REM Navigate to the new directory and create the Flutter project
cd /d "%fullPath%"
$createCommand
cd $projectName

REM Add internal folder and execute Dart script
dart ${tempDartFile.path}
echo Dart script executed successfully.

endlocal
''';
    // Execute the batch command
    await BatExecuter.execute(command, tempDartFile);
  }
}
