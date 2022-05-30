import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_truecaller/flutter_truecaller.dart';
import 'package:http/http.dart';
import 'login_page.dart';
import 'dart:async';
import 'globaldata.dart' as g;
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'referralcode_screen.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  SharedPreferences prefs;
  var status;
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  bool servererror = false;

  @override
  void initState() {
    determine();
  }

  void determine() async {
    prefs = await SharedPreferences.getInstance();
    Timer(Duration(milliseconds: 000), () {
      setState(() {
        status = prefs.getBool('isLoggedIn') ?? false;
      });
    });
  }

  void loggedin() {
    setState(() {
      g.uid = prefs.getString("userid");
      status = prefs.getBool('isLoggedIn');
      print('Status is');
      print(status);
    });
  }

  void logoutCallback() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs?.clear();
      status = false;
    });
  }

  Widget buildMaintenanceScreen() {
    return Scaffold(
      backgroundColor: Colors.indigo[600],
      body: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Image(
              image: AssetImage("assets/maintenancelogo.png"),
              height: 100,
            ),
            Container(height: 10),
            Text(
              "HERODY under maintenance!",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0, 0),
                      blurRadius: 8.0,
                      color: Colors.black,
                    )
                  ]),
            ),
            Text(
              " Kindly check back later ",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width / 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.blue[50],
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0, 0),
                      blurRadius: 8.0,
                      color: Colors.black,
                    )
                  ]),
            ),
          ])),
    );
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      backgroundColor: Colors.indigo[600],
      body: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Image(
              image: AssetImage("assets/logo.png"),
              height: 60,
            ),
            Container(height: 10),
            Text(
              "HERODY",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0, 0),
                      blurRadius: 8.0,
                      color: Colors.black,
                    )
                  ]),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)),
              //child:SpinKitWave(color: Colors.white,type: SpinKitWaveType.center,)
            ),
          ])),
    );
  }

  void getdata() async {
    String url = g.preurl + "user/details";
    g.uid = await prefs.getString("userid");
    Response response = await post(url, body: {"id": g.uid});
    try {
      setState(() {
        g.data = (json.decode(response.body)["response"]["user"]);
      });
    } catch (e) {
      /*setState(() {
        servererror=true;
      });*/
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (status == null) {
      return Scaffold();
    } else {
      if (status) {
        if (g.data != null) {
          setState(() {
            g.page = 1;
          });
          print('Going to home page');

          //return ReferralCode(
          // uid: g.uid,
          //loggedin: loggedin,
          // );

          return new MyApp(
            logoutCallback: logoutCallback,
          );
//            my code(Niranjan)
//          return ReferralCode(uid: g.uid,);
        } else {
          if (servererror) {
            return buildMaintenanceScreen();
          } else {
            getdata();
            return buildWaitingScreen();
          }
        }
      } else {
        return new LoginSignupPage(loggedin: loggedin);
      }
    }
  }
}
