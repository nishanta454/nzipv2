import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'parse.dart'; // Import the parse.dart file
import 'recreate.dart'; // Import the recreate.dart file

void main() {
  runApp(Nzip());
}

class Nzip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Project Tool',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String projectPath = '';
  String outputPath = '';

  Future<void> _pickProjectFolder() async {
    String? pickedPath = await FilePicker.platform.getDirectoryPath();
    if (pickedPath != null) {
      setState(() {
        projectPath = pickedPath;
      });
    }
  }

  Future<void> _pickOutputFolder() async {
    String? pickedPath = await FilePicker.platform.getDirectoryPath();
    if (pickedPath != null) {
      setState(() {
        outputPath = pickedPath;
      });
    }
  }

  Future<void> _parseProjectToJson() async {
    if (projectPath.isNotEmpty && outputPath.isNotEmpty) {
      await parseProjectToJson(projectPath, outputPath);
      print('Parsing complete!');
    } else {
      print('Please select both project folder and output JSON folder.');
    }
  }

  Future<void> _recreateProjectFromJson() async {
    String jsonFilePath = ''; // Provide the path to the JSON file
    String outputDirectoryPath = ''; // Provide the output directory path

    if (jsonFilePath.isNotEmpty && outputDirectoryPath.isNotEmpty) {
      await recreateProjectFromJson(jsonFilePath, outputDirectoryPath);
      print('Recreation complete!');
    } else {
      print('Please select JSON file and output directory paths.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Tool'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickProjectFolder,
              child: Text('Select Project Folder'),
            ),
            Text('Project Folder: $projectPath'),
            ElevatedButton(
              onPressed: _pickOutputFolder,
              child: Text('Select Output JSON Folder'),
            ),
            Text('Output JSON Folder: $outputPath'),
            ElevatedButton(
              onPressed: _parseProjectToJson,
              child: Text('Parse Project to JSON'),
            ),
            ElevatedButton(
              onPressed: _recreateProjectFromJson,
              child: Text('Recreate Project from JSON'),
            ),
          ],
        ),
      ),
    );
  }
}