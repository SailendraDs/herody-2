import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:herody/globaldata.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:herody/globaldata.dart' as g;
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:sms_autofill/sms_autofill.dart';
import 'call_feedback.dart';
import 'calling_session.dart';
import 'package:flutter/src/material/dialog.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class CallerInfos extends StatefulWidget {
  final String title;
  final String id;
  final String objDes;
  final String last_date;
  final String outcomes;

  const CallerInfos(
      {this.id, this.title, this.objDes, this.last_date, this.outcomes});
  @override
  State<StatefulWidget> createState() => new _CallerInfosState(
      id: id,
      title: title,
      obj_des: objDes,
      last_date: last_date,
      outcomes: outcomes);

  static fromJson(collectionElement) {}
}

class _CallerInfosState extends State<CallerInfos> {
  _CallerInfosState(
      {this.id, this.title, this.obj_des, this.last_date, this.outcomes});

  final String title;
  final String id;
  final String obj_des;
  final String last_date;
  final String outcomes;

  int sid = -2;
  var response;
  var tdata;
  var userdata;
  var applydata;

  var applicationData;
  var responseData;
  var dataResponse;
  var myCampainsData;
  var myCampainsData2;
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
  var email = "";
  String description;
  var number = "";
  var number1 = "";
  int count = 0;
  String api_token;
  Future<List> getApplicationData() async {
    print("On press trigerred");
    var response = await http
        .post("https://herody.in/api/telecalling/status?uid=${g.uid}&id=$id");

    try {
      var responseData = json.decode(response.body)["response"];
      print("prints the full response");
      print(responseData);
      print("prints the response length");
      print(responseData.length);
      print("--------------------------------------------------");
      var data_len = 0;
      var feedback_len = 0;
      var feedback = null;
      responseData["application"]["feedback"] == null
          ? feedback = null
          : feedback = json.decode(responseData["application"]["feedback"]);
      feedback == null ? feedback_len = 0 : feedback_len = feedback.length;
      var data = null;
      responseData["application"]["data"] == null
          ? data = null
          : data = json.decode(responseData["application"]["data"]);
      data == null ? data_len = 0 : data_len = data.length;
      var y = [];
      for (var j = feedback_len - 1; j >= 0; j--) {
        y.add(feedback[j]["caller_phone"].toString());
      }
      print(y);
      for (var i = 0; i <= data_len - 1; i++) {
        dataResponse = data[i];

        var no = dataResponse["Phone Number"].toString();
        if (y.contains(no)) {
          print("============================================");
        } else {
          name = dataResponse["Name"];
          detailId = dataResponse["ID"].toString();
          language = dataResponse["Language"];
          trackingLink = dataResponse["Status Tracking Link"];
          region = dataResponse["Region"];
          mobileNumber = dataResponse["Phone Number"].toString();
          desc = dataResponse["Description"];
          email = dataResponse["Email"];
          number1 = mobileNumber;

          if (count < 3) {
            count = count + 1;
          }

          if (count == 1 && name != "" && detailId != "" && language != "") {
            checkcall();
          }
          remoteconfigData();
          break;
        }
      }
    } catch (e) {
      print("Didnt refresh !!!!!!!!!!!!!!!!!!!!!!");
      print(e);
    }

    return ["hey", "heloo", "how are you"];
  }

  Future<int> getotp() async {
    String url = g.preurl + "user/verifyMobile";
    Response response = await post(url,
        body: {"uid": data["response"]["user"]["phone"].toString()});
    var mobiledata = jsonDecode(response.body);
    return (1);
  }

  remoteconfigData() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    setState(() {
      description = remoteConfig.getString("Description");
      number = remoteConfig.getString("Mobile_Number");
      api_token = remoteConfig.getString("API_TOKEN");
    });
  }

  void _myCampains(String mobileNumber) async {
    remoteconfigData();
    String url = "https://obd-api.myoperator.co/obd-api-v1";
    var rndnumber = "";
    Response response = await post(url, headers: <String, String>{
      'x-api-key': api_token
    }, body: {
      "company_id": "603cdb501be46767",
      "secret_token":
          "56bc37e037e3fe32d2c2ad2a82ef98b512380a7580fa0a1b1d913ecc89be8e62",
      "type": "1",
      // "number": "+919319365093",
      // "number": data["response"]["user"]["phone"].toString(),
      "number_2": "+91" + mobileNumber,
      "public_ivr_id": "604c9f24a8834773",
      "reference_id": "herody" + rndnumber.toString(),
      "region": "Hydrabad"
    });
    try {
      setState(() {
        myCampainsData = json.decode(response.body)["code"];
        myCampainsData2 = json.decode(response.body)["status"];
        if (myCampainsData == 200 && myCampainsData2 == "success") {
          _makingPhoneCall(mobileNumber);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Widget randomNumber() {
    int rndnumber = 0;
    var rnd = new Random();
    for (var i = 0; i < 10; i++) {
      rndnumber = rndnumber + rnd.nextInt(1000000000);
    }
    print("printing random 10digit number");
    print(rndnumber);
  }

  Widget callerdata() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
      child: Text(
        "",
        style: TextStyle(
          fontSize: 18,
          color: Colors.black45,
        ),
      ),
    );
  }

  //var num;
  void _makingMissedCall(num) async {
    _myCampains(num);
    var url = "tel:$num";
    if (await canLaunch(url)) {
      var status = await launch(url);
      print("status                    " + status.toString());
    } else {
      throw 'Could not launch $url';
    }
  }

  void _makingPhoneCall(num) async {
    var url = num == null ? "tel:$mobileNumber" : "tel:$num";
    if (await canLaunch(url)) {
      var status = await launch(url);
      print("status                    " + status.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => //CallSession()
                CallFeedback(
                    id: id,
                    title: title,
                    objDes: obj_des,
                    caller_name: name,
                    caller_phone: mobileNumber,
                    last_date: last_date,
                    outcomes: outcomes),
          ));
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget callerInfo() {
    return Container(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: ClipOval(
                    child: new SizedBox(
                      width: 100,
                      height: 100,
                      child: new Image.network(
                        "https://cdn.logo.com/hotlink-ok/logo-social-sq.png",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: Text(
                  "Call Objective\n",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff00d68f)),
                ),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
                  child: Html(
                    data: obj_des,
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
            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
              width: 200,
              height: 5,
              color: Colors.grey[200],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 5),
            child: Text(
              "Call Details\n",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Text(
              "Name:\n$name",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
            child: Text(
              "App Language:\n$language",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
            child: Text(
              "Region:\n$region",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
            child: Text(
              "User ID:\n$detailId",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
            child: Text(
              "Status tracking link:\n$trackingLink",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
            child: Text(
              "Description:\n$desc",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
            child: Text(
              "E-mail:\n$email",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Container(
              width: 200,
              height: 5,
              color: Colors.grey[200],
            ),
          ),
          showPrimaryButton()
        ],
      ),
    );
  }

  // waitForCompletion(PhoneCall phoneCall) async {
  //   await phoneCall.done;
  //   print("Call is completed");
  // }

  Widget showPrimaryButton() {
    this.getApplicationData();
    this.randomNumber();
    this._myCampains(number1);
    // PhoneCall phoneCall;
    // this.waitForCompletion(phoneCall);
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
            child: new Text('Call',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () {
              _makingPhoneCall(mobileNumber);
            },
          ),
        ));
  }

  Future checkcall() {
    return showDialog(
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: AlertDialog(
              // title: Center(child: Text("Check")),
              content: Column(
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
                  Container(
                    height: 150.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/preview.png'),
                        fit: BoxFit.fill,
                      ),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      "$description",
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all<double>(10.0),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shadowColor:
                              MaterialStateProperty.all<Color>(Colors.white)),
                      onPressed: () {
                        _makingMissedCall(number);
                      },
                      child: Text(
                        "give a missed call",
                        style: TextStyle(color: Colors.blue),
                      )),
                ],
              ),
              actions: [
                TextButton(
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(2.0),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shadowColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    onPressed: () {
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
  }

  @override
  Widget build(BuildContext context) {
    // if (responseData == null)
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
        body: callerInfo(),
      ),
    );
  }
}
