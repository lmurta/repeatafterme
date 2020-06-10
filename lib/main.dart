import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

enum TtsState { playing, stopped }

class MyAppState extends State<MyApp> {
  FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;
  String language = "en-US";
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  String _newVoiceText;

  Icon iconWord = Icon(
    Icons.local_library,
    //size: 20.0,
  );
  Icon iconType = Icon(Icons.keyboard);
  Icon iconSay = Icon(Icons.sms);
  var wordIndex = 0;
  var imageData = [];
  TextStyle textStyle = TextStyle(
      //fontSize: 20.0,
      //color: const Color(0xFF108caa),
      //fontWeight: FontWeight.w500,
      fontFamily: "Roboto");
  Text wordText = Text("Repeat after me:");

  TextField textFieldType = TextField(
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      isDense: true,
      contentPadding: const EdgeInsets.all(3.0),
    ),
    autocorrect: false,
    enableSuggestions: false,
    keyboardType: TextInputType.text,
    style: TextStyle(
        // color: Colors.red,
        //  fontWeight: FontWeight.w300,
        ),
  );

  @override
  initState() {
    super.initState();
    initTts();
  }
  initTts() {
    flutterTts = FlutterTts();

    //_getLanguages();

    flutterTts.setStartHandler(() {
      setState(() {
        print("playing"+ _newVoiceText);
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Repeat After Me"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            // Use future builder and DefaultAssetBundle to load the local JSON file
            children: [
              FutureBuilder(
                  future: DefaultAssetBundle.of(context)
                      .loadString('assets/lessons.json'),
                  builder: (context, snapshot) {
                    // Decode the JSON
                    if (snapshot.hasData) {
                      imageData = json.decode(snapshot.data.toString());
                      //pageChanged(0);
                      //print(imageData.toString());
                      return GFCarousel(
                        autoPlay: false,
                        items: imageData.map((img) {
                          return Container(
                            margin: EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              child: Image.asset(
                                "assets/" + img['image'].toString() + ".jpg",
                                fit: BoxFit.cover,
                                width: 1000.0,
                              ),
                            ),
                          );
                        }).toList(),
                        onPageChanged: pageChanged,
                      );
                      //pageChanged(0);
                    } else {
                      return new CircularProgressIndicator();
                    }
                  }),
              Row(children: <Widget>[
                Expanded(
                  child: iconWord,
                  flex: 2,
                ),
                Expanded(
                  child: wordText,
                  flex: 5,
                ),
              ]),
              Row(children: <Widget>[
                Expanded(
                  child: iconSay,
                  flex: 2,
                ),
                Expanded(
                  child: wordText,
                  flex: 5,
                ),
              ]),
              Row(children: <Widget>[
                Expanded(
                  child: iconType,
                  flex: 2,
                ),
                Expanded(
                  child: textFieldType,
                  flex: 4,
                ),
                Expanded(
                  child: Text(''),
                  flex: 1,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Future _speak() async {
    //await flutterTts.setVolume(volume);
    //await flutterTts.setSpeechRate(rate);
    //await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText.isNotEmpty) {
        var result = await flutterTts.speak(_newVoiceText);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  void pageChanged(int index) {
    //print("index:" + index.toString());
    setState(() {
      wordText = Text(imageData[index]['word'], style: textStyle);
    });
    _newVoiceText = imageData[index]['word'];
    _speak();
  }
}
