import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:herody/telecallings/tele_detail.dart';
import 'package:http/http.dart';
import 'package:herody/globaldata.dart' as g;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

class Telecallingspage extends StatefulWidget {
  @override
  _TelecallingspageState createState() => new _TelecallingspageState();
}

class _TelecallingspageState extends State<Telecallingspage> {
  var data;
  bool servererror = false;
  String _base64;
  var last_date;
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
  var count = 0;
  void getdata() async {
    String url = g.preurl + "telecallings";
    Response response = await post(url);
    try {
      setState(() {
        data = json.decode(response.body)["response"]["telecallings"];
      });
    } catch (e) {
      /*setState(() {
        servererror=true;
      });*/
      print(e);
    }
  }

  // Widget logo_image(String image) {
  //   Uint8List _bytesImage;
  //   var i;
  //   var _imgString = image;
  //   _bytesImage = Base64Decoder().convert(_imgString);
  //   // print(_bytesImage);
  //   // print(_imgString);

  //   Image.memory(_bytesImage);
  // }
  void initState() {
    super.initState();
  }

  Widget logoimage() {
    if (_base64 == null) return new Container();
    Uint8List bytes = Base64Codec().decode(_base64);
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
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, i) {
        var base64 = data[i]['logo'].toString();
        return new Container(
          padding: (i == data.length - 1)
              ? EdgeInsets.fromLTRB(0, 0, 0, 50)
              : EdgeInsets.all(0),
          child: InkWell(
            child: Card(
                elevation: 8,
                margin: EdgeInsets.all(10),
                shadowColor: Colors.blue,
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                          // child: logo_image(data[i]['logo']),
                          child: Image.memory(
                              Base64Decoder().convert(base64.substring(
                                  base64.indexOf(",") + 1, base64.length)),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              gaplessPlayback: true),
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text(
                                    data[i]["title"],
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600]),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
                                ),
                                Text(" ", style: TextStyle(fontSize: 5)),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text(
                                    data[i]["company"].toString(),
                                    style: TextStyle(
                                        color: Colors.pink[700],
                                        fontWeight: FontWeight.normal),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 190,
                                  child: Text(
                                    "\nApply before:  " +
                                        data[i]["last_date"]
                                            .toString()
                                            .substring(8, 10) +
                                        " " +
                                        month[int.parse(data[i]["last_date"]
                                                .toString()
                                                .substring(5, 7)) -
                                            1] +
                                        " " +
                                        data[i]["last_date"]
                                            .toString()
                                            .substring(0, 4),
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 12),
                                  ),
                                ),
                                Text(" ", style: TextStyle(fontSize: 5)),
                                Row(
                                  children: [
                                    Container(
                                        decoration: myBoxDecoration(),
                                        alignment: Alignment.bottomRight,
                                        padding:
                                            EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        child: Row(
                                          children: [
                                            Text(
                                              "₹ " +
                                                  data[i]["amount"].toString(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            )
                                          ],
                                        )),
                                  ],
                                )
                              ],
                            ))
                      ],
                    ))),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Telecallingdetails(
                      id: data[i]["id"].toString(),
                      statusid: -1,
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
        : data.length == 0
            ? Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/nothing.png",
                        height: 130,
                      ),
                      Text(
                        "Sorry, there are currently no Projects",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.grey[800]),
                      ),
                      Container(
                        height: 100,
                        width: 20,
                      )
                    ]),
              )
            : telecallingslist();
  }
}
