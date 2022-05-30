import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:herody/home_page.dart';
import 'package:herody/main.dart';
import 'package:herody/referralcode_screen.dart';
import 'globaldata.dart' as g;
//import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:flutter/services.dart';

class Referral extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ReferralState();
}

class _ReferralState extends State<Referral> {
  bool onclick = false;
  bool result = false;

  Future<void> share() async {
    await FlutterShare.share(
      title: 'This is my referral code',
      text:
          "Join Herody to participate in Internships,Gigs and Projects. Complete simple tasks from top brands to earn cash, rewards and certificates! Enter my referral code - " +
              g.data["ref_code"] +
              " and earn a bonus: \nhttps://herody.in/register/?code=" +
              g.data["ref_code"],
    );
  }

  Widget showPrimaryButton() {
    onclick = false;
    return new Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.0, 25, 16.0, 15),
        child: SizedBox(
          // height: 120.0,
          child: Column(
            children: [
              new RaisedButton(
                  elevation: 5.0,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: !onclick ? Colors.indigo[900] : Colors.pink,
                  child: new Text('Invite Friends',
                      style:
                          new TextStyle(fontSize: 20.0, color: Colors.white)),
                  onPressed: () {
                    onclick = true;
                    share();
                  }),
              SizedBox(
                height: 10,
              ),
              new RaisedButton(
                  elevation: 5.0,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: !onclick ? Colors.indigo[900] : Colors.pink,
                  child: new Text('Add Referral Code',
                      style:
                          new TextStyle(fontSize: 20.0, color: Colors.white)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReferralCode(
                            uid: g.uid,
                            //loggedin: loggedin,
                          ),
                        ));
                  }),
            ],
          ),
        ));
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Herody",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: Text("Referral code", style: TextStyle(color: Colors.white)),
            automaticallyImplyLeading: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Homepage(
                          //  uid: g.uid,
                          //loggedin: loggedin,
                          ),
                    ));
              },
            ),
            backgroundColor: Colors.indigo[900],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.all(10)),
              Image.asset("assets/refer.jpg"),
              Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width - 20,
                child: Text(
                  "Refer Herody App with your friends & earn 5% on every earning made by your referred friend. Hurry up! Rewards are for limited period.\n",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700]),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 6,
                ),
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "  Referral Code:",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[600]),
                  ),
                ),
                Container(
                    color: Colors.grey[800],
                    padding: EdgeInsets.all(5),
                    child: SelectableText(
                      (g.data["ref_code"] == null)
                          ? "Something's Wrong"
                          : g.data["ref_code"],
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    )),
                SnackBarPage()
              ]),
              if (g.data["ref_code"] != null) showPrimaryButton()
            ],
          ),
        ));
  }
}

class SnackBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.content_copy),
      onPressed: () {
        /*ClipboardManager.copyToClipBoard(g.data["ref_code"]).then((value) {
                          final snackBar = SnackBar(
            content: Text('Referral code copied'),
            action: SnackBarAction(
              label: 'ok',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          // Find the Scaffold in the widget tree and use
          // it to show a SnackBar.
          Scaffold.of(context).showSnackBar(snackBar);
                        });*/
        Clipboard.setData(new ClipboardData(
                text: "Join Herody to participate in Internships,Gigs and Projects. Complete simple tasks from top brands to earn cash, rewards and certificates! Enter my referral code - " +
                    g.data["ref_code"] +
                    " and earn a bonus: \nhttps://herody.in/register/?code=" +
                    g.data["ref_code"]))
            .then((value) {
          final snackBar = SnackBar(
            content: Text('Referral code copied'),
            action: SnackBarAction(
              label: 'ok',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          // Find the Scaffold in the widget tree and use
          // it to show a SnackBar.
          Scaffold.of(context).showSnackBar(snackBar);
        });
      },
    );
  }
}
