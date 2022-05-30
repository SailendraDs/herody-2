import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'globaldata.dart' as g;
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class Campaigndetails extends StatefulWidget {
  Campaigndetails({this.id, this.statusid});
  final String id;
  final int statusid;
  @override
  State<StatefulWidget> createState() =>
      new _CampaigndetailsState(id: id, statusid: statusid);
}

class _CampaigndetailsState extends State<Campaigndetails> {
  _CampaigndetailsState({this.id, this.statusid});
  final _formKey = new GlobalKey<FormState>();
  final String id;
  final int statusid;
  int sid = -2;
  var data;
  var userdata;
  var applydata;
  bool onclick = false;
  bool applied = false;
  bool displayquestions = false;
  bool flag = false;
  bool servererror = false;
  bool submitproofs = false;
  String _errorMessage = "";
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

  void getdata() async {
    String url = g.preurl + "campaign/details";
    Response response = await post(url, body: {"id": id});
    try {
      setState(() {
        data = json.decode(response.body)["response"];
      });
    } catch (e) {
      /*setState(() {
        servererror=true;
      });*/
      print(e);
    }
  }

  void submitdata() async {
    if (displayquestions) {
      if (flag) {
        setState(() {
          onclick = true;
        });
        String url = g.preurl + "campaign/apply";
        Response response = await post(url,
            body: {"id": id, "uid": g.uid.toString(), "terms": "True"});
        print(response.body);
        var dt = await json.decode(response.body)["response"]["code"];
        if (dt == "SUCCESS") {
          await determine();
          setState(() {
            onclick = false;
            applydata = json.decode(response.body)["response"];
            applied = true;
          });
        } else {
          setState(() {
            onclick = false;
            _errorMessage = "We do not accept Applications Anymore\nThank You!";
            displayquestions = false;
          });
        }
      } else {
        setState(() {
          _errorMessage = "Accept our T&C before applying";
        });
      }
    } else {
      setState(() {
        displayquestions = true;
      });
    }
  }

  Future<int> determine() async {
    if (!onclick && !refresh) {
      setState(() {
        refresh = true;
      });
      print("11");
      String url = g.preurl + "user/campaigns";
      Response response = await post(url, body: {"id": g.uid});
      int i;
      try {
        userdata = json.decode(response.body)["response"];
        for (i = userdata["campaigninfo"].length - 1; i >= 0; i--) {
          if (userdata["campaigninfo"][i]["id"].toString() == id) {
            setState(() {
              sid = userdata["campaigns"][i]["status"];
              print(userdata["campaigns"][i]["status"]);
              //sid=5;
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
    return new Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.0, 15, 16.0, 15),
        child: SizedBox(
          height: 50.0,
          child: new RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: !onclick ? Colors.indigo[900] : Colors.pink,
              child: new Text(
                  (displayquestions && !applied)
                      ? (onclick)
                          ? "Submitting..."
                          : "Submit"
                      : applied
                          ? "Applied"
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

  Widget campaigndetails() {
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
                    Image(
                      image: NetworkImage(
                          "https://herody.in/assets/admin/img/camp-brand-logo/" +
                              data["campaign"]["logo"]),
                      loadingBuilder: (context, child, loadingProgress) =>
                          (loadingProgress != null)
                              ? Container(
                                  height: 160,
                                  width: 160,
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator())
                              : child,
                      width: 160,
                      height: 160,
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
                                    data["campaign"]["brand"].toString(),
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
                                    data["campaign"]["reward"].toString(),
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
                                    data["campaign"]["before"]
                                        .toString()
                                        .substring(8, 10) +
                                    " " +
                                    month[int.parse(data["campaign"]["before"]
                                            .toString()
                                            .substring(5, 7)) -
                                        1] +
                                    " " +
                                    data["campaign"]["before"]
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
          if (sid > -1)
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
                data: data["campaign"]["des"],
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
          if (sid == 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
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
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 10))
              ],
            ),
          Container(
            width: double.infinity,
            color: Colors.blue[100],
            height: 30,
            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              "Location\n",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
              child: Text(
                data["campaign"]["city"].toString(),
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.black),
              )),
          Container(
            width: double.infinity,
            color: Colors.blue[100],
            height: 30,
            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              "Project Period\n",
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
                        data["campaign"]["start"].toString().substring(8, 10) +
                        " " +
                        month[int.parse(data["campaign"]["start"]
                                .toString()
                                .substring(5, 7)) -
                            1] +
                        " " +
                        data["campaign"]["start"].toString().substring(0, 4) +
                        " - " +
                        data["campaign"]["end"].toString().substring(8, 10) +
                        " " +
                        month[int.parse(data["campaign"]["end"]
                                .toString()
                                .substring(5, 7)) -
                            1] +
                        " " +
                        data["campaign"]["end"].toString().substring(0, 4),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black),
                  )
                ],
              )),
          Container(
            width: double.infinity,
            color: Colors.blue[100],
            height: 30,
            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              "Project Benefits",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
              child: Html(
                data: data["campaign"]["benefits"],
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
          Container(
            width: double.infinity,
            color: Colors.blue[100],
            height: 30,
            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              "Requirements",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
              child: Html(
                data: data["campaign"]["requirements"],
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
          Container(
            width: double.infinity,
            color: Colors.blue[100],
            height: 30,
            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              "Do's & Don'ts",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
              child: Html(
                data: data["campaign"]["dondont"],
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
          Container(
            width: double.infinity,
            color: Colors.blue[100],
            height: 30,
            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              "Instructions",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
              child: Html(
                data: data["campaign"]["instructions"],
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
          Container(
            width: double.infinity,
            color: Colors.blue[100],
            height: 30,
            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              "Methods",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
              child: Html(
                data: data["campaign"]["methods"],
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
                        data["campaign"]["before"].toString().substring(8, 10) +
                        " " +
                        month[int.parse(data["campaign"]["before"]
                                .toString()
                                .substring(5, 7)) -
                            1] +
                        " " +
                        data["campaign"]["before"].toString().substring(0, 4),
                    textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.black),
                  )
                ],
              )),
          if (!applied && displayquestions)
            Container(
              width: double.infinity,
              color: Colors.blue[100],
              height: 30,
              padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: Text(
                "Terms & Conditions",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          if (!applied && displayquestions)
            Padding(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                child: Html(
                  data: data["campaign"]["terms"],
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
          if (!applied && displayquestions)
            Row(
              children: [
                Checkbox(
                  value: flag,
                  onChanged: (value) {
                    setState(() {
                      flag = true;
                    });
                  },
                ),
                Text(
                  "By clicking here you accept to our T&C",
                  style: TextStyle(color: Colors.pink),
                )
              ],
            ),
          showErrorMessage(),
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
    if (data == null && statusid != -1) sid = statusid;
    //if(userdata==null)determine();
    print("campaign id:" + id);
    determine();
    if (data == null) getdata();
    return MaterialApp(
      title: "Herody",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(data == null ? "" : data["campaign"]["title"]),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.indigo[900],
        ),
        body: data == null
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
            : campaigndetails(),
      ),
    );
  }
}
