import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:herody/globaldata.dart' as g;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CallFeedback extends StatefulWidget {
  final String title;
  final String id;
  final String objDes;
  final String caller_name;
  final String caller_phone;
  final String last_date;
  final String outcomes;

  // final String datas;

  const CallFeedback(
      {this.id,
      this.title,
      this.objDes,
      this.caller_name,
      this.caller_phone,
      this.last_date,
      this.outcomes});
  @override
  State<StatefulWidget> createState() => new _CallFeedbackState(
      id: id,
      title: title,
      obj_des: objDes,
      caller_name: caller_name,
      caller_phone: caller_phone,
      last_date: last_date,
      outcomes: outcomes);

  static fromJson(collectionElement) {}
}

class _CallFeedbackState extends State<CallFeedback> {
  var count = 1;

  _CallFeedbackState(
      {this.id,
      this.title,
      this.obj_des,
      this.caller_name,
      this.caller_phone,
      this.last_date,
      this.outcomes});

  final String title;
  final String id;
  final String obj_des;
  final String caller_name;
  final String caller_phone;
  final String last_date;
  final String outcomes;

  int sid = -2;

  Response feedback_response;
  var statuscode = 201;
  var tdata;
  var userdata;
  var applydata;
  var applicationData;
  var responseData;
  var dataResponse;
  var myCampainsData;
  var myCampainsData2;
  var callFeedbackData;
  bool onclick = false;
  bool servererror = false;
  bool refresh = false;

  var name = "";
  var detailId = "";
  var language = "";
  var trackingLink = "";
  var region = "";
  var mobileNumber = "";
  var desc = "";
  int callduration = 00;
  var timer;
  var second_spoken = "00";
  var minute_spoken = "00";
  var callType;
  int _value = 1;
  String _chosenValue;
  bool _feedbackButton = false;
  final _feedbackController = TextEditingController();
  var _progressBarActive = false;
  /* _callLogs() async {
    Iterable<CallLogEntry> entries = await CallLog.get();

    for (var item in entries) {
      print("number: " + item.number);
      print("duration: " + item.duration.toString());
      print("callType: " + item.callType.toString());
      print("Timestamp: " + item.timestamp.toString());
      print("name: " + item.name);
      callType = item.callType.toString();
    }
  }*/

  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  final value1 = StopWatchTimer.getMilliSecFromSecond(60 * 60);
  final stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    onChange: (value) {
      //print('onChange $value');
      final displayTime = StopWatchTimer.getDisplayTime(value);
      //print('displayTime $displayTime');
    },
    // onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    //m monChangeRawMinute: (value) => print('onChangeRawMinute $value'),
  );

  void feedbackdata() async {
    setState(() {
      onclick = true;
    });
    String url = g.preurl + "telecalling/feedback";
    Response response = await post(url, body: {"id": id, "uid": g.uid});
    setState(() {
      callFeedbackData = json.decode(response.body)["response"];
    });
  }

  bool timer_status = true;
  Widget callFeedback() {
    if (timer_status) {
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    }
    //  this._callLogs();
    return Container(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
            child: Container(
              height: 45,
              color: Colors.grey[300],
              child: ListTile(
                title: Text("$title",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: Container(
              height: 49,
              color: Colors.grey[300],
              child: ListTile(
                title: Text("End Date:\n$last_date".replaceAll("00:00:00", ""),
                    style: TextStyle(
                      fontSize: 13,
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 15),
            child: Container(
              // height: 50,
              color: Colors.grey[300],
              child: ListTile(
                title: Text(
                    "$obj_des\n".replaceAll("<p>", "").replaceAll("</p>", ""),
                    style: TextStyle(
                      fontSize: 13,
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: Container(
              color: Color(0xffd7faef),
              height: 30,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                    width: MediaQuery.of(context).size.width - 260,
                    child: Text(
                      "Session timer",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
              child: Container(
                color: Color(0xffd7faef),
                height: 130,
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 0, 5),
                  width: MediaQuery.of(context).size.width - 160,
                  child: Column(
                    children: [
                      StreamBuilder<int>(
                        stream: _stopWatchTimer.rawTime,
                        initialData: 0,
                        builder: (context, snap) {
                          final value = snap.data;
                          timer = value / 1000;
                          print(timer);
                          second_spoken = timer.toStringAsFixed(0);
                          if (int.parse(second_spoken) >= 60) {
                            minute_spoken = (int.parse(second_spoken) / 60)
                                .floor()
                                .toStringAsFixed(0);
                            second_spoken = (int.parse(second_spoken) % 60)
                                .floor()
                                .toStringAsFixed(0);
                          }
                          final displayTime =
                              StopWatchTimer.getDisplayTime(value);
                          return Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  displayTime,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              /*  Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(
                                  value.toString(),
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontFamily: 'Helvetica',
                                      fontWeight: FontWeight.w400),
                                ),
                              ),*/
                            ],
                          );
                        },
                      ),
                      ElevatedButton(
                        child: Text(
                          " End Session ",
                          style: TextStyle(color: Colors.red),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          padding: const EdgeInsets.all(4),
                          shape: const StadiumBorder(),
                        ),
                        onPressed: () {
                          _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                          timer_status = false;
                          if (count == 1) {
                            _feedbackButton = true;
                            count = count + 1;
                          }
                          setState(() {
                            minute_spoken = minute_spoken;
                            second_spoken = second_spoken;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              )),
          Row(
            children: [
              /* Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 10, 10),
                child: Container(
                  width: 155,
                  height: 100,
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Text(" Project earnings",
                                style: TextStyle(
                                  color: Color(0xff00d68f),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                )),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            CircleAvatar(
                              foregroundImage:
                                  AssetImage("assets/rupee_icon.png"),
                              radius: 13,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("₹" + widget.outcomes,
                                style: TextStyle(
                                  color: Color(0xff00111f),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),*/
              SizedBox(width: 15),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: Container(
                  width: 150,
                  height: 100,
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Text(" Minutes spoken",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                )),
                            SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              foregroundImage: AssetImage("assets/clock.png"),
                              radius: 15,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${minute_spoken}:${second_spoken}",
                              style: TextStyle(
                                  color: Colors.redAccent, fontSize: 20),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          showPrimaryButton()
        ],
      ),
    );
  }

  Future sendfeedback() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return SingleChildScrollView(
              child: AlertDialog(
                title: Center(child: Text("Feedback")),
                content: Container(
                  child: Column(
                    children: [
                      Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/logo.png'),
                            fit: BoxFit.fill,
                          ),
                          shape: BoxShape.rectangle,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 3.0, color: Colors.blue),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            Card(
                              color: Colors.red.shade100,
                              elevation: 10,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          "   ID:",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "\t$id",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          "   User ID:",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "\t${g.uid}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          "   Caller Name:",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "\t${caller_name}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Row(
                                      children: [
                                        Text(
                                          "   caller Phone:",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "\t${caller_phone}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  height: 78,
                                  child: Card(
                                    elevation: 8,
                                    color: Colors.blue.shade100,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "  Session Time  ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            _value == 1
                                                ? "\t${minute_spoken}:${second_spoken} min"
                                                : "00:00",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                Card(
                                  elevation: 8,
                                  color: Colors.blue.shade100,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "   Call Status    ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        child: Scrollbar(
                                          isAlwaysShown: true,
                                          child: DropdownButton(
                                              hint: Text("call status"),
                                              iconSize: 30,
                                              elevation: 20,
                                              value: _value,
                                              items: [
                                                DropdownMenuItem(
                                                  child: Text(
                                                    "  Connected  ",
                                                    style: TextStyle(
                                                        fontFamily: "Josefin",
                                                        fontSize: 13),
                                                  ),
                                                  value: 1,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text(
                                                    "  Missed  ",
                                                    style: TextStyle(
                                                        fontFamily: "Josefin",
                                                        fontSize: 13),
                                                  ),
                                                  value: 2,
                                                ),
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  _value = value;
                                                });
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                //),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Visibility(
                              visible: _value == 1 ? true : false,
                              child: TextField(
                                controller: _feedbackController,
                                decoration: InputDecoration(
                                  // errorText: errorText,
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                        color: Colors.red, width: 2.0),
                                  ),
                                  hintText: "Review",
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 2.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 1.0),
                                  ),
                                ),
                                maxLines: 3,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      //_progressBarActive == false
                      //  ?
                      ElevatedButton(
                          style: ButtonStyle(
                              elevation:
                                  MaterialStateProperty.all<double>(10.0),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          onPressed: () async {
                            //  _makingPhoneCall(number);
                            setState(() {
                              _progressBarActive = true;
                            });

                            String url = g.preurl + "telecalling/feedback";
                            while (statuscode != 200) {
                              if (_value == 1) {
                                feedback_response = await http.post(url, body: {
                                  "id": "$id".toString(),
                                  "uid": "${g.uid}".toString(),
                                  "call_status": "connected",
                                  "caller_name": caller_name.toString(),
                                  "caller_phone": caller_phone.toString(),
                                  "session_time":
                                      "\t${minute_spoken}:${second_spoken} min"
                                          .toString(),
                                  "feedback":
                                      _feedbackController.text.toString()
                                });
                                print(
                                    'Response status: ${feedback_response.statusCode}-----------------------------');
                              } else {
                                feedback_response = await http.post(url, body: {
                                  "id": "$id".toString(),
                                  "uid": "${g.uid}".toString(),
                                  "call_status": "missed",
                                  "caller_name": caller_name.toString(),
                                  "caller_phone": caller_phone.toString(),
                                  "session_time": "00:00",
                                });
                                print(
                                    'Response status: ${feedback_response.statusCode}-------------------------');
                              }
                              if (feedback_response.statusCode == 200) {
                                statuscode = 200;
                              }
                            }
                            setState(() {
                              _feedbackButton = false;
                            });
                            try {
                              setState(() {
                                applydata = json.decode(feedback_response.body)[
                                    "feedback_response"];
                              });
                            } catch (e) {
                              print(e);
                            }

                            print(applydata);
                            print(
                                'Response status: ${feedback_response.statusCode}');
                            print(
                                'Response header: ${feedback_response.headers}');
                            print('Response body: ${feedback_response.body}');
                            if (feedback_response.statusCode == 200) {
                              Fluttertoast.showToast(
                                  msg: "Feedback submitted succesfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  backgroundColor: Colors.greenAccent.shade400,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              _feedbackButton = false;
                            } else {
                              Fluttertoast.showToast(
                                  msg:
                                      "Feedback not submitted, Try again after some time ",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.CENTER,
                                  backgroundColor: Colors.red.shade500,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              _feedbackButton = false;
                            }
                            Navigator.of(context).pop();
                            setState(() {
                              _progressBarActive = false;
                            });
                          },
                          child: _progressBarActive == false
                              ? Text(
                                  "Send Feedback",
                                  style: TextStyle(color: Colors.blue),
                                )
                              : Text(
                                  "Sending.....",
                                  style: TextStyle(color: Colors.pink),
                                ))
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(2.0),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shadowColor:
                              MaterialStateProperty.all<Color>(Colors.white)),
                      onPressed: () async {
                        setState(() {
                          _feedbackButton = false;
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        "ok",
                        style: TextStyle(color: Colors.blue),
                      ))
                ],
              ),
            );
          });
        });
  }

  void showConsole3() {
    print("null error 3");
  }

  Widget showPrimaryButton() {
    // PhoneCall phoneCall;
    // this.waitForCompletion(phoneCall);
    return Visibility(
      visible: _feedbackButton,
      child: new Container(
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
              child: new Text('Send Feedback',
                  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: () {
                sendfeedback();
                //Navigator.push(context,
                //  MaterialPageRoute(builder: (context) => FeedbackPage()));
              },
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        body: callFeedback(),
      ),
    );
  }
}
