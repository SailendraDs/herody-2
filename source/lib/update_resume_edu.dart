import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'globaldata.dart' as g;

class EducationEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _EducationEditState();
}

class _EducationEditState extends State<EducationEdit> {
  String _ename = null;
  String _etype;
  String _ecourse;
  String _estart;
  String _eend;
  bool _isLoading = false;
  bool onclick = true;
  final _formKey = new GlobalKey<FormState>();

  Widget showNameInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child: Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Name',
            ),
            validator: (value) => value.trim().isEmpty
                ? 'Institution name can\'t be empty'
                : null,
            onSaved: (value) => _ename = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showTypeInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child: Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Like School /College /...',
            ),
            validator: (value) => value.trim().isEmpty
                ? 'Type of Education can\'t be empty'
                : null,
            onSaved: (value) => _etype = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showCourseInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child: Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Course',
            ),
            validator: (value) =>
                value.trim().isEmpty ? 'Course can\'t be empty' : null,
            onSaved: (value) => _ecourse = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showStartInput() {
    return Container(
      width: 170,
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child: Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          width: 150,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
          child: PinInputTextFormField(
            decoration: UnderlineDecoration(
                textStyle: TextStyle(fontSize: 18, color: Colors.black),
                colorBuilder: PinListenColorBuilder(Colors.blue, Colors.pink)),
            pinLength: 4,
            validator: (value) => (value.trim().isEmpty) ? "Empty !" : null,
            onSaved: (value) => _estart = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showEndInput() {
    return Container(
      width: 170,
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child: Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          width: 150,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
          child: PinInputTextFormField(
            decoration: UnderlineDecoration(
                textStyle: TextStyle(fontSize: 18, color: Colors.black),
                colorBuilder: PinListenColorBuilder(Colors.blue, Colors.pink)),
            pinLength: 4,
            validator: (value) => (value.trim().isEmpty) ? "Empty !" : null,
            onSaved: (value) => _eend = value.trim(),
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
      String url = g.preurl + "user/eduUpdate";
      Response response = await post(url, body: {
        "uid": g.uid,
        "name": _ename,
        "type": _etype,
        "start": _estart,
        "course": _ecourse,
        "end": _eend
      });
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
          title: Text("Add Education", style: TextStyle(color: Colors.white)),
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
                      child: Text("Educational Institution name"),
                    ),
                    showNameInput(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text("Type of Educational Institution"),
                    ),
                    showTypeInput(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text("Course / Degree"),
                    ),
                    showCourseInput(),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                              child: Text("Starting Year"),
                            ),
                            showStartInput()
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                              child: Text("Finishing Year"),
                            ),
                            showEndInput()
                          ],
                        )
                      ],
                    )
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
