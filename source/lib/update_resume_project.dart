import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'globaldata.dart' as g;

class ProjectEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ProjectEditState();
}

class _ProjectEditState extends State<ProjectEdit> {
  String _pname;
  String _pdes;
  bool _isLoading = false;
  bool onclick=true;
  final _formKey = new GlobalKey<FormState>();

  Widget showNameInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child:Card(
        elevation: 0,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Name of Project',
              enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
            ),
            validator: (value) => value.trim().isEmpty ? 'Project name can\'t be empty' : null,
            onSaved: (value) => _pname = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showProjectDesInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 0.0),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
            minLines: 5,
            maxLines: 20,
            autocorrect: false,
            decoration: InputDecoration(
            hintText: 'Describe your project here...',
            filled: true,
            fillColor: Color(0xFFDBEDFF),
            enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      validator: (value) => value.trim().isEmpty ? 'Project Description can\'t be empty' : null,
      onSaved: (value) => _pdes=value.trim(),
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
    String url=g.preurl+"user/projectsUpdate";
    Response response=await post(url,body: {"uid":g.uid,"title":_pname,"projdes":_pdes});
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
              title: Text("Add Project",style: TextStyle(color: Colors.white)),
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon:Icon(Icons.clear),
                onPressed:(){ if(!_isLoading)Navigator.pop(context);},
              ),
              backgroundColor: (_isLoading)?Colors.pink:Colors.indigo[900],
              actions: [
                  if(_isLoading)Padding(
                    padding: EdgeInsets.fromLTRB(0, 23, 0, 0),
                    child:Text("saving   ",style: TextStyle(color: Colors.white),),
                  ),
                  if(_isLoading)_showCircularProgress(),
                  if(!_isLoading)Padding(
                    padding: EdgeInsets.fromLTRB(0, 23, 0, 0),
                    child:Text("save",style: TextStyle(color: Colors.white),),
                  ),
                  if(!_isLoading)IconButton(
                    color: Colors.white,
                    icon:Icon(Icons.done_all),
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
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                          child: Text("Title"),
                        ),
                        showNameInput(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                          child: Text("Project Description"),
                        ),
                        showProjectDesInput(),
                              ],
                            )
                          ],
                        )
                    )
                ),
              ),
    );
  }
}