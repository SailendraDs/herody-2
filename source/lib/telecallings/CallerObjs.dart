import 'dart:convert';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:herody/telecallings/callerInfo.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:herody/globaldata.dart' as g;
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class CallerObjs extends StatefulWidget {
  final String id;
  final int statusid;
  final String title;
  final String outcomes;
  final String script_des;
  final String audio_des;
  final String audio_file;
  final String obj_des;
  final String file;
  final String script_img;
  final String last_date;

  const CallerObjs(
      {Key key,
      this.id,
      this.statusid,
      this.title,
      this.outcomes,
      this.script_des,
      this.audio_des,
      this.audio_file,
      this.obj_des,
      this.file,
      this.script_img,
      this.last_date});
  @override
  State<StatefulWidget> createState() => new _CallerObjsState(
      id: id,
      statusid: statusid,
      title: title,
      outcomes: outcomes,
      audio_des: audio_des,
      audio_file: audio_file,
      script_des: script_des,
      obj_des: obj_des,
      file: file,
      script_img: script_img,
      last_date: last_date);
}

class _CallerObjsState extends State<CallerObjs> {
  _CallerObjsState(
      {Key key,
      this.id,
      this.statusid,
      this.title,
      this.outcomes,
      this.script_des,
      this.audio_des,
      this.audio_file,
      this.obj_des,
      this.file,
      this.script_img,
      this.last_date});
  final _formKey = new GlobalKey<FormState>();
  final String id;
  final int statusid;
  final String title;
  final String outcomes;
  final String script_des;
  final String audio_des;
  final String audio_file;
  final String obj_des;
  final String file;
  final String script_img;
  final String last_date;
  int sid = -2;

  var data;
  var response;
  var tdata;
  var userdata;
  var applydata;
  bool onclick = false;
  bool servererror = false;
  bool refresh = false;
  bool active = false;
  //Uint8List image = base64.decode(script_img.split(',').last);
  // String _audiobase64;

  // void initState() {
  //   super.initState();
  // }

  // Widget audio_descp() {
  //   if (_audiobase64 == null) return new Container();
  //   Uint8List bytes = Base64Codec().decode(_audiobase64);

  // }

  Widget logoimage() {
    if (script_img == null) return new Container();
    Uint8List bytes = Base64Codec().decode(script_img.split(",").last);
    return Container(
      child: Image.memory(
        bytes,
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.0, 15, 16.0, 15),
        child: SizedBox(
          height: 50.0,
          // ignore: deprecated_member_use
          child: new RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Color(0xff00d68f),
              child: new Text('Start project',
                  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CallerInfos(
                          id: id,
                          title: title,
                          objDes: obj_des,
                          last_date: last_date,
                          outcomes: outcomes),
                    ));
              }),
        ));
  }

  AudioPlayer _audioPlayer = AudioPlayer();

  bool isPlaying = false;
  String currentTime = "00:00";
  String completeTime = "00:00";
  @override
  void initState() {
    super.initState();
    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currentTime = duration.toString().split(".")[0];
      });
    });
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        completeTime = duration.toString().split(".")[0];
      });
    });
  }

  _expansionPanel() {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.blueGrey[50],
            child: ListTile(
              title: Text(title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  )),
            ),
          ),
        ),
        ListTile(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 1, 25),
            child: Icon(
              Icons.menu_book_outlined,
              color: Color(0xff00d68f),
            ),
          ),
          title: Text(
            "Call script\n",
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Column(
            children: [
              Container(
                child: ListTile(
                  title: Html(
                    data: script_des.toString(),
                    onLinkTap: (url) {
                      launch(url);
                    },
                    customRender: (node, children) {
                      if (node is dom.Element) {
                        switch (node.localName) {
                          case "custom_tag": // using this, you can handle custom tags in your HTML
                            return Column(children: children);
                        }
                      }
                    },
                  ),
                  // subtitle: logoimage(),
                ),
              ),
              /*  Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: MemoryImage(
                            Base64Codec().decode(script_img.split(",").last)),
                        fit: BoxFit.fill)),

                // Image.memory(base64.decode(script_img.split(',').last)),
              ),*/
            ],
          ),
        ),
        Divider(
          thickness: 2,
        ),
        audio_file != null
            ? Column(
                children: [
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 1, 25),
                      child: Icon(
                        Icons.volume_up,
                        color: Color(0xff00d68f),
                      ),
                    ),
                    title: Text(
                      "Audio Demo\n",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      children: [
                        ListTile(
                          title: Html(
                            data: audio_des.toString(),
                            onLinkTap: (url) {
                              launch(url);
                            },
                            customRender: (node, children) {
                              if (node is dom.Element) {
                                switch (node.localName) {
                                  case "custom_tag": // using this, you can handle custom tags in your HTML
                                    return Column(children: children);
                                }
                              }
                            },
                          ),
                          subtitle: Container(
                            width: 280,
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.greenAccent.shade400,
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  "Play",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  icon: Icon(isPlaying
                                      ? Icons.pause
                                      : Icons.play_arrow),
                                  onPressed: () {
                                    if (isPlaying) {
                                      _audioPlayer.play(audio_file);
                                      _audioPlayer.pause();
                                      setState(() {
                                        isPlaying = false;
                                      });
                                    } else {
                                      _audioPlayer.resume();
                                      setState(() {
                                        isPlaying = true;
                                      });
                                    }
                                  },
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                IconButton(
                                  icon: Icon(Icons.stop),
                                  onPressed: () {
                                    _audioPlayer.stop();
                                    setState(() {
                                      isPlaying = false;
                                    });
                                  },
                                ),
                                /*Text(
                                    currentTime,
                                    style: TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                  Text("|"),
                                  Text(
                                    completeTime,
                                    style: TextStyle(fontWeight: FontWeight.w300),
                                  ),*/
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                ],
              )
            : Container(),
        ListTile(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 1, 25),
            child: Icon(
              Icons.widgets,
              color: Color(0xff00d68f),
            ),
          ),
          title: Text(
            "Call Objective\n",
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: ListTile(
              title: Html(
            data: obj_des.toString(),
            onLinkTap: (url) {
              launch(url);
            },
            customRender: (node, children) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "custom_tag": // using this, you can handle custom tags in your HTML
                    return Column(children: children);
                }
              }
            },
          )),
        ),
        Divider(
          thickness: 2,
        ),
        ListTile(
          leading: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 1, 25),
            child: Icon(
              Icons.assignment,
              color: Color(0xff00d68f),
            ),
          ),
          title: Text(
            "Call outcome\n",
            style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: ListTile(
              title: Html(
            data: outcomes.toString().replaceAll("{", "").replaceAll("}", ""),
            onLinkTap: (url) {
              launch(url);
            },
            customRender: (node, children) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "custom_tag": // using this, you can handle custom tags in your HTML
                    return Column(children: children);
                }
              }
            },
          )),
        ),
        showPrimaryButton()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // image = base64.decode(script_img.split(',').last);
    print("-----------------");
    return MaterialApp(
      title: "Herody",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(title == null ? "" : title),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.indigo[900],
        ),
        body: _expansionPanel(),
      ),
    );
  }
}
