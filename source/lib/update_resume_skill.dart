import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'globaldata.dart' as g;

class SkillEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SkillEditState();
}

class _SkillEditState extends State<SkillEdit> {
  String _sname=null;
  int rate=0;
  bool _isLoading = false;
  bool onclick=true;
  final _formKey = new GlobalKey<FormState>();

  Widget showNameInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child:Card(
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
            validator: (value) => value.trim().isEmpty ? 'Name can\'t be empty' : null,
            onSaved: (value) => _sname = value.trim(),
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
    String url=g.preurl+"user/skillsUpdate";
    Response response=await post(url,body: {"uid":g.uid,"name":_sname,"rating":rate.toString()});
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
              title: Text("Add Skill",style: TextStyle(color: Colors.white)),
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
                          child: Text("Skill name"),
                        ),
                        showNameInput(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                          child: Text("Rate your Skill"),
                        ),
                        Row(
                          children: [
                            Text("  "),
                            (rate>=1)?
                            IconButton(
                              icon: Icon(Icons.star,color: Colors.yellow[700],), 
                              onPressed: () {
                                setState(() {
                                  rate=1;
                                });
                              },
                            ):
                            IconButton(
                              icon: Icon(Icons.star_border,color: Colors.yellow[700]), 
                              onPressed: () {
                                setState(() {
                                  rate=1;
                                });
                              },
                            ),
                            (rate>=2)?
                            IconButton(
                              icon: Icon(Icons.star,color: Colors.yellow[700]), 
                              onPressed: () {
                                setState(() {
                                  rate=2;
                                });
                              },
                            ):
                            IconButton(
                              icon: Icon(Icons.star_border,color: Colors.yellow[700]), 
                              onPressed: () {
                                setState(() {
                                  rate=2;
                                });
                              },
                            ),
                            (rate>=3)?
                            IconButton(
                              icon: Icon(Icons.star,color: Colors.yellow[700]), 
                              onPressed: () {
                                setState(() {
                                  rate=3;
                                });
                              },
                            ):
                            IconButton(
                              icon: Icon(Icons.star_border,color: Colors.yellow[700]), 
                              onPressed: () {
                                setState(() {
                                  rate=3;
                                });
                              },
                            ),
                            (rate>=4)?
                            IconButton(
                              icon: Icon(Icons.star,color: Colors.yellow[700]), 
                              onPressed: () {
                                setState(() {
                                  rate=4;
                                });
                              },
                            ):
                            IconButton(
                              icon: Icon(Icons.star_border,color: Colors.yellow[700]), 
                              onPressed: () {
                                setState(() {
                                  rate=4;
                                });
                              },
                            ),
                            (rate>=5)?
                            IconButton(
                              icon: Icon(Icons.star,color: Colors.yellow[700]), 
                              onPressed: () {
                                setState(() {
                                  rate=5;
                                });
                              },
                            ):
                            IconButton(
                              icon: Icon(Icons.star_border,color: Colors.yellow[700]), 
                              onPressed: () {
                                setState(() {
                                  rate=5;
                                });
                              },
                            ),
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