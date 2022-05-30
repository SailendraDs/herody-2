import 'dart:async';

import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:herody/herodyicons_icons.dart';
import 'package:herody/login_page.dart';
import 'package:herody/my_page.dart';
import 'package:herody/profile.dart';
import 'package:herody/referral_page.dart';
import 'package:herody/resume_page.dart';
import 'package:herody/telecallings/tele_detail.dart';
import 'package:herody/wallet_page.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'campaign_details.dart';
import 'gig_details.dart';
import 'globaldata.dart' as g;
import 'gigs_page.dart';
import 'gigs_mypage.dart';
import 'project_details.dart';
import 'projects_mypage.dart';
import 'campaign_page.dart';
import 'campaign_mypage.dart';
import 'project_page.dart';
//import 'firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:package_info/package_info.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'telecallings/telecalling_page.dart';
import 'telecallings/telecalling_mypage.dart';

class MyApp extends StatefulWidget {
  MyApp({Key key, this.logoutCallback});
  final VoidCallback logoutCallback;
  @override
  _MyAppState createState() => new _MyAppState(logoutCallback: logoutCallback);
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  _MyAppState({this.logoutCallback});
  final VoidCallback logoutCallback;
  final GlobalKey<ScaffoldState> _home = new GlobalKey<ScaffoldState>();
  static GlobalKey bottom = GlobalKey();
  final controller = ScrollController();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  bool mylist = false;
  bool fromdrawer = false;
  bool contactus = false;
  bool servererror = false;
  String appbarname;
  var pdata;
  var gdata;
  var cdata;
  var tdata;
  double mov;
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
  int noOfGigsApplied = 0,
      noOfProjectsApplied = 0,
      noOfCampaignspplied = 0,
      noOfTelecallingsApplied = 0;
  bool applied = false;
  bool _visible = true;
  Timer timer;
  SharedPreferences prefs;

  signOut() async {
//    try {
//      widget.logoutCallback();
//
//    } catch (e) {
//      print(e);
//    }
//  -------------------------------> intern
    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    _showMyDialog();
  }

//---------------------------------> Intern
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hi There,'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure? you want to logout??'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
                child: Text('No '),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            FlatButton(
                child: Text('Yes '),
                onPressed: () {
                  Navigator.of(context).pop();
                  SystemNavigator.pop();
                }),
          ],
        );
      },
    );
  }

  Widget _diaplaylist() {
    if (!mylist) {
      if (g.page == 1)
        return (servererror)
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
            : home();
      if (g.page == 2) {
        getmygigs();
        return Gigspage();
      }
      /* if (g.page == 3) {
        getmyprojects();
        return Projectspage();
      }*/
      if (g.page == 3) {
        getmycampaigns();
        return Campaignspage();
      }
      if (g.page == 4) {
        getmytelecallings();
        return Telecallingspage();
      }
    } else {
      if (g.page == 1)
        return (servererror)
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
            : home();
      if (g.page == 2) return Gigsmypage();
      if (g.page == 3) return Campaignsmypage();
      if (g.page == 4) return Telecallingsmypage();
    }
  }

  int _showHerodyDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: new Text(
            "Herody",
            style: TextStyle(
                fontSize: 25,
                color: Colors.indigo[700],
                shadows: [Shadow(blurRadius: 10, color: Colors.blue[100])]),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Herody is the one stop destination for Internships/Gigs/Projects in India.Earn attractive stipend and Certificate by working with all big brands directly.We will help you to get your first life changing Internship\n",
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      "Rate Us",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      launch(
                          "https://play.google.com/store/apps/details?id=com.jaketa.herody");
                    },
                  ),
                  RaisedButton(
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 20),
        );
      },
    );
    return (1);
  }

  Widget home() {
    return ListView(
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              child: Card(
                elevation: 10,
                shadowColor: Colors.blue,
                margin: EdgeInsets.all(0),
                child: Container(
                    padding: EdgeInsets.fromLTRB(30, 20, 30, 30),
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: MediaQuery.of(context).size.width / 27,
                            ),
                            children: [
                              TextSpan(
                                  text: "Welcome ",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              27)),
                              TextSpan(
                                  text: g.data["name"],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              27)),
                              TextSpan(
                                  text:
                                      " | Apply for Gigs, Internships & Projects and Earn Money as well as Experience",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width /
                                              27))
                            ]))),
                color: Colors.indigo,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(100),
                )),
              ),
            ),
          ],
        ),
        /*Container(
          padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
          width: double.infinity,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.indigoAccent,Colors.blue])
            ),
            margin: EdgeInsets.all(0),
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                children: [
                  Text("Herody is creating New Set of",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  Text("Opportunities curated for you..",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ],
              ),
            ),
          ),
        ),*/
        Container(
          padding: EdgeInsets.fromLTRB(
              0, 20, MediaQuery.of(context).size.width * 0.25, 20),
          width: double.infinity,
          child: Card(
            elevation: 10,
            shadowColor: Colors.blue,
            margin: EdgeInsets.all(0),
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                "Featured Internships",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            color: Colors.pink,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
              right: Radius.circular(200),
            )),
          ),
        ),
        /*Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            margin: EdgeInsets.all(0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Brand new method to enable you",style: TextStyle(color: Colors.indigoAccent[700],fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                  Text("working with Favorite Brands as a Task Solver.",style: TextStyle(color: Colors.indigoAccent[700],fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                ],
              ),
            ),
          ),
        ),*/
        projectslist(),
        /*SizedBox(
          height: 250,
          child:projectslist(),
        ),*/
        Container(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.25, 20, 0, 20),
          width: double.infinity,
          child: Card(
            elevation: 10,
            shadowColor: Colors.blue,
            margin: EdgeInsets.all(0),
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                "Featured Gigs",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            color: Colors.pink,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
              left: Radius.circular(200),
            )),
          ),
        ),
        /*Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            margin: EdgeInsets.all(0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Brand new way to work for",style: TextStyle(color: Colors.indigoAccent[700],fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
                  Text("your Favourite Brands.",style: TextStyle(color: Colors.indigoAccent[700],fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
                ],
              ),
            ),
          ),
        ),*/
        gigslist(),
        Container(
          padding: EdgeInsets.fromLTRB(
              0, 20, MediaQuery.of(context).size.width * 0.25, 20),
          width: double.infinity,
          child: Card(
            elevation: 10,
            shadowColor: Colors.blue,
            margin: EdgeInsets.all(0),
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                "Featured Projects",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            color: Colors.pink,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
              right: Radius.circular(200),
            )),
          ),
        ),
        /*Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
            margin: EdgeInsets.all(0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Brand new way to make you work",style: TextStyle(color: Colors.indigoAccent[700],fontSize: 20,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                  Text("for Campaigns from your favorite Brands.",style: TextStyle(color: Colors.indigoAccent[700],fontSize: 15,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                ],
              ),
            ),
          ),
        ),*/
        campaignslist(),
        // anbu____________________________________________________________________________________________
        /*  Container(
          padding: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width * 0.25, 20, 0, 20),
          width: double.infinity,
          child: Card(
            elevation: 10,
            shadowColor: Colors.blue,
            margin: EdgeInsets.all(0),
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Text(
                "Featured Telecalling Internships",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.width / 20,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            color: Colors.pink,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.horizontal(
              left: Radius.circular(200),
            )),
          ),
        ),
        telecalllist(),
        // _______________________________________________________________________________________________________
        Container(
          padding: EdgeInsets.all(20),
        ),*/
      ],
    );
  }

  void getpgcdata() async {
    String url = g.preurl + "mobileContent";
    Response response = await post(url);
    setState(() {
      pdata = json.decode(response.body)["response"]["projects"];
      gdata = json.decode(response.body)["response"]["gigs"];
      cdata = json.decode(response.body)["response"]["campaigns"];
      tdata = json.decode(response.body)["response"]["telecallings"];
    });
    /*try{
    setState(() {
      pdata = json.decode(response.body)["response"]["projects"];
      gdata = json.decode(response.body)["response"]["gigs"];
      cdata = json.decode(response.body)["response"]["campaigns"];
    });
    }
    catch(e){
      setState(() {
        servererror=true;
      });
    }*/
  }

  void getmygigs() async {
    if (g.synccampaign) {
      print("Syncing Gigs...............");
      setState(() {
        applied = false;
      });
      String url = g.preurl + "user/gigs";
      Response response = await post(url, body: {"id": g.uid});
      try {
        noOfGigsApplied =
            await json.decode(response.body)["response"]["gigs"].length;
      } catch (e) {
        print("Getting no of users Gigs Failed!!!!!!!!!!!!");
        print(e);
      }
      setState(() {
        applied = true;
      });
    }
  }

  void getmycampaigns() async {
    if (g.synccampaign) {
      print("Syncing Campaign...............");
      setState(() {
        applied = false;
      });
      String url = g.preurl + "user/campaigns";
      Response response = await post(url, body: {"id": g.uid});
      try {
        var tempdata =
            await json.decode(response.body)["response"]["campaigns"];
        List<int> repeated = new List<int>();
        int length = 0;
        for (int i = 0; i < tempdata.length; i++) {
          if (!repeated.contains(tempdata[i]["cid"])) {
            length++;
            repeated.add(tempdata[i]["cid"]);
          }
        }
        noOfCampaignspplied = length;
      } catch (e) {
        print("Getting no of users campaign Failed!!!!!!!!!!!!");
        print(e);
      }
      setState(() {
        applied = true;
        g.synccampaign = false;
      });
    }
  }

  void getmyprojects() async {
    if (g.synccampaign) {
      print("Syncing Projects...............");
      setState(() {
        applied = false;
      });
      String url = g.preurl + "user/jprojects";
      Response response = await post(url, body: {"id": g.uid});
      try {
        noOfProjectsApplied =
            await json.decode(response.body)["response"]["projects"].length;
      } catch (e) {
        print("Getting no of users Projects Failed!!!!!!!!!!!!");
        print(e);
      }
      setState(() {
        applied = true;
        g.synccampaign = false;
      });
    }
  }

// getmytelecalling______________________________________________________________________________

  void getmytelecallings() async {
    noOfTelecallingsApplied = 0;
    if (g.synccampaign) {
      print("Syncing Telecallings...............");
      setState(() {
        applied = false;
      });
      String url = g.preurl + "telecalling/applications";
      Response response = await post(url, body: {"uid": g.uid});
      try {
        var tempdata =
            await json.decode(response.body)["response"]["applications"];
        List<int> repeated = new List<int>();
        int length = 0;
        for (int i = 0; i < tempdata.length; i++) {
          //  print(tempdata[i]["status"]);
          if (tempdata[i]["status"] == 0) {
            noOfTelecallingsApplied = noOfTelecallingsApplied + 1;
            // print(tempdata[i]["status"]);
            print(noOfTelecallingsApplied);
          }
          if (!repeated.contains(tempdata[i]["tid"])) {
            length++;
            repeated.add(tempdata[i]["tid"]);
          }
        }
        noOfCampaignspplied = length;
      } catch (e) {
        print("Getting no of users campaign Failed!!!!!!!!!!!!");
        print(e);
      }
      setState(() {
        applied = true;
        g.synccampaign = false;
      });
    }
  }

//_______________________________________________________________________________________
  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(width: 2.0, color: Colors.pink),
      color: Colors.pink,
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    );
  }

  Widget projectslist() {
    return (pdata == null)
        ? SpinKitThreeBounce(
            color: Colors.indigo[700],
            size: 20,
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: pdata == null ? 0 : pdata.length,
            itemBuilder: (BuildContext context, i) {
              return new Container(
                padding: (i == pdata.length - 1)
                    ? EdgeInsets.fromLTRB(0, 0, 0, 0)
                    : EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                                      image: NetworkImage(pdata[i]["image"]),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                150,
                                        child: Text(
                                          pdata[i]["title"],
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
                                            MediaQuery.of(context).size.width -
                                                150,
                                        child: Text(
                                          pdata[i]["brand"],
                                          style: TextStyle(
                                              color: Colors.pink[700],
                                              fontWeight: FontWeight.normal),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 5,
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                150,
                                        child: Text(
                                          "\nApply before:  " +
                                              pdata[i]["end"]
                                                  .toString()
                                                  .substring(8, 10) +
                                              " " +
                                              month[int.parse(pdata[i]["end"]
                                                      .toString()
                                                      .substring(5, 7)) -
                                                  1] +
                                              " " +
                                              pdata[i]["end"]
                                                  .toString()
                                                  .substring(0, 4),
                                          style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 5,
                                        ),
                                      ),
                                      Text(" ", style: TextStyle(fontSize: 5)),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                decoration: myBoxDecoration(),
                                                alignment:
                                                    Alignment.bottomRight,
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 1, 5, 1),
                                                child: Row(
                                                  children: [
                                                    //Image.asset("assets/rupee.png",height:10),
                                                    Text(
                                                      "₹ " +
                                                          pdata[i]["stipend"]
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                )),
                                            Container(
                                                alignment:
                                                    Alignment.bottomRight,
                                                padding: EdgeInsets.fromLTRB(
                                                    5, 1, 5, 1),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.date_range,
                                                      size: 10,
                                                    ),
                                                    Text(
                                                      " " +
                                                          pdata[i]["duration"]
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                    )
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ))),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Projectdetails(
                            id: pdata[i]["id"].toString(),
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

  Widget gigslist() {
    return (gdata == null)
        ? SpinKitThreeBounce(
            color: Colors.indigo[700],
            size: 30,
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: gdata == null ? 0 : gdata.length,
            itemBuilder: (BuildContext context, i) {
              return new Container(
                padding: (i == gdata.length - 1)
                    ? EdgeInsets.fromLTRB(0, 0, 0, 0)
                    : EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: InkWell(
                  child: Card(
                      elevation: 8,
                      margin: EdgeInsets.all(10),
                      shadowColor: Colors.blue,
                      child: Row(
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Image(
                                  image: (gdata[i]["user_id"] == "Admin")
                                      ? NetworkImage(
                                          "https://herody.in/assets/admin/img/gig-brand-logo/" +
                                              gdata[i]["logo"])
                                      : NetworkImage(
                                          "https://herody.in/assets/employer/profile_images/" +
                                              gdata[i]["logo"]),
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
                              padding: EdgeInsets.fromLTRB(0, 10, 5, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 150,
                                    child: Text(
                                      gdata[i]["campaign_title"],
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
                                      gdata[i]["brand"],
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
                                            "₹ " +
                                                gdata[i]["per_cost"].toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          )
                                        ],
                                      ))
                                ],
                              ))
                        ],
                      )),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Gigdetails(
                            id: gdata[i]["id"].toString(),
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

  Widget campaignslist() {
    return (cdata == null)
        ? SpinKitThreeBounce(
            color: Colors.indigo[700],
            size: 20,
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cdata == null ? 0 : cdata.length,
            itemBuilder: (BuildContext context, i) {
              return new Container(
                padding: (i == cdata.length - 1)
                    ? EdgeInsets.fromLTRB(0, 0, 0, 0)
                    : EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                                              cdata[i]["logo"]),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                150,
                                        child: Text(
                                          cdata[i]["title"],
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
                                            MediaQuery.of(context).size.width -
                                                150,
                                        child: Text(
                                          cdata[i]["brand"],
                                          style: TextStyle(
                                              color: Colors.pink[700],
                                              fontWeight: FontWeight.normal),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 5,
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                150,
                                        child: Text(
                                          "\nApply before:  " +
                                              cdata[i]["before"]
                                                  .toString()
                                                  .substring(8, 10) +
                                              " " +
                                              month[int.parse(cdata[i]["end"]
                                                      .toString()
                                                      .substring(5, 7)) -
                                                  1] +
                                              " " +
                                              cdata[i]["end"]
                                                  .toString()
                                                  .substring(0, 4),
                                          style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 5,
                                        ),
                                      ),
                                      Text(" ", style: TextStyle(fontSize: 5)),
                                      Container(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              decoration: myBoxDecoration(),
                                              alignment: Alignment.bottomRight,
                                              padding: EdgeInsets.fromLTRB(
                                                  5, 1, 5, 1),
                                              child: Row(
                                                children: [
                                                  //Image.asset("assets/rupee.png",height:10),
                                                  Text(
                                                    "₹ " +
                                                        cdata[i]["reward"]
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              )),
                                          Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  5, 1, 5, 1),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.place,
                                                    size: 10,
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            5, 0, 0, 0),
                                                    child: Text(
                                                      " " +
                                                          cdata[i]["city"]
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontSize: 10),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 5,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ],
                                      ))
                                    ],
                                  ))
                            ],
                          ))),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Campaigndetails(
                            id: cdata[i]["id"].toString(),
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

  // telecalling widget tdata __________________________________________________________________________________
  Widget telecalllist() {
    return (tdata == null)
        ? SpinKitThreeBounce(
            color: Colors.indigo[700],
            size: 30,
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tdata == null ? 0 : tdata.length,
            itemBuilder: (BuildContext context, i) {
              return new Container(
                padding: (i == tdata.length - 1)
                    ? EdgeInsets.fromLTRB(0, 0, 0, 0)
                    : EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: InkWell(
                  child: Card(
                      elevation: 8,
                      margin: EdgeInsets.all(10),
                      shadowColor: Colors.blue,
                      child: Row(
                        children: [
                          Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Image(
                                  image: NetworkImage(
                                      "https://cdn.logo.com/hotlink-ok/logo-social-sq.png"),
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
                              padding: EdgeInsets.fromLTRB(0, 10, 5, 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 150,
                                    child: Text(
                                      tdata[i]["title"],
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600]),
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
                                          Text(
                                            "₹ " +
                                                tdata[i]["amount"].toString(),
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          )
                                        ],
                                      ))
                                ],
                              ))
                        ],
                      )),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Telecallingdetails(
                            id: tdata[i]["id"].toString(),
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
  //_____________________________________________________________________________________________________________

  versionCheck(context) async {
    //Get Current installed version of app
    final PackageInfo info = await PackageInfo.fromPlatform();
    double currentVersion =
        double.parse(info.version.trim().replaceAll(".", ""));
    print(currentVersion);
    //Get Latest version info from firebase config
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      remoteConfig.getString('force_update_current_version');
      double newVersion = double.parse(remoteConfig
          .getString('force_update_current_version')
          .trim()
          .replaceAll(".", ""));
      print(newVersion);
      if (newVersion > currentVersion) {
        _showVersionDialog(context);
      }
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: new Text(
            "New Update Availabe!",
            style: TextStyle(fontSize: 20, color: Colors.indigo[700]),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Hi " + g.data["name"] + ",",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                "There is a newer version of app available. Update it now and do not miss our cool new features...\n",
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    color: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      "Update now",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      launch(
                          "https://play.google.com/store/apps/details?id=com.jaketa.herody");
                    },
                  ),
                  RaisedButton(
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      "Later",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              )
            ],
          ),
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 20),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    versionCheck(context);
    setState(() {
      appbarname = "Menu";
      mylist = false;
    });
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("Home-----------Page");
    setState(() {
      g.synccampaign = true;
    });
    if (pdata == null) getpgcdata();
    return MaterialApp(
        title: "Herody",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            key: _home,
            backgroundColor: Colors.blueGrey[50],
            appBar: AppBar(
              //title: Image.asset('assets/applogo.png',height: 20,),
              leading: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _home.currentState.openDrawer();
                },
              ),
              title: Text(
                  (g.page != 1 ? (mylist ? "My" : "All") : "") + appbarname),
              backgroundColor: Colors.indigo[900],
              actions: [
                if (g.page == 1)
                  Container(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                          child: Image.asset("assets/applogo.png", height: 20),
                          onTap: () {
                            _showHerodyDialog();
                          },
                        )),
                    padding: EdgeInsets.fromLTRB(0, 15, 20, 15),
                  ),
                if (g.page == 2 && mylist)
                  IconButton(
                    icon: Icon(Herodyicons.gigs),
                    onPressed: () {
                      setState(() {
                        mylist = !mylist;
                      });
                    },
                  ),
                /*if (g.page == 3 && mylist)
                  IconButton(
                    icon: Icon(Herodyicons.internships),
                    onPressed: () {
                      setState(() {
                        mylist = !mylist;
                      });
                    },
                  ),*/
                if (g.page == 3 && mylist)
                  IconButton(
                    icon: Icon(Herodyicons.projects),
                    onPressed: () {
                      setState(() {
                        mylist = !mylist;
                      });
                    },
                  ),
                if (g.page == 4 && mylist)
                  IconButton(
                    icon: Icon(Herodyicons.telecallings),
                    onPressed: () {
                      setState(() {
                        mylist = !mylist;
                      });
                    },
                  ),
                if (g.page != 1 && !mylist)
                  InkWell(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Stack(
                          children: [
                            //Image.asset("assets/my.png",height: 30,width: 30,),
                            Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset("assets/my.png"),
                              ),
                              padding: EdgeInsets.fromLTRB(10, 15, 20, 15),
                            ),
                            if (applied)
                              Container(
                                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.pink,
                                    child: Text(
                                      ((g.page == 2)
                                              ? noOfGigsApplied
                                              : (g.page == 3)
                                                  ? noOfCampaignspplied
                                                  : noOfTelecallingsApplied)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    radius: 10,
                                  ))
                          ],
                        )),
                    onTap: () {
                      setState(() {
                        mylist = !mylist;
                      });
                    },
                  )
              ],
            ),
            bottomNavigationBar: FancyBottomNavigation(
              key: bottom,
              barBackgroundColor: Colors.indigo[800],
              circleColor: Colors.white,
              inactiveIconColor: Colors.white,
              textColor: Colors.white,
              initialSelection: g.page - 1,
              activeIconColor: Colors.blue[800],
              tabs: [
                TabData(
                    iconData: Icons.home,
                    title: "Home",
                    onclick: () {
                      setState(() {
                        g.page = 1;
                        mylist = false;
                      });
                    }),
                TabData(
                    iconData: Herodyicons.gigs,
                    title: "Gigs",
                    onclick: () {
                      setState(() {
                        g.page = 2;
                        mylist = false;
                      });
                    }),
                /*  TabData(
                    iconData: Herodyicons.internships,
                    title: "Internships",
                    onclick: () {
                      setState(() {
                        g.page = 3;
                        mylist = false;
                      });
                    }),*/
                TabData(
                    iconData: Herodyicons.projects,
                    title: "Projects",
                    onclick: () {
                      setState(() {
                        g.page = 3;
                        mylist = false;
                      });
                    }),
                (g.page == 6)
                    ? TabData(
                        iconData: Herodyicons.internships,
                        title: "Internships",
                        onclick: () {
                          setState(() {
                            g.page = 6;
                            mylist = false;
                          });
                        })
                    : TabData(
                        iconData: Herodyicons.telecallings,
                        title: "Telecallings",
                        onclick: () {
                          setState(() {
                            g.page = 4;
                            mylist = false;
                          });
                        }),
              ],
              onTabChangedListener: (position) {
                setState(() {
                  if (fromdrawer)
                    fromdrawer = !fromdrawer;
                  else
                    mylist = false;
                  g.page = position + 1;
                  if (g.page == 1) appbarname = "Menu";
                  if (g.page == 2) appbarname = " Gigs";
                  //   if (g.page == 6) appbarname = " Internships";
                  if (g.page == 3) appbarname = " Projects";
                  if (g.page == 4) appbarname = " Telecallings";
                });
              },
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.elliptical(100, 30)),
                          gradient: LinearGradient(
                              colors: [Colors.indigo[800], Colors.blue[800]]),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
                                child: CircleAvatar(
                                  radius: 42,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                      radius: 40,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: Image.network(
                                          (g.data["profile_photo"] != null)
                                              ? "https://herody.in/assets/user/images/user_profile/" +
                                                  g.data["profile_photo"]
                                              : "https://d3q6qq2zt8nhwv.cloudfront.net/m/1_extra_hzavn771.jpg",
                                          height: 80,
                                          loadingBuilder: (context, child,
                                                  loadingProgress) =>
                                              (loadingProgress != null)
                                                  ? SpinKitDoubleBounce(
                                                      color: Colors.white)
                                                  : child,
                                        ),
                                      )),
                                )),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                              child: Text(
                                g.data["name"] == null ? "---" : g.data["name"],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            AnimatedContainer(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                                width: double.infinity,
                                alignment: Alignment.topRight,
                                duration: Duration(seconds: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      onTap: () async {
                        _home.currentState.openEndDrawer();
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Profile(),
                            ));
                        setState(() {
                          g.data = g.data;
                        });
                      }),
                  new ListTile(
                      leading: Image.asset(
                        "assets/resume.png",
                        height: 24,
                        width: 24,
                      ),
                      title: new Text("Resume"),
                      onTap: () {
                        _home.currentState.openEndDrawer();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Resume(),
                            ));
                      }),
                  //new Divider(height: 3,),
                  new Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.indigo[700],
                      Colors.white
                    ])),
                  ),
                  new ListTile(
                      leading: Image.asset(
                        "assets/myprojects.png",
                        height: 30,
                        width: 30,
                      ),
                      title: new Text("All Internships"),
                      onTap: () {
                        _home.currentState.openEndDrawer();
                        getmyprojects();
                        // Projectspage();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Projectspage(),
                            ));
                      }),

                  new Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.indigo[700],
                      Colors.white
                    ])),
                  ),
                  new ListTile(
                      leading: Image.asset(
                        "assets/mygigs.png",
                        height: 30,
                        width: 30,
                      ),
                      title: new Text("My Gigs"),
                      onTap: () {
                        setState(() {
                          g.page = 2;
                          mylist = true;
                          fromdrawer = true;
                        });
                        _home.currentState.openEndDrawer();
                        final FancyBottomNavigationState fState =
                            bottom.currentState;
                        fState.setPage(g.page - 1);
                      }),
                  new Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.indigo[700],
                      Colors.white
                    ])),
                  ),
                  new ListTile(
                      leading: Image.asset(
                        "assets/myinternships.png",
                        height: 30,
                        width: 30,
                      ),
                      title: new Text("My Internships"),
                      onTap: () {
                        _home.currentState.openEndDrawer();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Projectsmypage(),
                            ));
                      }),
                  new Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.indigo[700],
                      Colors.white
                    ])),
                  ),
                  new ListTile(
                      leading: Image.asset(
                        "assets/myprojects.png",
                        height: 30,
                        width: 30,
                      ),
                      title: new Text("My Projects"),
                      onTap: () {
                        setState(() {
                          mylist = true;
                          g.page = 3;
                          fromdrawer = true;
                        });
                        _home.currentState.openEndDrawer();
                        final FancyBottomNavigationState fState =
                            bottom.currentState;
                        fState.setPage(g.page - 1);
                      }),
                  new Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.indigo[700],
                      Colors.white
                    ])),
                  ),
                  new ListTile(
                      leading: Image.asset(
                        "assets/mytele1.png",
                        color: Colors.blue.shade900,
                        height: 30,
                        width: 30,
                      ),
                      title: new Text("My Telecallings"),
                      onTap: () {
                        setState(() {
                          g.page = 4;
                          mylist = true;
                          fromdrawer = true;
                        });
                        _home.currentState.openEndDrawer();
                        final FancyBottomNavigationState fState =
                            bottom.currentState;
                        fState.setPage(g.page - 1);
                      }),
                  new Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.indigo[700],
                      Colors.white
                    ])),
                  ),
                  new ListTile(
                      leading: Image.asset(
                        "assets/wallet.png",
                        height: 24,
                        width: 24,
                      ),
                      title: new Text("Wallet"),
                      onTap: () {
                        _home.currentState.openEndDrawer();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Wallet(),
                            ));
                      }),
                  new Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.indigo[700],
                      Colors.white
                    ])),
                  ),
                  new ListTile(
                      leading: Image.asset(
                        "assets/referral.png",
                        height: 24,
                        width: 24,
                      ),
                      title: new Text("Referral code"),
                      onTap: () {
                        _home.currentState.openEndDrawer();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Referral(),
                            ));
                      }),
                  new Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.indigo[700],
                      Colors.white
                    ])),
                  ),
                  new ListTile(
                      leading: Image.asset(
                        "assets/contact.png",
                        height: 24,
                        width: 24,
                      ),
                      title: new Text("Contact Us"),
                      subtitle: (contactus)
                          ? Text(
                              "help@herody.in",
                              style: TextStyle(color: Colors.pink),
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          contactus = !contactus;
                        });
                      }),
                  new Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.indigo[700],
                      Colors.white
                    ])),
                  ),
                  new ListTile(
                      leading: Image.asset(
                        "assets/report.png",
                        height: 30,
                        width: 30,
                      ),
                      title: new Text("Report a Bug"),
                      onTap: () async {
                        final Email email = Email(
                          body: 'Herody Email - ' +
                              g.data["email"] +
                              '\n\nProblem - ',
                          subject: '',
                          recipients: ['report@herody.in'],
                          isHTML: false,
                        );
                        await FlutterEmailSender.send(email);
                      }),
                  new Container(
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.indigo[700],
                      Colors.white
                    ])),
                  ),
                  if (g.data["email"] == "nagulan1645@gmail.com" ||
                      g.data["email"] == "nagulan2000@gmail.com")
                    new ListTile(
                        leading: Image.network(
                          "https://i0.wp.com/www.qaiware.com/wp-content/uploads/2016/03/full-stack-developer-icon.png",
                          height: 30,
                          width: 30,
                        ),
                        title: new Text("Developer Info"),
                        onTap: () async {
                          _home.currentState.openEndDrawer();
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Developerpage(),
                              ));
                        }),
                  if (g.data["email"] == "nagulan1645@gmail.com" ||
                      g.data["email"] == "nagulan2000@gmail.com")
                    new Container(
                      height: 1,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                        Colors.white,
                        Colors.indigo[700],
                        Colors.white
                      ])),
                    ),
                  new ListTile(
                      leading: Image.asset(
                        "assets/logout.png",
                        height: 30,
                        width: 30,
                      ),
                      title: new Text("Logout"),
                      onTap: () {
                        signOut();
                      }),
                ],
              ),
            ),
            body: Container(
              child: GestureDetector(
                onHorizontalDragStart: (details) {
                  mov = 0;
                },
                behavior: HitTestBehavior.translucent,
                onHorizontalDragEnd: (details) {
                  print(mov);
                  if (mov < -40) {
                    setState(() {
                      if (g.page != 4) g.page++;
                    });
                    final FancyBottomNavigationState fState =
                        bottom.currentState;
                    fState.setPage(g.page - 1);
                  } else if (mov > 40) {
                    setState(() {
                      if (g.page != 1) g.page--;
                    });
                    final FancyBottomNavigationState fState =
                        bottom.currentState;
                    fState.setPage(g.page - 1);
                  }
                  mov = 0;
                },
                onHorizontalDragUpdate: (details) {
                  mov = mov + details.delta.dx;
                  /*if (details.delta.dx > 0) {
          print(g.page.toString()+" start "+details.delta.dx.toString());
          setState(() {
            if(g.page!=1)
            g.page=2;
          });
          print(g.page.toString()+" end");
        } else if(details.delta.dx < -0){
            print(g.page.toString()+" start");
          setState(() {
            if(g.page!=4)
            g.page=3;
          });
          print(g.page.toString()+" end");
        }*/
                },
                child: Container(child: _diaplaylist()),
              ),
            )));
  }
}
