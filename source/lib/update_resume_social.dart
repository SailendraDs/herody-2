import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'globaldata.dart' as g;

class SocialEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SocialEditState();
}

class _SocialEditState extends State<SocialEdit> {
  String _fb = "";
  String _insta = "";
  String _linkedin = "";
  String _github = "";
  String _twitter = "";
  bool _isLoading = false;
  bool onclick = true;
  final _formKey = new GlobalKey<FormState>();

  Widget showFacebookInput() {
    return Container(
      width: 300,
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15),
      child: Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: new TextFormField(
            initialValue: g.data["fb"],
            maxLines: 1,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Facebook ID',
            ),
            onSaved: (value) => _fb = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showInstagramInput() {
    return Container(
      width: 300,
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15),
      child: Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: new TextFormField(
            initialValue: g.data["insta"],
            maxLines: 1,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Instagram Handle',
            ),
            onSaved: (value) => _insta = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showLinkedinInput() {
    return Container(
      width: 300,
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15),
      child: Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: new TextFormField(
            initialValue: g.data["linkedin"],
            maxLines: 1,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Linkedin ID',
            ),
            onSaved: (value) => _linkedin = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showTwitterInput() {
    return Container(
      width: 300,
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15),
      child: Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: new TextFormField(
            initialValue: g.data["twitter"],
            maxLines: 1,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Twitter Handle',
            ),
            onSaved: (value) => _twitter = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showGithubInput() {
    return Container(
      width: 300,
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15),
      child: Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: new TextFormField(
            initialValue: g.data["github"],
            maxLines: 1,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Github Username',
            ),
            onSaved: (value) => _github = value.trim(),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      print("validated");
      setState(() {
        _isLoading = true;
        onclick = true;
      });
      String url = g.preurl + "user/socialUpdate";
      var js = {
        "uid": g.uid,
        if (_fb != "") "fb": _fb,
        if (_insta != "") "insta": _insta,
        if (_linkedin != "") "linkedin": _linkedin,
        if (_github != "") "github": _github,
        if (_twitter != "") "twitter": _twitter
      };
      Response response = await post(url, body: js);
      var d = json.decode(response.body);
      setState(() {
        _isLoading = false;
        onclick = false;
      });
      Navigator.pop(context);
    }
  }

  Widget _showCircularProgress() {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(
                (_isLoading) ? Colors.white : Colors.transparent)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Herody",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Edit Social Profiles ID",
              style: TextStyle(color: Colors.white)),
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              if (!_isLoading) Navigator.pop(context);
            },
          ),
          backgroundColor: (_isLoading) ? Colors.pink : Colors.indigo[900],
          actions: [
            if (_isLoading)
              Padding(
                padding: EdgeInsets.fromLTRB(0, 23, 0, 0),
                child: Text(
                  "saving   ",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            if (_isLoading) _showCircularProgress(),
            if (!_isLoading)
              Padding(
                padding: EdgeInsets.fromLTRB(0, 23, 0, 0),
                child: Text(
                  "save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            if (!_isLoading)
              IconButton(
                color: Colors.white,
                icon: Icon(Icons.done_all),
                onPressed: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  validateAndSubmit();
                },
              ),
          ],
        ),
        body: Container(
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text("Facebook"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/facebook.png"
                          //"https://1000logos.net/wp-content/uploads/2016/11/Facebook-Logo.png"
                          ,
                          height: 25,
                          width: 25,
                        ),
                        showFacebookInput(),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text("Instagram"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/insta.jfif",
                          //"https://www.edigitalagency.com.au/wp-content/uploads/new-instagram-logo-png-transparent-light.png",
                          height: 25,
                          width: 25,
                        ),
                        showInstagramInput(),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text("Linkedin"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/linkedin.png",
                          // "https://www2.le.ac.uk/offices/careers-new/copy2_of_images/linkedin-logo/image",
                          height: 25,
                          width: 25,
                        ),
                        showLinkedinInput(),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text("Twitter"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://elementarylibrarian.com/wp-content/uploads/2013/11/twitter-bird-white-on-blue.png",
                          height: 25,
                          width: 25,
                        ),
                        showTwitterInput(),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text("Github"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          "https://cdn.iconscout.com/icon/free/png-256/github-153-675523.png",
                          height: 25,
                          width: 25,
                        ),
                        showGithubInput(),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
