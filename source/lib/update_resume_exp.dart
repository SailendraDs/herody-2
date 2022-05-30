import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'globaldata.dart' as g;

class ExperienceEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ExperienceEditState();
}

class _ExperienceEditState extends State<ExperienceEdit> {
  String _cname = null;
  String _udesig = null;
  String _udes = null;
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
              hintText: 'Company name',
            ),
            validator: (value) =>
                value.trim().isEmpty ? 'Name can\'t be empty' : null,
            onSaved: (value) => _cname = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showdesignationInput() {
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
              hintText: 'Position in Company',
            ),
            validator: (value) =>
                value.trim().isEmpty ? 'Designation can\'t be empty' : null,
            onSaved: (value) => _udesig = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showdescriptionInput() {
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
              hintText: 'In short....',
            ),
            validator: (value) =>
                value.trim().isEmpty ? 'Description can\'t be empty' : null,
            onSaved: (value) => _udes = value.trim(),
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
                textStyle: TextStyle(fontSize: 20, color: Colors.black),
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
      String url = g.preurl + "user/expUpdate";
      Response response = await post(url, body: {
        "uid": g.uid,
        "company": _cname,
        "designation": _udesig,
        "des": _udes,
        "start": _estart,
        "end": _eend
      });
      var d = json.decode(response.body);
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
          title: Text("Add Experience", style: TextStyle(color: Colors.white)),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text("Company"),
                    ),
                    showNameInput(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text("Designation"),
                    ),
                    showdesignationInput(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text("Description"),
                    ),
                    showdescriptionInput(),
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
                            showEndInput(),
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
