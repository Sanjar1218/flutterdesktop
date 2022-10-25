import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyFiles());
}

class MyFiles extends StatelessWidget {
  const MyFiles({super.key});

  void _pickfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    String path = result.files.first.path as String;
    File f = File(path);
    print(f.readAsStringSync());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () {
              _pickfile();
            },
            child: const Text('get files'),
          ),
        ),
      ),
    );
  }
}
