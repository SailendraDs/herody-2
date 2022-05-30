import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:herody/herodyicons_icons.dart';
import 'package:http/http.dart';
import 'package:herody/telecallings/tele_detail.dart';
import 'package:herody/globaldata.dart' as g;
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class Telecallingsmypage extends StatefulWidget {
  @override
  _TelecallingsmypageState createState() => new _TelecallingsmypageState();
}

class _TelecallingsmypageState extends State<Telecallingsmypage> {
  var data;
  var data2;
  String _basel64;
  bool servererror = false;
  List status = [
    "Applied",
    "Application Approved",
    "Application Rejected",
    "Proof submitted",
    "Proof Accepted & paid",
    "Proof Rejected"
  ];

  void getdata() async {
    String url = g.preurl + "telecalling/applications";
    Response response = await post(url, body: {"uid": g.uid});
    try {
      setState(() {
        data = json.decode(response.body)["response"];
        print(g.uid);
      });
    } catch (e) {
      /*setState(() {
        servererror=true;
      });*/
      print(e);
    }
  }

  void getdata2() async {
    String url = g.preurl + "telecallings";
    Response response = await post(url);
    try {
      setState(() {
        data2 = json.decode(response.body)["response"]["telecallings"];
      });
    } catch (e) {
      /*setState(() {
        servererror=true;
      });*/
      print(e);
    }
  }

  void initState() {
    super.initState();
  }

  Widget logoimage() {
    if (_basel64 == null) return new Container();
    Uint8List bytes = Base64Codec().decode(_basel64);
    Container(
      child: Image.memory(
        bytes,
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 2.0, color: Colors.pink),
      color: Colors.pink,
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    );
  }

  Widget telecallingslist() {
    return ListView.separated(
      itemCount: data == null ? 0 : data["applications"].length,
      itemBuilder: (BuildContext context, i) {
        var basel64 = data2[i]['logo'].toString();
        return new Container(
          padding: (i == data["applications"].length - 1)
              ? EdgeInsets.fromLTRB(0, 0, 0, 50)
              : EdgeInsets.all(0),
          child: InkWell(
            child: Column(
              children: [
                Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5),
                            topLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    elevation: 8,
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    shadowColor: Colors.blue,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          child: Image.memory(
                              Base64Decoder().convert(basel64.substring(
                                  basel64.indexOf(",") + 1, basel64.length)),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              gaplessPlayback: true),
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 10, 5, 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text(
                                    data2[i]["title"],
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600]),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text(
                                    data2[i]["company"],
                                    style: TextStyle(color: Colors.pink[700]),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
                                ),
                                Text(" "),
                                Container(
                                    decoration: myBoxDecoration(),
                                    alignment: Alignment.bottomRight,
                                    padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                    child: Row(
                                      children: [
                                        //Image.asset("assets/rupee.png",height:20),
                                        Text(
                                          "₹ " + data2[i]["amount"].toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),
                                        )
                                      ],
                                    ))
                              ],
                            ))
                      ],
                    )),
                Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.green[600],
                              gradient: LinearGradient(colors: [
                                (data["applications"][i]["status"] == 0)
                                    ? Colors.pink[600]
                                    : (data["applications"][i]["status"] == 1)
                                        ? Colors.orange[600]
                                        : (data["applications"][i]["status"] ==
                                                2)
                                            ? Colors.red[600]
                                            : (data["applications"][i]
                                                        ["status"] ==
                                                    3)
                                                ? Colors.blue[600]
                                                : (data["applications"][i]
                                                            ["status"] ==
                                                        4)
                                                    ? Colors.green[600]
                                                    : Colors.orange[600],
                                (data["applications"][i]["status"] == 0)
                                    ? Colors.pink[200]
                                    : (data["applications"][i]["status"] == 1)
                                        ? Colors.orange[200]
                                        : (data["applications"][i]["status"] ==
                                                2)
                                            ? Colors.red[200]
                                            : (data["applications"][i]
                                                        ["status"] ==
                                                    3)
                                                ? Colors.blue[200]
                                                : (data["applications"][i]
                                                            ["status"] ==
                                                        4)
                                                    ? Colors.green[200]
                                                    : Colors.orange[200]
                              ]),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                            ),
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: Text(
                              "Status: " +
                                  status[data["applications"][i]["status"]],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 30),
                            )),
                        Container(
                          width: 30,
                          height: 5,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20)),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
            onTap: () {
              print("1");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Telecallingdetails(
                      id: data["applications"][i]["id"].toString(),
                      statusid: data["applications"][i]["status"],
                    ),
                  ));
            },
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Container(
          height: 0,
          width: 0,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) getdata();
    if (data == null) getdata2();
    return data == null
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
                        style: TextStyle(fontSize: 25, color: Colors.grey[800]),
                      ),
                      Text(
                        "Check back later",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.grey[800]),
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
        : data["applications"].length == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/apply.png",
                    height: 150,
                  ),
                  Container(height: 20),
                  Text(
                    "You have not applied for any Gigs yet",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width / 20,
                        color: Colors.grey[800]),
                  ),
                  Container(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Press ",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.grey[800]),
                      ),
                      Icon(
                        Herodyicons.telecallings,
                        color: Colors.grey[800],
                      ),
                      Text(
                        " and apply now",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.grey[800]),
                      )
                    ],
                  ),
                ],
              )
            : telecallingslist();
  }
}
