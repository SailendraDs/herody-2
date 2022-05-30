import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'globaldata.dart' as g;

class HobbyEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HobbyEditState();
}

class _HobbyEditState extends State<HobbyEdit> {
  String _hobby=g.data["hobbies"]==null?",":g.data["hobbies"];
  bool _isLoading = false;
  bool onclick=true;
  final _formKey = new GlobalKey<FormState>();

  Widget showHobbyInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 15.0, 0, 0.0),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextFormField(
            minLines: 4,
            maxLines: 20,
            autocorrect: false,
            decoration: InputDecoration(
            hintText: 'Write your Hobbies with comma separated here.\nex:-\nPlaying,Drawing....',
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
      validator: (value) => value.trim().isEmpty ? 'Hobby can\'t be empty' : null,
      onSaved: (value) => _hobby=_hobby+value.trim()+",",
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
    String url=g.preurl+"user/hobbiesUpdate";
    Response response=await post(url,body:{"uid":g.uid,"hobby":_hobby});
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
              title: Text("Add Hobby",style: TextStyle(color: Colors.white)),
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
                          child: Text("Enter your Hobbies/Hobby"),
                        ),
                        showHobbyInput(),
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