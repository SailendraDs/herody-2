import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:herody/telecallings/CallerObjs.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:herody/globaldata.dart' as g;
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class Telecallingdetails extends StatefulWidget {
  Telecallingdetails({this.id, this.statusid});
  final String id;
  final int statusid;

  @override
  State<StatefulWidget> createState() =>
      new _TelecallingdetailsState(id: id, statusid: statusid);
}

class _TelecallingdetailsState extends State<Telecallingdetails> {
  _TelecallingdetailsState({this.id, this.statusid});
  final _formKey = new GlobalKey<FormState>();
  final String id;
  final int statusid;
  int sid;
  var datas;
  var tdata;
  var userdata;
  var applydata;
  bool onclick = false;
  bool applied = false;
  bool displayquestions = false;
  bool flag = false;
  bool servererror = false;
  bool submitproofs = false;
  String _baselogo64;
  String _errorMessage = "";
  int count = 0;
  var dataResponse;
  List month = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];
  var data = null;
  List status = [
    "Applied",
    "Application Approved",
    "Application Rejected",
    "Proof submitted",
    "Proof Accepted & paid",
    "Proof Rejected"
  ];
  bool refresh = false;

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void initState() {
    super.initState();
    setState(() {
      sid = sid;
    });
  }

  Widget logoimage() {
    if (_baselogo64 == null) return new Container();
    Uint8List bytes = Base64Codec().decode(_baselogo64);
    Container(
      child: Image.memory(
        bytes,
      ),
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Container(
          alignment: Alignment.center,
          child: new Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: new Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              )));
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Future<List> getApplicationData() async {
    print("On press trigerred");
    var response = await http
        .post("https://herody.in/api/telecalling/status?uid=${g.uid}&id=$id");

    try {
      var responseData = json.decode(response.body)["response"];

      var data_len = 0;
      var feedback_len = 0;
      var feedback = null;
      sid = responseData["application"]["status"];
      responseData["application"]["feedback"] == null
          ? feedback = null
          : feedback = json.decode(responseData["application"]["feedback"]);
      feedback == null ? feedback_len = 0 : feedback_len = feedback.length;

      responseData["application"]["data"] == null
          ? data = null
          : data = json.decode(responseData["application"]["data"]);
      data == null ? data_len = 0 : data_len = data.length;
      var y = [];
      for (var j = feedback_len - 1; j >= 0; j--) {
        y.add(feedback[j]["caller_phone"].toString());
      }

      for (var i = 0; i <= data_len - 1; i++) {
        dataResponse = data[i];
        var no = dataResponse["Phone Number"].toString();

        if (y.contains(no)) {
          print("============================================");
          if (i == data_len - 1) {
            count = 3;
          }
        }
      }
    } catch (e) {
      print("Didnt refresh !!!!!!!!!!!!!!!!!!!!!!");
      print(e);
    }

    return ["hey", "heloo", "how are you"];
  }

  String image;
  getdata() async {
    getApplicationData();
    String url = g.preurl + "telecalling/details";
    Response response = await post(url, body: {"id": id});
    try {
      datas = json.decode(response.body)["response"];
      print("count======+++++++" + count.toString());
      print("==============================================");
      image = datas["telecalling"]["script_img"];
      if ( //datas["telecalling"]["distributed"] == 1) {
          (sid == 3 || count != 3) && data != null) {
        print("count======-------------------" + count.toString());

        //TODO Show objective page
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => CallerObjs(
                    id: datas["telecalling"]["id"].toString(),
                    statusid: -1,
                    title: datas["telecalling"]["title"],
                    outcomes: datas["telecalling"]["outcomes"],
                    script_des: datas["telecalling"]["script_des"],
                    audio_des: datas["telecalling"]["audio_des"],
                    audio_file: datas["telecalling"]["audio_file"],
                    obj_des: datas["telecalling"]["obj_des"],
                    file: datas["telecalling"]["file"],
                    script_img: image,
                    last_date: datas["telecalling"]["last_date"])));
      } else {
        determine();
      }
    } catch (e) {
      print(e);
    }
  }

  void submitdata() async {
    setState(() {
      onclick = true;
    });
    String url = g.preurl + "telecalling/apply";
    Response response = await post(url, body: {"id": id, "uid": g.uid});
    await determine();
    setState(() {
      applydata = json.decode(response.body)["response"];
      onclick = false;
      applied = true;
    });
  }

  Future<int> determine() async {
    if (!onclick && !refresh) {
      setState(() {
        refresh = true;
      });
      print("11");
      String url = g.preurl + "telecalling/applications";
      Response response = await post(url, body: {"uid": g.uid});
      int i;
      try {
        userdata = json.decode(response.body)["response"];
        for (i = userdata["applications"].length - 1; i >= 0; i--) {
          if (userdata["applications"][i]["tid"].toString() == id) {
            setState(() {
              sid = userdata["applications"][i]["status"];
              print(userdata["applications"][i]["status"]);

              if (onclick != true) {
                if (sid != 5)
                  applied = true;
                else
                  applied = false;
              }
            });
            break;
          }
        }
        if (i == -1) {
          setState(() {
            sid = -1;
          });
        }
      } catch (e) {
        print("Didnt refresh !!!!!!!!!!!!!!!!!!!!!!");
        print(e);
      }
      setState(() {
        refresh = false;
      });
    }
    return (1);
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(16.0, 25, 16.0, 15),
        child: SizedBox(
          height: 50.0,
          child: new RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: !onclick ? Colors.indigo[900] : Colors.pink,
              child: new Text(
                  applied
                      ? (sid == 4 && count == 3)
                          ? "Completed"
                          : "Applied"
                      : (onclick)
                          ? "Submitting..."
                          : 'Apply Now',
                  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                if (!applied) submitdata();
              }),
        ));
  }

  Widget telecallingdetail() {
    var baselogo64 = datas["telecalling"]['logo'].toString();
    return Container(
      child: ListView(
        children: [
          Container(
            color: Colors.blueGrey[50],
            child: Card(
              shadowColor: Colors.blue,
              elevation: 10,
              margin: EdgeInsets.fromLTRB(5, 10, 5, 20),
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Image.memory(
                          Base64Decoder().convert(baselogo64.substring(
                              baselogo64.indexOf(",") + 1, baselogo64.length)),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          gaplessPlayback: true),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Container(
                        width: 2,
                        height: 200,
                        color: Colors.indigo[800],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.business,
                              color: Colors.black,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              width: MediaQuery.of(context).size.width - 260,
                              child: Text(
                                "Company: " +
                                    datas["telecalling"]["company"].toString(),
                                style: TextStyle(color: Colors.grey[700]),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ),
                          ],
                        ),
                        Text(" "),
                        Row(
                          children: [
                            Icon(
                              Icons.insights,
                              color: Colors.black,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              width: MediaQuery.of(context).size.width - 260,
                              child: Text(
                                "Category: " +
                                    datas["telecalling"]["category"].toString(),
                                style: TextStyle(color: Colors.grey[700]),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ),
                          ],
                        ),
                        Text(" "),
                        Row(
                          children: [
                            Image.asset("assets/rupee.png", height: 20),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              width: MediaQuery.of(context).size.width - 260,
                              child: Text(
                                "Stipend: ₹" +
                                    datas["telecalling"]["amount"].toString(),
                                style: TextStyle(color: Colors.grey[700]),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ),
                          ],
                        ),
                        Text(" "),
                        Row(
                          children: [
                            Icon(Icons.schedule),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                              width: MediaQuery.of(context).size.width - 260,
                              child: Text(
                                "Apply Before: \n" +
                                    datas["telecalling"]["last_date"]
                                        .toString()
                                        .substring(8, 10) +
                                    " " +
                                    month[int.parse(datas["telecalling"]
                                                ["last_date"]
                                            .toString()
                                            .substring(5, 7)) -
                                        1] +
                                    " " +
                                    datas["telecalling"]["last_date"]
                                        .toString()
                                        .substring(0, 4),
                                style: TextStyle(color: Colors.grey[700]),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
          /*if (sid > -1)
            Container(
              color: Colors.blueGrey[50],
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(10, 0, 20, 10),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.pink,
                ),
                child: Text(
                  "Current Status:  " + status[sid],
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          ),
           Container(
            color: Colors.blue[100],
            height: 30,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              "About Project\n",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
              child: Html(
                data: datas["telecalling"]["outcomes"]
                    .toString()
                    .replaceAll("{", " ")
                    .replaceAll("}", " ")
                    .replaceAll(":", ". ")
                    .replaceAll("\"", " "),
                onLinkTap: (url) {
                  launch(url);
                },
                customRender: (node, children) {
                  if (node is dom.Element) {
                    switch (node.localName) {
                      case "": // using this, you can handle custom tags in your HTML
                        return Column(children: children);
                    }
                  }
                },
              )),
          Text(" "),*/
          if (sid == 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /* RaisedButton(
                  color: (submitproofs) ? Colors.indigo[700] : Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Text(
                    (submitproofs == false) ? "Submit Proofs" : "Loading...",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (submitproofs == false) {
                      setState(() {
                        submitproofs = true;
                      });
                      await launch(
                          "https://herody.in/campaign/submit-responsea/" +
                              id.toString() +
                              "/" +
                              g.uid);
                      setState(() {
                        submitproofs = false;
                      });
                      await determine();
                    }
                  },
                ),*/
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 10))
              ],
            ),
          Container(
            width: double.infinity,
            color: Colors.blue[100],
            height: 30,
            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              "Project Description",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          Text(" "),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Column(
                children: [
                  Html(
                    data: datas["telecalling"]["script_des"],
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
                  /* datas["telecalling"]["script_img"] != null
                      ? Container(
                          height: MediaQuery.of(context).size.height / 5,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(base64.decode(
                                      datas["telecalling"]["script_img"]
                                          .split(",")
                                          .last)),
                                  fit: BoxFit.fill)))
                      : Container(),*/
                ],
              )),
          Text(" "),
          Container(
            width: double.infinity,
            color: Colors.blue[100],
            height: 30,
            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              "Apply Before Date\n",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
              child: Row(
                children: [
                  Icon(
                    Icons.event,
                    color: Colors.grey[800],
                  ),
                  Text(
                    " " +
                        datas["telecalling"]["last_date"]
                            .toString()
                            .substring(8, 10) +
                        " " +
                        month[int.parse(datas["telecalling"]["last_date"]
                                .toString()
                                .substring(5, 7)) -
                            1] +
                        " " +
                        datas["telecalling"]["last_date"]
                            .toString()
                            .substring(0, 4),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black),
                  )
                ],
              )),
          if (sid != -2) showPrimaryButton(),
          if (sid == 0)
            Text(
                "Your Application is currently being reviewed\nCheck the above Current Status for further details\n\n",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: MediaQuery.of(context).size.width / 30,
                )),
          if (sid == 5)
            Text(
                "Your Proofs were rejected by the Company\nApply now to try again\n\n",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: MediaQuery.of(context).size.width / 30,
                )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("-----------------");
    if (datas == null && statusid != -1) sid = statusid;
    print("telecalling id:" + id);
    if (datas == null) getdata();
    return MaterialApp(
      title: "Herody",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(datas == null ? "" : datas["telecalling"]["title"]),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.indigo[900],
        ),
        body: datas == null
            ? (servererror)
                ? Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/maintenance.png",
                            height: 130,
                          ),
                          Text(
                            "App under maintenance!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25, color: Colors.grey[800]),
                          ),
                          Text(
                            "Check back later",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[800]),
                          ),
                          Container(
                            height: 100,
                            width: 20,
                          )
                        ]),
                  )
                : Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.indigo)))
            : telecallingdetail(),
      ),
    );
  }
}
