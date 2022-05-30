import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'globaldata.dart' as g;
import 'package:image_picker/image_picker.dart';

class ProfileEdit extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  String _uname=null;
  String _ucity=null;
  String _ustate=null;
  String _uaddress=null;
  String _upincode=null;
  String _umobile=null;
  bool _isLoading = false;
  bool onclick=true;
  File imageFile;
  String source;
  final _formKey = new GlobalKey<FormState>();
  Dio dio=new Dio();

  void initState() {
    super.initState();
  }

  pickImageFromGallery() async{
    var picker=ImagePicker();
      var imagef =await picker.getImage(source: ImageSource.gallery,imageQuality: 20);
      print("path......");
      print(imagef.path);
      final LostData response =
          await picker.getLostData();
      if (response.file != null) {
        setState(() {
          imagef=response.file;
        });
      }
      setState(() {
        source=imagef.path;
        imageFile=File(source);
      });
  }

  Widget showImage() {
    return Container(
            padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child:Image.file(
              imageFile,
              width: 100,
              height: 100,
            )
          );
  }

  Widget showImageInput(){
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child:RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
        ),
      child: Container(
        child:Text("Select an Image",style: TextStyle(color: Colors.white),)
      ),
      color: Colors.indigo[700],
      onPressed: () {
        pickImageFromGallery();
      }
    )
    );
  }

  Widget showNameInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child:Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: new TextFormField(
            initialValue: g.data["name"],
            maxLines: 1,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Username',
            ),
            validator: (value) => value.trim().isEmpty ? 'Username can\'t be empty' : null,
            onSaved: (value) => _uname = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showemail() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child:Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: new TextFormField(
            readOnly: true,
            initialValue: g.data["email"],
            maxLines: 1,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget showPhoneInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child:Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: new TextFormField(
            initialValue: g.data["phone"],
            readOnly: (g.data["phone"]==null||g.data["phone"]=="null")?false:true,
            maxLines: 1,
            keyboardType: TextInputType.phone,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Mobile number',
            ),
            validator: (value) => value.trim().isEmpty ? 'Mobile Number can\'t be empty' :  value.trim().length!=10? "Enter a valid 10-digit Mobile Number":null,
            onSaved: (value) => _umobile = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showAddressInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child:Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: new TextFormField(
            initialValue: g.data["address"],
            maxLines: 1,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Current address',
            ),
            validator: (value) => value.trim().isEmpty ? 'Current address can\'t be empty' : null,
            onSaved: (value) => _uaddress = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showStateInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child:Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: new TextFormField(
            initialValue: g.data["state"],
            maxLines: 1,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'State',
            ),
            validator: (value) => value.trim().isEmpty ? 'State can\'t be empty' : null,
            onSaved: (value) => _ustate = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showCityInput() {
    return Container(
      width: 170,
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child:Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: new TextFormField(
            initialValue: g.data["city"],
            maxLines: 1,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'City',
            ),
            validator: (value) => value.trim().isEmpty ? 'City can\'t be empty' : null,
            onSaved: (value) => _ucity = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showPincodeInput() {
    return Container(
      width: 170,
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child:Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: new TextFormField(
            initialValue: g.data["zip_code"],
            maxLines: 1,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Pincode',
            ),
            validator: (value) => value.trim().isEmpty ? 'Pincode can\'t be empty' : null,
            onSaved: (value) => _upincode = value.trim(),
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
    String url=g.preurl+"user/profileUpdate";
    var bytes;
    String img64;
    if(source!=null)bytes = await imageFile.readAsBytes();
    if(source!=null)img64 = base64Encode(bytes);
    //print(source.substring(source.lastIndexOf('/')+1));
    FormData form= FormData.fromMap({
        "id": g.uid,
        "name": _uname,
        "state":_ustate,
        "city": _ucity,
        "address":_uaddress,
        "phone":_umobile,
        "zip_code":_upincode,
        //if(source!=null)"profile_photo": img64,
        //if(source!=null)"profile_photo": await MultipartFile.fromFile(source,filename: g.uid+"_"+source.substring(source.lastIndexOf('/')+1)),
    });
    Response response=await dio.post(url,data:form);
    print(response);
    url=g.preurl+"user/profileImage";
    var response2;
    var data1;
    if(source!=null)response2=await dio.post(url,data: {"id":g.uid,"profile_photo":img64,});
    if(source!=null)data1=json.decode(response2.toString());
    if(source!=null)print(data1);
    url=g.preurl+"user/details";
    var response1=await dio.post(url,data: {"id":g.uid});
    var data=json.decode(response1.toString());
    print(data);
    switch(data["response"]["code"]){
          case "SUCCESS":
            setState(() {
              g.data=(data["response"]["user"]);
            });
            break;
    }
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
              title: Text("Edit Profile",style: TextStyle(color: Colors.white)),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text("Profile Pic (Optional)"),
                        ),
                        if(imageFile!=null)showImage(),
                        showImageInput(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                          child: Text("Email",style: TextStyle(color: Colors.pink),),
                        ),
                        showemail(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                          child: Text("Name"),
                        ),
                        showNameInput(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                          child: Text("Mobile Number",style: TextStyle(color: (g.data["phone"]==null||g.data["phone"]=="null")?Colors.black:Colors.pink),),
                        ),
                        showPhoneInput(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                          child: Text("Address"),
                        ),
                        showAddressInput(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                          child: Text("State"),
                        ),
                        showStateInput(),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                                  child: Text("City"),
                                ),
                                showCityInput()
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                                  child: Text("Pincode"),
                                ),
                                showPincodeInput()
                              ],
                            )
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
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