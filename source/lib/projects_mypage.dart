import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:herody/herodyicons_icons.dart';
import 'package:herody/project_page.dart';
import 'package:http/http.dart';
import 'project_details.dart';
import 'globaldata.dart' as g;

class Projectsmypage extends StatefulWidget {
  @override
  _ProjectspagemyState createState() => new _ProjectspagemyState();
}

class _ProjectspagemyState extends State<Projectsmypage> {
  var data;
  var sdata;
  bool servererror = false;
  List status = [
    "Applied",
    "Shortlisted",
    "Selected",
    "Rejected",
    "Proof Submitted",
    "Certificate Issued",
    "Payout"
  ];

  void getdata() async {
    String url = g.preurl + "user/jprojects";
    Response response = await post(url, body: {"id": g.uid});
    try {
      setState(() {
        sdata = json.decode(response.body)["response"]["projects"];
        data = json.decode(response.body)["response"]["projectsinfo"];
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

  Widget projectslist() {
    return ListView.separated(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (BuildContext context, i) {
        return new Container(
          padding: (i == data.length - 1)
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
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Row(
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Image(
                                    image: NetworkImage(data[i]["image"]),
                                    loadingBuilder: (context, child,
                                            loadingProgress) =>
                                        (loadingProgress != null)
                                            ? Container(
                                                height: 100,
                                                width: 100,
                                                alignment: Alignment.center,
                                                child:
                                                    CircularProgressIndicator())
                                            : child,
                                    width: 100,
                                    height: 100)),
                            Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width -
                                          150,
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
                                      width: MediaQuery.of(context).size.width -
                                          150,
                                      child: Text(
                                        data[i]["brand"],
                                        style:
                                            TextStyle(color: Colors.pink[700]),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    ),
                                    Text(" "),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            decoration: myBoxDecoration(),
                                            alignment: Alignment.bottomRight,
                                            padding:
                                                EdgeInsets.fromLTRB(5, 1, 5, 1),
                                            child: Row(
                                              children: [
                                                //Image.asset("assets/rupee.png",height:10),
                                                Text(
                                                  "₹ " +
                                                      data[i]["stipend"]
                                                          .toString(),
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
                                                  Icons.date_range,
                                                  size: 10,
                                                ),
                                                Text(
                                                  " " +
                                                      data[i]["duration"]
                                                          .toString(),
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                )
                                              ],
                                            )),
                                      ],
                                    )
                                  ],
                                ))
                          ],
                        ))),
                Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 5),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              color: Colors.green[600],
                              gradient: LinearGradient(colors: [
                                (sdata[i]["status"] == 0)
                                    ? Colors.pink[600]
                                    : (sdata[i]["status"] == 1)
                                        ? Colors.yellow[600]
                                        : (sdata[i]["status"] == 2)
                                            ? Colors.orange[600]
                                            : (sdata[i]["status"] == 3)
                                                ? Colors.red[600]
                                                : (sdata[i]["status"] == 4)
                                                    ? Colors.blue[600]
                                                    : (sdata[i]["status"] == 5)
                                                        ? Colors.green[600]
                                                        : Colors.green[600],
                                (sdata[i]["status"] == 0)
                                    ? Colors.pink[200]
                                    : (sdata[i]["status"] == 1)
                                        ? Colors.yellow[200]
                                        : (sdata[i]["status"] == 2)
                                            ? Colors.orange[200]
                                            : (sdata[i]["status"] == 3)
                                                ? Colors.red[200]
                                                : (sdata[i]["status"] == 4)
                                                    ? Colors.blue[200]
                                                    : (sdata[i]["status"] == 5)
                                                        ? Colors.green[200]
                                                        : Colors.green[200]
                              ]),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                            ),
                            padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                            child: Text(
                              "Status: " + status[sdata[i]["status"]],
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
                    builder: (context) => Projectdetails(
                      id: data[i]["id"].toString(),
                      statusid: sdata[i]["status"],
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
    return MaterialApp(
        title: "Herody",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(Herodyicons.internships),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Projectspage(),
                      ));
                },
              ),
            ],
            elevation: 0,
            centerTitle: false,
            title: Text(
              "My Internships",
              style: TextStyle(color: Colors.white),
            ),
            automaticallyImplyLeading: true,
            leading: IconButton(
              color: Colors.white,
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.indigo[800],
          ),
          body: (data == null)
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
              : data.length == 0
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
                          "You have not applied for any Internships yet",
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
                              style: TextStyle(
                                  fontSize: 20, color: Colors.grey[800]),
                            ),
                            Icon(
                              Herodyicons.internships,
                              color: Colors.grey[800],
                            ),
                            Text(
                              " and apply now",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.grey[800]),
                            )
                          ],
                        ),
                      ],
                    )
                  : projectslist(),
        ));
  }
}
