import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:file_picker/file_picker.dart';
import 'package:musicproject/questionare.dart';
import 'package:musicproject/savedsession.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:musicproject/timer.dart';
import 'package:musicproject/upload_screen.dart';
import 'package:musicproject/widgets.dart';
import 'SavedMelodies.dart';
import 'chord.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
class TrackListClass{
  List<Widget> track1 = [];
  List<AudioPlayer> audioPlayers = [];
  List<int> durations = [];
  List<String> filePaths = [];
  void AddTrack1(String file, int milisecondDuration) {
    track1.add(dawObject(100));
    AudioPlayer test = new AudioPlayer();
    test.setSourceDeviceFile(file);
    durations.add(milisecondDuration);
    filePaths.add(file);
    audioPlayers.add(test);


  }
}

class sessionUtility
{
  TrackListClass track1 = new TrackListClass();
  TrackListClass track2 = new TrackListClass();
  bool hasSignedIn = false;
  late Map<String, int> audioFilesandDurationMap = {};
  String currentLocalFile = "";

  Map<String, dynamic>  toJson() {
    Map<String, dynamic> sessionMap = new Map<String, dynamic>();

    sessionMap["track1"] = {
      "filePaths" : track1.filePaths,
      "durations" : track1.durations,
      "widgets" : track1.track1.length
    };

    sessionMap["track2"] = {
      "filePaths" : track2.filePaths,
      "durations" : track2.durations,
      "widgets" : track2.track1.length
    };

    sessionMap["audioFilesandDurationsMap"] = audioFilesandDurationMap;

    sessionMap["currentLocalFile"] = currentLocalFile;

    return sessionMap;
  }
}
