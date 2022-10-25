import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyFiles());
}

class MyFiles extends StatefulWidget {
  const MyFiles({super.key});

  @override
  State<MyFiles> createState() => _MyFilesState();
}

class _MyFilesState extends State<MyFiles> {
  Future<String> _pickfile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) return '';
    String path = result.files.first.path as String;
    File f = File(path);
    // print(f.readAsStringSync());
    return path;
  }

  Future<String> upload(File imageFile) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("http://127.0.0.1:8000/");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('img', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) async {
      var data = jsonDecode(value)['status'];
      var f = File(
          'C:/Users/Sanjarbek/Documents/frontend_git/flutterdesktop/gray.png');
      f.writeAsStringSync(data);
      print('done');
    });
    return '';
  }

  bool img = false;
  String path = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              img ? Image(image: AssetImage('/gray.png')) : Container(),
              TextButton(
                onPressed: () async {
                  path = await _pickfile();
                  upload(File(path));
                  setState(() {
                    img = !img;
                  });
                },
                child: const Text('get files'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
