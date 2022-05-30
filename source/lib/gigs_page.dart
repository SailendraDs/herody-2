import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'gig_details.dart';
import 'globaldata.dart' as g;

class Gigspage extends StatefulWidget {
  @override
  _GigspageState createState() => new _GigspageState();
}

class _GigspageState extends State<Gigspage> {
  var data;
  bool servererror = false;

  void getdata() async {
    String url = g.preurl + "gigs";
    Response response = await post(url);
    try {
      setState(() {
        data = json.decode(response.body)["response"]["gigs"];
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

  Widget gigslist() {
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
                child: Row(
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                        child: Image(
                            image: (data[i]["user_id"] == "Admin")
                                ? NetworkImage(
                                    "https://herody.in/assets/admin/img/gig-brand-logo/" +
                                        data[i]["logo"])
                                : NetworkImage(
                                    "https://herody.in/assets/employer/profile_images/" +
                                        data[i]["logo"]),
                            loadingBuilder: (context, child, loadingProgress) =>
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
                        padding: EdgeInsets.fromLTRB(0, 10, 5, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - 150,
                              child: Text(
                                data[i]["campaign_title"],
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600]),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width - 150,
                              child: Text(
                                data[i]["brand"],
                                style: TextStyle(color: Colors.pink[700]),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ),
                            Container(height: 10),
                            Container(
                                decoration: myBoxDecoration(),
                                alignment: Alignment.bottomRight,
                                padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                child: Row(
                                  children: [
                                    //Image.asset("assets/rupee.png",height:20),
                                    Text(
                                      "₹ " + data[i]["per_cost"].toString(),
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
            onTap: () {
              print("1");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Gigdetails(
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
                        "Sorry, there are currently no Gigs",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.grey[800]),
                      ),
                      Container(
                        height: 100,
                        width: 20,
                      )
                    ]),
              )
            : gigslist();
  }
}
