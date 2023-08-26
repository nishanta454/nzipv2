import 'dart:convert';
import 'dart:io';

Future<void> parseProjectToJson(projectDirectoryPath, outputFilePath) async {
  try {
    Directory projectDirectory = Directory(projectDirectoryPath);
    List<Map<String, dynamic>> filesList = [];

    await _parseDirectory(projectDirectory, projectDirectory, filesList);

    Map<String, dynamic> projectJson = {
      'pname': projectDirectory.path,
      'pcontent': filesList,
    };

    String jsonContent = json.encode(projectJson);

    File outputFile = File(outputFilePath);
    await outputFile.writeAsString(jsonContent);

    print('Project parsed to JSON successfully.');
  } catch (e) {
    print('Error while parsing project to JSON: $e');
  }
}

Future<void> _parseDirectory(
    Directory rootDirectory, Directory currentDirectory, List<Map<String, dynamic>> filesList) async {
  List<String> directoriesToExclude = [
    'target',
    '.mvn',
    '.classpath',
    '.settings',
    'mvnw',
    'mvnw.cmd',
    '.git',
    '.devcontainer',
    '.vscode',
    '.idea',
    '__pycache__',
  ];

  await for (var entity in currentDirectory.list()) {
    if (entity is Directory) {
      if (!directoriesToExclude.contains(entity.uri.pathSegments.last)) {
        await _parseDirectory(rootDirectory, entity, filesList);
      }
    } else if (entity is File) {
      String relativePath = entity.uri.path.replaceFirst(rootDirectory.uri.path, '');

      if (!_shouldIgnore(relativePath, rootDirectory)) {
        String content = await entity.readAsString();

        filesList.add({
          'path': relativePath,
          'content': base64Encode(utf8.encode(content)),
        });
      }
    }
  }
}

bool _shouldIgnore(String filePath, Directory rootDirectory) {
  File gitIgnoreFile = File('${rootDirectory.path}/.gitignore');
  if (gitIgnoreFile.existsSync()) {
    List<String> gitIgnoreRules = gitIgnoreFile.readAsLinesSync();
    for (String rule in gitIgnoreRules) {
      if (rule.trim().isEmpty || rule.startsWith('#')) {
        continue; // Skip comments and empty lines
      }
      if (_isIgnored(rule, filePath)) {
        return true;
      }
    }
  }
  return false;
}

bool _isIgnored(String gitIgnoreRule, String filePath) {
  String pattern = gitIgnoreRule
      .replaceAll('.', '\\.')
      .replaceAll('*', '.*')
      .replaceAll('?', '.')
      .replaceAll('/', '\\/');

  RegExp regex = RegExp('^$pattern\$');
  return regex.hasMatch(filePath);
}