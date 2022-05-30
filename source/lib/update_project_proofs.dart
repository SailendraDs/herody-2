import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'globaldata.dart' as g;
import 'package:image_picker/image_picker.dart';

class Submitproofs extends StatefulWidget {
  Submitproofs({this.id,this.prooffile,this.proofimage,this.prooflink});
  final String id;
  final int proofimage;
  final int prooffile;
  final int prooflink;
  
  @override
  State<StatefulWidget> createState() => new _SubmitproofsState(id:id,prooffile: prooffile,proofimage: proofimage,prooflink: prooflink);
}

class _SubmitproofsState extends State<Submitproofs> {
  _SubmitproofsState({this.id,this.prooffile,this.proofimage,this.prooflink});
  final String id;
  final int proofimage;
  final int prooffile;
  final int prooflink;
  String _errorMessage="";
  bool _isLoading = false;
  bool onclick=true;
  File image;
  File file;
  String image_source,file_source,link;
  final _formKey = new GlobalKey<FormState>();
  //Dio dio=new Dio();

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Container(
        alignment: Alignment.center,
        child:new Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: new Text(
        _errorMessage,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 20.0,
            color: Colors.red,
            fontWeight: FontWeight.bold),
        )
        )
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  pickImageFromGallery(ImageSource s) async{
    var picker=ImagePicker();
      var imagef =await picker.getImage(source: s);
      if(imagef!=null)print(imagef.path);
      final LostData response =
          await picker.getLostData();
      if (response.file != null) {
        setState(() {
          imagef=response.file;
        });
      }
      setState(() {
        if(imagef!=null)image_source=imagef.path;
        if(imagef!=null)image=File(image_source);
      });
  }

  pickFile() async{
    print("1-----1");
    String path=await FilePicker.getFilePath(type: FileType.any);
    print(path);
    setState(() {
      file_source=path;
    });
  }

  Widget showImage() {
    return Container(
            padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child:Image.file(
              image,
              width: 100,
              height: 100,
            )
          );
  }

  Widget showImageInput(){
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child:RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
      child: Container(
        child:Text("Select an Image",style: TextStyle(color: Colors.white),)
      ),
      color: Colors.indigo[700],
      onPressed: () {
        pickImageFromGallery(ImageSource.gallery);
      }
    )
    );
  }

  Widget showFileInput(){
    return Container(
      padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
      child:RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
        ),
      child: Container(
        child:Text("Select an File",style: TextStyle(color: Colors.white),)
      ),
      color: Colors.indigo[700],
      onPressed: () {
        pickFile();
      }
    )
    );
  }

  Widget showLinkInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child:Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.text,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Proof Link',
            ),
            validator: (value) => value.trim().isEmpty?"Can\'t be empty":null,
            onSaved: (value) => link = value.trim(),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    int i=1;
    if (proofimage==1) {
      if(image_source==null)
      i=i*0;
    }
    if (prooffile==1) {
      if(file_source==null)
      i=i*0;
    }
    if (prooflink==1) {
      if(form.validate())
      form.save();
      else
      i=i*0;
    }
    if(i==1)
    return true;
    else
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      print("validated");
      setState(() {
        _errorMessage="";
      _isLoading = true;
      onclick=true;
    });
    String url=g.preurl+"project/proofs";
    var request = MultipartRequest('POST', Uri.parse(url));
    request.files.add(
      MultipartFile.fromString(
        'id',id
      )
    );
    request.files.add(
      MultipartFile.fromString(
        'uid',g.uid
      )
    );
    if(proofimage==1)request.files.add(
      await MultipartFile.fromPath('image',image_source)
    );
    if(prooffile==1)request.files.add(
      await MultipartFile.fromPath('file',file_source)
    );
    if(prooflink==1)request.files.add(
      MultipartFile.fromString('link',link)
    );
    var res = await request.send();
    var response = await Response.fromStream(res);
    print(response.body);
    var data=json.decode(response.body);
    setState(() {
      if(data["response"]["code"]=="SUCCESS")
      _errorMessage="Successfully Submitted";
      else
      _errorMessage="Proof already Submitted";
      _isLoading = false;
      onclick=false;
    });
    Timer(Duration(milliseconds: 2000), () {
      Navigator.pop(context);
      });
    
    }
    else{
      setState(() {
        _errorMessage="Please submit all the required proofs";
      });
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
              title: Text("Submit Proofs",style: TextStyle(color: Colors.white)),
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon:Icon(Icons.clear),
                onPressed:(){ if(!_isLoading)Navigator.pop(context);},
              ),
              backgroundColor: (_isLoading)?Colors.pink:Colors.indigo[900],
              actions: [
                  if(_isLoading)Padding(
                    padding: EdgeInsets.fromLTRB(0, 23, 0, 0),
                    child:Text("submitting   ",style: TextStyle(color: Colors.white),),
                  ),
                  if(_isLoading)_showCircularProgress(),
                  if(!_isLoading)Padding(
                    padding: EdgeInsets.fromLTRB(0, 23, 0, 0),
                    child:Text("submit  ",style: TextStyle(color: Colors.white),),
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
                        if(proofimage==1)Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text("Image Proof"),
                        ),
                        if(image_source!=null)showImage(),
                        if(proofimage==1)showImageInput(),
                        if(prooffile==1)Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text("File Proof"),
                        ),
                        if(file_source!=null)Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Text(file_source.substring(file_source.lastIndexOf('/')+1),style: TextStyle(color:Colors.pink),),
                        ),
                        if(prooffile==1)Row(
                          children: [
                            showFileInput(),
                          ],
                        ),
                        if(prooflink==1)Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: Text("Link Proof"),
                        ),
                        if(prooflink==1)showLinkInput(),
                        showErrorMessage(),
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