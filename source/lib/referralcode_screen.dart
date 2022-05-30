import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:herody/referral_page.dart';
import 'globaldata.dart' as g;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:herody/home_page.dart';

class ReferralCode extends StatefulWidget {
  final String uid;
  ReferralCode({this.uid, this.loggedin});
  final VoidCallback loggedin;
  @override
  _ReferralCodeState createState() => _ReferralCodeState(loggedin: loggedin);
}

class _ReferralCodeState extends State<ReferralCode> {
  _ReferralCodeState({this.loggedin});
  final VoidCallback loggedin;

  String uid;
  SharedPreferences prefs;
  String refferalcode;
  bool onclick = false;
  bool autovalidate = false;
  var data = null;
  String message;
  String codeMessage;
  var status;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = widget.uid ?? "";
  }

  void logoutCallback() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs?.clear();
      status = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              // ignore: deprecated_member_use
              autovalidate: autovalidate,
              child: Container(
                padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15.0),
                child: Card(
                  elevation: 5,
                  color: Colors.blue[50],
                  child: TextFormField(
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: false,
                    decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Referral code',
                        contentPadding: EdgeInsets.only(left: 10)),
                    validator: (value) =>
                        value.trim().isEmpty ? 'Field is empty' : null,
                    onSaved: (value) => refferalcode = value.trim(),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 5, 10.0, 5.0),
                  child: SizedBox(
//                        height: 50,
                    width: 110,
                    child: RaisedButton(
                      child: Text(
                        'Confirm',
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      color: !onclick ? Colors.indigo[900] : Colors.pink,
                      onPressed: () {
                        setState(() {
                          onclick = !onclick;
                        });
                        validateSubmit();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 5, 10.0, 5.0),
                  child: SizedBox(
                    width: 100,
                    child: RaisedButton(
                      child: Text(
                        'Skip',
                        style: TextStyle(fontSize: 15.0, color: Colors.white),
                      ),
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(10.0)),
                      color: !onclick ? Colors.pink : Colors.indigo[900],
                      onPressed: () async {
                        setState(() {
                          onclick = !onclick;
                        });

                        // widget.loggedin();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Referral(
                                    //logoutCallback: logoutCallback,
                                    )));
                      },
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void validateSubmit() async {
    if (_formKey.currentState.validate()) {
      try {
        _formKey.currentState.save();
        var url = g.preurl + 'user/storeRef';

        final response =
            await post(url, body: {"uid": uid, "ref": refferalcode});
        var data = jsonDecode(response.body);
        codeMessage = data["response"]["code"];
        if (codeMessage == "SUCCESS") {
          message = "succesfully applied";
          _showMyDialog(message, codeMessage);
          print('hellooo');
        } else {
          message = "not applied, Retry";
          _showMyDialog(message, codeMessage);
        }
      } catch (e, s) {
        print(s);
      }
    } else {
      autovalidate = true;
    }
  }

  Future<void> _showMyDialog(String message, String code) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Hi There,'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Referral code is ${message}'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok '),
              onPressed: () {
                Navigator.of(context).pop();
                if (code == 'SUCCESS') {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => MyApp(
                            logoutCallback: logoutCallback,
                          )));
                }
              },
            ),
          ],
        );
      },
    );
  }
}
