import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';





class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File? _selectedFile;
  String audioFile = '';
  final player = AudioPlayer();
  AudioCache audioCache = AudioCache();


  void initState() {
    super.initState();

    /// Compulsory


    // audioCache = AudioCache(prefix: tempDir.toString());




  }


  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mid'],
    );

    if (result != null) {

      _selectedFile = File(result.files.single.path!);

    }
  }

  Future<void> _uploadFile() async {
    var url = 'https://priceyconcreteemacs.jackwagner7.repl.co'; // AWS/ec2 host
    print(url);
    Map<String, String> headers = {
      "Connection": "Keep-Alive",
      "Keep-Alive": "timeout=5, max=1000"
    };

    http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse('$url/upload')); //post request to URL/analize
    request.headers.addAll(headers);
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        _selectedFile!.path,
      ),
    );

    request.send().then((r) async {
      print(r.statusCode);

      if (r.statusCode == 200) {
        // Save audio locally
        print("sucess?");
        Directory tempDir = await getTemporaryDirectory();
        print(tempDir);
        File localAudioFile = File('${tempDir.path}/audio.midi');
        await localAudioFile.writeAsBytes(await r.stream.toBytes());

        setState(() {
          audioFile = localAudioFile.path;
          print(audioFile);
          print(player.source);
          player.setSourceDeviceFile(audioFile);
          player.resume();
        });
      }
    });
  }

  Future<Duration?> _getAudioDuration() async {
    player.setSourceDeviceFile(audioFile);

    Duration? audioDuration = await Future.delayed(
      Duration(seconds: 2),
          () => player.getDuration(),
    );

    return audioDuration;
  }
  String getTimeString(int milliseconds) {
    if (milliseconds == null) milliseconds = 0;
    String minutes =
        '${(milliseconds / 60000).floor() < 10 ? 0 : ''}${(milliseconds / 60000).floor()}';
    String seconds =
        '${(milliseconds / 1000).floor() % 60 < 10 ? 0 : ''}${(milliseconds / 1000).floor() % 60}';
    return '$minutes:$seconds'; // Returns a string with the format mm:ss
  }


  /// Optional
  Widget getLocalFileDuration() {
    return FutureBuilder<Duration?>(
      future: _getAudioDuration(),
      builder: (BuildContext context, AsyncSnapshot<Duration?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('No Connection...');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('Waiting...');
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            return Text(getTimeString(snapshot.data as int));
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('MIDI File Upload'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _selectFile,
              child: Text('Select MIDI File'),
            ),
            SizedBox(height: 16),
            if (_selectedFile != null)
              Text('Selected File: ${_selectedFile!.path}'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text('Upload File'),
            ),
          ],
        ),
      ),
    );
  }
}