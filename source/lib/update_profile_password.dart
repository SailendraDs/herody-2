import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'globaldata.dart' as g;

class PasswordEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _PasswordEditState();
}

class _PasswordEditState extends State<PasswordEdit> {
  String _oldpass=null;
  String _newpass=null;
  bool _isLoading = false;
  bool onclick=true;
  final _formKey = new GlobalKey<FormState>();

  Widget showOldpasswordInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child:Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: new TextFormField(
            maxLines: 1,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Old password',
            ),
            validator: (value) => value.isEmpty ? 'can\'t be empty' : null,
            onSaved: (value) => _oldpass = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showNewpasswordInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child:Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: new TextFormField(
            maxLines: 1,
            obscureText: true,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'New password',
            ),
            validator: (value) => value.isEmpty ? 'can\'t be empty' : null,
            onSaved: (value) => _newpass = value.trim(),
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
      onclick=true;
    });
    String url=g.preurl+"user/passUpdate";
    Response response=await post(url,body: {"id":g.uid,"password":_newpass,"current_password":_oldpass});
    var d = json.decode(response.body);
    setState(() {
      _isLoading = false;
      onclick=false;
    });
    Navigator.pop(context);
    }
  }

  Widget _showCircularProgress() {
      return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: CircularProgressIndicator(valueColor:new AlwaysStoppedAnimation<Color>((_isLoading)?Colors.white:Colors.transparent)));

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Herody",
          debugShowCheckedModeBanner: false,
          home:Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text("Change Password",style: TextStyle(color: Colors.white)),
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon:Icon(Icons.clear),
                onPressed:(){ if(!_isLoading)Navigator.pop(context);},
              ),
              backgroundColor: (_isLoading)?Colors.pink:Colors.indigo[900],
              actions: [
                  if(_isLoading)Padding(
                    padding: EdgeInsets.fromLTRB(0, 23, 0, 0),
                    child:Text("changing   ",style: TextStyle(color: Colors.white),),
                  ),
                  if(_isLoading)_showCircularProgress(),
                  if(!_isLoading)Padding(
                    padding: EdgeInsets.fromLTRB(0, 23, 0, 0),
                    child:Text("change",style: TextStyle(color: Colors.white),),
                  ),
                  if(!_isLoading)IconButton(
                    color: Colors.white,
                    icon:Icon(Icons.settings_backup_restore),
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
            body:Container( 
              child:Form(
                key: _formKey,
                child:ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                          child: Text("Old Password"),
                        ),
                        showOldpasswordInput(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                          child: Text("New Password"),
                        ),
                        showNewpasswordInput(),
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