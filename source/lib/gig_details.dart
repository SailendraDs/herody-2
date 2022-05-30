import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:herody/update_gig_proofs.dart';
import 'package:http/http.dart';
import 'globaldata.dart' as g;
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class Gigdetails extends StatefulWidget {
  Gigdetails({this.id, this.statusid});
  final String id;
  final int statusid;
  @override
  State<StatefulWidget> createState() =>
      new _GigdetailsState(id: id, statusid: statusid);
}

class _GigdetailsState extends State<Gigdetails> {
  _GigdetailsState({this.id, this.statusid});
  final String id;
  final int statusid;
  int sid = -2;
  var data;
  var pdata;
  var userdata;
  var applydata;
  bool onclick = false;
  bool applied = false;
  bool servererror = false;
  bool refresh = false;
  List<bool> proof = [false, false, false, false, false, false, false, false];
  int allproofs = 1;
  List status = [
    "Applied",
    "Application Approved",
    "Application Rejected",
    "Proof submitted",
    "Proof Accepted & paid",
    "Proof Rejected"
  ];

  void getdata() async {
    String url = g.preurl + "gig/details";
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

  void getproofs() async {
    String url = g.preurl + "gig/proofs";
    Response response = await post(url, body: {"id": id, "uid": g.uid});
    try {
      setState(() {
        pdata = json.decode(response.body)["response"];
        print("pdata");
        print(pdata);
      });
      checksubmission();
    } catch (e) {
      print(e);
    }
  }

  void checksubmission() {
    for (int i = 0; i < pdata["proofs"].length; i++) {
      if (pdata["proofs"][i]["proof_text"].toString().contains("Facebook"))
        setState(() {
          proof[0] = true;
        });
      if (pdata["proofs"][i]["proof_text"].toString().contains("Whatsapp"))
        setState(() {
          proof[1] = true;
        });
      if (pdata["proofs"][i]["proof_text"].toString().contains("Instagram") &&
          !pdata["proofs"][i]["proof_text"]
              .toString()
              .contains("Instagram Post"))
        setState(() {
          proof[2] = true;
        });
      if (pdata["proofs"][i]["proof_text"].toString().contains("Youtube"))
        setState(() {
          proof[3] = true;
        });
      if (pdata["proofs"][i]["proof_text"]
          .toString()
          .contains("Instagram Post"))
        setState(() {
          proof[4] = true;
        });
      if (pdata["proofs"][i]["proof_text"].toString().contains("Online Survey"))
        setState(() {
          proof[5] = true;
        });
      if (pdata["proofs"][i]["proof_text"].toString().contains("Download App"))
        setState(() {
          proof[6] = true;
        });
      if (pdata["proofs"][i]["proof_text"].toString().contains("Social Media"))
        setState(() {
          proof[7] = true;
        });
    }
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

  void submitdata() async {
    setState(() {
      onclick = true;
    });
    String url = g.preurl + "gig/apply";
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
      print("refreshing...");
      String url = g.preurl + "user/gigs";
      Response response = await post(url, body: {"id": g.uid});
      userdata = json.decode(response.body)["response"];
      try {
        int i;
        for (i = 0; i < userdata["gigsinfo"].length; i++) {
          if (userdata["gigsinfo"][i]["id"].toString() == id) {
            setState(() {
              if (userdata["gigs"][i]["status"] == 3 &&
                  pdata != null &&
                  (data["gig"]["cats"].toString().length / 3) ==
                      pdata["proofs"].length)
                sid = userdata["gigs"][i]["status"];
              else if (userdata["gigs"][i]["status"] != 3)
                sid = userdata["gigs"][i]["status"];
              else if (pdata != null) sid = 1;
              if (onclick != true) applied = true;
            });
            break;
          }
        }
        if (i == userdata["gigsinfo"].length) {
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
                      ? "Applied"
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

  Widget gigdetails() {
    return ListView(
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
                        "https://herody.in/assets/employer/profile_images/" +
                            data["company"]["profile_photo"]),
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
                      if (data["gig"]["brand"] != null)
                        Row(
                          children: [
                            Icon(
                              Icons.business,
                              color: Colors.black,
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                              width: MediaQuery.of(context).size.width - 260,
                              child: Text(
                                "Company: " + data["gig"]["brand"].toString(),
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
                          Text(
                            "  Reward: ₹" + data["gig"]["per_cost"].toString(),
                            style: TextStyle(color: Colors.grey[700]),
                          )
                        ],
                      ),
                      Text(" "),
                      Row(
                        children: [
                          Icon(
                            Icons.list,
                            color: Colors.black,
                          ),
                          Text("  Tasks: " + data["tasks"].length.toString(),
                              style: TextStyle(color: Colors.grey[700]))
                        ],
                      )
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
        Container(
          width: double.infinity,
          color: Colors.blue[100],
          height: 30,
          padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
          child: Text(
            "About Gig\n",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
            child: Html(
              data: data["gig"]["description"],
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
        if (data["company"]["description"] != null)
          Container(
            width: double.infinity,
            color: Colors.blue[100],
            height: 30,
            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
            child: Text(
              "About Company\n",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        if (data["company"]["website"] != null)
          Container(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
            child: InkWell(
              child: new Text(
                "Website: " + data["company"]["website"],
                style: TextStyle(color: Colors.pink),
              ),
              onTap: () {
                launch("http://" + data["company"]["website"]);
              },
            ),
          ),
        if (data["company"]["description"] != null)
          Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
              child: Html(
                data: data["company"]["description"],
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
            "Type of Tasks\n",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
            color: Colors.blueGrey[50],
            child: Column(
              children: [
                if (data["gig"]["cats"].toString().contains("1"))
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    margin: EdgeInsets.all(10),
                    shadowColor: Colors.blue,
                    elevation: 8,
                    child: Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.network(
                                  "https://herody.in/assets/admin/img/cate_img/202002241436_Facebook.jpg",
                                  height: 50,
                                  width: 50,
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  width: ((sid == 1 || sid == 5 || sid == 3) &&
                                          !proof[0])
                                      ? 150
                                      : 220,
                                  child: Text(
                                    "Share a post on Facebook",
                                    style: TextStyle(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            if ((sid == 1 || sid == 5 || sid == 3) && !proof[0])
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                color: Colors.pink,
                                child: Text(
                                  "Start Task",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Submitgigproofs(
                                            cat: 1,
                                            id: id,
                                            proofss: 1,
                                            prooflink: 1,
                                            proofcred: 0,
                                            proofemail: 0,
                                            proofphone: 0,
                                            posturl: "gig/proof/fb",
                                            proofun: 1),
                                      ));
                                  getproofs();
                                  await determine();
                                },
                              ),
                          ],
                        )),
                  ),
                if (data["gig"]["cats"].toString().contains("2"))
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    margin: EdgeInsets.all(10),
                    shadowColor: Colors.blue,
                    elevation: 8,
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                "https://herody.in/assets/admin/img/cate_img/202002241413_Whatsapp.jpg",
                                height: 50,
                                width: 50,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                width: ((sid == 1 || sid == 5 || sid == 3) &&
                                        !proof[1])
                                    ? 150
                                    : 220,
                                child: Text(
                                  "Share a message on Whatsapp",
                                  style: TextStyle(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          if ((sid == 1 || sid == 5 || sid == 3) && !proof[1])
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              color: Colors.pink,
                              child: Text(
                                "Start Task",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Submitgigproofs(
                                          cat: 2,
                                          id: id,
                                          proofss: 1,
                                          prooflink: 0,
                                          proofcred: 0,
                                          proofemail: 0,
                                          proofphone: 1,
                                          posturl: "gig/proof/wa",
                                          proofun: 0),
                                    ));
                                getproofs();
                                await determine();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                if (data["gig"]["cats"].toString().contains("3"))
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    margin: EdgeInsets.all(10),
                    shadowColor: Colors.blue,
                    elevation: 8,
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                "https://herody.in/assets/admin/img/cate_img/202002241424_Instagram.jpg",
                                height: 50,
                                width: 50,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                width: ((sid == 1 || sid == 5 || sid == 3) &&
                                        !proof[2])
                                    ? 150
                                    : 220,
                                child: Text(
                                  "Post an Instagram Story",
                                  style: TextStyle(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          if ((sid == 1 || sid == 5 || sid == 3) && !proof[2])
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              color: Colors.pink,
                              child: Text(
                                "Start Task",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Submitgigproofs(
                                          cat: 3,
                                          id: id,
                                          proofss: 1,
                                          prooflink: 1,
                                          proofcred: 0,
                                          proofemail: 0,
                                          proofphone: 0,
                                          posturl: "gig/proof/insta",
                                          proofun: 1),
                                    ));
                                getproofs();
                                await determine();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                if (data["gig"]["cats"].toString().contains("4"))
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    margin: EdgeInsets.all(10),
                    shadowColor: Colors.blue,
                    elevation: 8,
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                "https://herody.in/assets/admin/img/cate_img/202002241428_YouTube.jpg",
                                height: 50,
                                width: 50,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                width: ((sid == 1 || sid == 5 || sid == 3) &&
                                        !proof[3])
                                    ? 150
                                    : 220,
                                child: Text(
                                  "Like & Comment on a YouTube Video",
                                  style: TextStyle(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          if ((sid == 1 || sid == 5 || sid == 3) && !proof[3])
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              color: Colors.pink,
                              child: Text(
                                "Start Task",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Submitgigproofs(
                                          cat: 4,
                                          id: id,
                                          proofss: 1,
                                          prooflink: 0,
                                          proofcred: 0,
                                          proofemail: 0,
                                          proofphone: 0,
                                          posturl: "gig/proof/yt",
                                          proofun: 1),
                                    ));
                                getproofs();
                                await determine();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                if (data["gig"]["cats"].toString().contains("5"))
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    margin: EdgeInsets.all(10),
                    shadowColor: Colors.blue,
                    elevation: 8,
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                "https://herody.in/assets/admin/img/cate_img/202002241424_Instagram.jpg",
                                height: 50,
                                width: 50,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                width: ((sid == 1 || sid == 5 || sid == 3) &&
                                        !proof[4])
                                    ? 150
                                    : 220,
                                child: Text(
                                  "Make an Instagram Post",
                                  style: TextStyle(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          if ((sid == 1 || sid == 5 || sid == 3) && !proof[4])
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              color: Colors.pink,
                              child: Text(
                                "Start Task",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Submitgigproofs(
                                          cat: 5,
                                          id: id,
                                          proofss: 1,
                                          prooflink: 1,
                                          proofcred: 0,
                                          proofemail: 0,
                                          proofphone: 0,
                                          posturl: "gig/proof/instap",
                                          proofun: 1),
                                    ));
                                getproofs();
                                await determine();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                if (data["gig"]["cats"].toString().contains("6"))
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    margin: EdgeInsets.all(10),
                    shadowColor: Colors.blue,
                    elevation: 8,
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                "https://herody.in/assets/admin/img/cate_img/202002241316_survey.png",
                                height: 50,
                                width: 50,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                width: ((sid == 1 || sid == 5 || sid == 3) &&
                                        !proof[5])
                                    ? 150
                                    : 220,
                                child: Text(
                                  "Online Survey",
                                  style: TextStyle(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          if ((sid == 1 || sid == 5 || sid == 3) && !proof[5])
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              color: Colors.pink,
                              child: Text(
                                "Start Task",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Submitgigproofs(
                                          cat: 6,
                                          id: id,
                                          proofss: 1,
                                          prooflink: 0,
                                          proofcred: 0,
                                          proofemail: 1,
                                          proofphone: 0,
                                          posturl: "gig/proof/os",
                                          proofun: 0),
                                    ));
                                getproofs();
                                await determine();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                if (data["gig"]["cats"].toString().contains("7"))
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    margin: EdgeInsets.all(10),
                    shadowColor: Colors.blue,
                    elevation: 8,
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                "https://herody.in/assets/admin/img/cate_img/202002241340_App.png",
                                height: 50,
                                width: 50,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                width: ((sid == 1 || sid == 5 || sid == 3) &&
                                        !proof[6])
                                    ? 150
                                    : 220,
                                child: Text(
                                  "Download an App and register",
                                  style: TextStyle(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          if ((sid == 1 || sid == 5 || sid == 3) && !proof[6])
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              color: Colors.pink,
                              child: Text(
                                "Start Task",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Submitgigproofs(
                                          cat: 7,
                                          id: id,
                                          proofss: 1,
                                          prooflink: 0,
                                          proofcred: 1,
                                          proofemail: 0,
                                          proofphone: 0,
                                          posturl: "gig/proof/ar",
                                          proofun: 0),
                                    ));
                                getproofs();
                                await determine();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                if (data["gig"]["cats"].toString().contains("8"))
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    margin: EdgeInsets.all(10),
                    shadowColor: Colors.blue,
                    elevation: 8,
                    child: Container(
                      height: 60,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                "https://herody.in/assets/admin/img/cate_img/202002241357_Like%20Social.png",
                                height: 50,
                                width: 50,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                width: ((sid == 1 || sid == 5 || sid == 3) &&
                                        !proof[7])
                                    ? 150
                                    : 220,
                                child: Text(
                                  "Like / Follow social media account",
                                  style: TextStyle(),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          if ((sid == 1 || sid == 5 || sid == 3) && !proof[7])
                            RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              color: Colors.pink,
                              child: Text(
                                "Start Task",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => new Submitgigproofs(
                                          cat: 8,
                                          id: id,
                                          proofss: 0,
                                          prooflink: 0,
                                          proofcred: 1,
                                          proofemail: 0,
                                          proofphone: 0,
                                          posturl: "gig/proof/ls",
                                          proofun: 0),
                                    ));
                                getproofs();
                                await determine();
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            )),
        Container(
          width: double.infinity,
          color: Colors.blue[100],
          height: 30,
          padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
          child: Text(
            "Tasks\n",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: data == null ? 0 : data["tasks"].length,
          itemBuilder: (BuildContext context, i) {
            return Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 25, 10, 0),
                  child: Html(
                    data: data["tasks"][i]["task"],
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
            );
          },
          separatorBuilder: (context, index) {
            return Container(
              height: 0,
              width: 0,
            );
          },
        ),
        if (sid != -2) showPrimaryButton(),
        if (sid == 0)
          Text(
              "Your Application is currently being reviewed\nCheck the above Current Status for further details\n\n",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width / 30,
              )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print("------------------------");
    if (data == null && statusid != -1) sid = statusid;
    determine();
    if (data == null) getdata();
    if (pdata == null) getproofs();
    return MaterialApp(
      title: "Herody",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: Text(data == null ? "" : data["gig"]["campaign_title"],
                style: TextStyle(color: Colors.white)),
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
              : gigdetails()),
    );
  }
}
