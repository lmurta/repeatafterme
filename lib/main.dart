import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
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
                  flex: 5,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void pageChanged(int index) {
    print("index:" + index.toString());
    setState(() {
      wordText = Text(imageData[index]['word'], style: textStyle);
    });
  }
}
