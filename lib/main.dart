import 'package:flutter/material.dart';

import 'package:speech_recognition/speech_recognition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Speech to Text",
      theme: ThemeData(
        primaryColor: Colors.pink,
      ),
      home: VoiceHome(),
    );
  }
}

class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {

  SpeechRecognition _speechRecognition;

  bool _isAvailable = false;
  bool _isListening = false;

  String resultText = "";

  @override
  void initState() {
    super.initState();
    _initSpeechRecognizer();
  }

  void _initSpeechRecognizer() {

    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
      ( bool result ) => setState(() => _isAvailable = result ),
    );

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
      (String speech) => setState(() => resultText = speech),
    );

    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => _isListening = false),
    );

    _speechRecognition.activate().then(
      (result) => setState(() => _isAvailable = result),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speech Recognition"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  child: Icon(Icons.cancel),
                  mini: true,
                  backgroundColor: Colors.deepOrange,
                  onPressed: (){
                    print("pressed");
                    if(_isListening)
                      _speechRecognition.cancel().then(
                        (result) => setState(() {
                          _isListening = result;
                          result = '';
                        }),
                      );
                  },
                ),
                FloatingActionButton(
                  child: Icon(Icons.mic),
                  backgroundColor: Colors.pinkAccent,
                  onPressed: (){
                    print("pressed");
                    if(_isAvailable && !_isListening)
                      _speechRecognition
                        .listen(locale: 'en_US')
                        .then((result) => print('$result'));
                  },
                ),
                FloatingActionButton(
                  child: Icon(Icons.stop),
                  mini: true,
                  backgroundColor: Colors.deepPurple,
                  onPressed: (){
                    if(_isListening)
                      _speechRecognition.stop().then(
                        (result) => setState(() => _isListening = result),
                      );
                  },
                )
              ],
            ),

            SizedBox(
              height: 10.0,
            ),
            Container(
              margin: EdgeInsets.only(left: 5.0, right: 5.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.pinkAccent[100],
                borderRadius: BorderRadius.circular(5.0)
              ),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Text(
                resultText,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}