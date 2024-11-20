import 'dart:io';
import 'package:path_provider/path_provider.dart';

class BatExecuter {
  BatExecuter._();

  static Future<void> execute(String command, File dartFile) async {
    try {
      // Create a temporary batch file
      Directory tempDir = await getTemporaryDirectory();
      File tempBatchFile = File('${tempDir.path}/temp_script.bat');
      await tempBatchFile.writeAsString(command);

      // Execute the batch script
      var result = await Process.run('cmd', ['/c', tempBatchFile.path]);
      print(result.stdout);

      // Handle errors
      if (result.exitCode != 0) {
        print('Error: ${result.stderr}');
      }

      // Clean up temporary files
      await tempBatchFile.delete();
      await dartFile.delete();
    } catch (e) {
      print('Error executing batch script: $e');
    }
  }
}
