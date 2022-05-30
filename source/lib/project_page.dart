import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:herody/projects_mypage.dart';
import 'package:http/http.dart';
import 'globaldata.dart' as g;
import 'project_details.dart';
import 'package:herody/herodyicons_icons.dart';

class Projectspage extends StatefulWidget {
  @override
  _ProjectspageState createState() => new _ProjectspageState();
}

class _ProjectspageState extends State<Projectspage> {
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
    String url = g.preurl + "projects";
    Response response = await post(url);
    try {
      setState(() {
        data = json.decode(response.body)["response"]["projects"];
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
                                image: NetworkImage(data[i]["image"]),
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
                                        data[i]["end"]
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                                  data[i]["stipend"].toString(),
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
                                              style: TextStyle(fontSize: 10),
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
                    builder: (context) => Projectdetails(
                        id: data[i]["id"].toString(), statusid: -1),
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
                          builder: (context) => Projectsmypage(),
                        ));
                  },
                ),
              ],
              elevation: 0,
              centerTitle: false,
              title: Text(
                "All Internships",
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
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.indigo)))
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
                                "Sorry, there are currently no Internships",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.grey[800]),
                              ),
                              Container(
                                height: 100,
                                width: 20,
                              )
                            ]),
                        //Text("Sorry there are currently no Internships",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Colors.grey[800]),),
                      )
                    : projectslist()));
  }
}
