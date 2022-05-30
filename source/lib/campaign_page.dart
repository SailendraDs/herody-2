import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:herody/campaign_details.dart';
import 'package:http/http.dart';
import 'globaldata.dart' as g;

class Campaignspage extends StatefulWidget {
  @override
  _CampaignspageState createState() => new _CampaignspageState();
}

class _CampaignspageState extends State<Campaignspage> {
  var data;
  bool servererror = false;
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

  void getdata() async {
    String url = g.preurl + "campaigns";
    Response response = await post(url);
    try {
      setState(() {
        data = json.decode(response.body)["response"]["campaigns"];
      });
    } catch (e) {
      /*setState(() {
        servererror=true;
      });*/
      print(e);
    }
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 2.0, color: Colors.pink),
      color: Colors.pink,
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    );
  }

  Widget campaignslist() {
    return ListView.separated(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, i) {
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
                            child: Image(
                                image: NetworkImage(
                                    "https://herody.in/assets/admin/img/camp-brand-logo/" +
                                        data[i]["logo"]),
                                loadingBuilder: (context, child,
                                        loadingProgress) =>
                                    (loadingProgress != null)
                                        ? Container(
                                            height: 100,
                                            width: 100,
                                            alignment: Alignment.center,
                                            child: CircularProgressIndicator())
                                        : child,
                                width: 100,
                                height: 100)),
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
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text(
                                    data[i]["brand"],
                                    style: TextStyle(
                                        color: Colors.pink[700],
                                        fontWeight: FontWeight.normal),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 150,
                                  child: Text(
                                    "\nApply before:  " +
                                        data[i]["before"]
                                            .toString()
                                            .substring(8, 10) +
                                        " " +
                                        month[int.parse(data[i]["end"]
                                                .toString()
                                                .substring(5, 7)) -
                                            1] +
                                        " " +
                                        data[i]["end"]
                                            .toString()
                                            .substring(0, 4),
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
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
                                                  data[i]["reward"].toString(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            )
                                          ],
                                        )),
                                    Container(
                                        alignment: Alignment.bottomRight,
                                        padding:
                                            EdgeInsets.fromLTRB(5, 1, 5, 1),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.place,
                                              size: 10,
                                            ),
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  5, 0, 0, 0),
                                              width: 100,
                                              child: Text(
                                                " " +
                                                    data[i]["city"].toString(),
                                                style: TextStyle(fontSize: 10),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 5,
                                              ),
                                            ),
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
                    builder: (context) => Campaigndetails(
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
                      //Image.asset("assets/maintenance.png",height: 130,),
                      //Text("App under maintenance!",textAlign: TextAlign.center,style: TextStyle(fontSize: 25,color: Colors.grey[800]),),
                      //Text("Check back later",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Colors.grey[800]),),
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
                //Text("Sorry there are currently no Projects",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Colors.grey[800]),),
              )
            : campaignslist();
  }
}
