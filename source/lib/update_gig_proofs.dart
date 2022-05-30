import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'globaldata.dart' as g;
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class Submitgigproofs extends StatefulWidget {
  Submitgigproofs(
      {this.cat,
      this.id,
      this.proofss,
      this.prooflink,
      this.proofcred,
      this.posturl,
      this.proofemail,
      this.proofphone,
      this.proofun});
  final String id;
  final int proofun;
  final int proofphone;
  final int proofcred;
  final int proofemail;
  final int proofss;
  final int prooflink;
  final int cat;
  final String posturl;
  @override
  State<StatefulWidget> createState() => new _SubmitgigproofsState(
      cat: cat,
      id: id,
      proofss: proofss,
      prooflink: prooflink,
      proofcred: proofcred,
      proofemail: proofemail,
      proofphone: proofphone,
      posturl: posturl,
      proofun: proofun);
}

class _SubmitgigproofsState extends State<Submitgigproofs> {
  _SubmitgigproofsState(
      {this.cat,
      this.id,
      this.proofss,
      this.prooflink,
      this.proofcred,
      this.posturl,
      this.proofemail,
      this.proofphone,
      this.proofun});
  final String id;
  final int proofun;
  final int proofphone;
  final int proofcred;
  final int proofemail;
  final int proofss;
  final int prooflink;
  final int cat;
  final String posturl;
  String _errorMessage = "";
  bool _isLoading = false;
  bool onclick = true;
  File image;
  String image_source, link, un, phone, cred, email;
  final _formKey = new GlobalKey<FormState>();
  //List<Asset> images = List<Asset>();
  List<ByteData> images_bd = List<ByteData>();
  List images_source = new List();
  List<File> images = List<File>();

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Container(
          alignment: Alignment.center,
          child: new Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: new Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              )));
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget buildGridView() {
    return GridView.count(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      crossAxisCount: 3,
      children: List.generate(images_source.length, (index) {
        //images_bd[index]=asset.getByteData() as ByteData;
        /*return AssetThumb(
          asset: images[index],
          width: 100,
          height: 100,
          quality: 100,
        );*/
        return Container(
            padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: Image.file(
              images[index],
              width: 150,
              height: 150,
            ));
      }),
    );
  }

  /*Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#000083",
          actionBarTitle: "Select the Proofs",
          useDetailsView: false,
          startInAllView: true,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      images = resultList;
    });
  }*/

  pickImageFromGallery(ImageSource s) async {
    var picker = ImagePicker();
    var imagef = await picker.getImage(source: s);
    if (imagef != null) print(imagef.path);
    final LostData response = await picker.getLostData();
    if (response.file != null) {
      setState(() {
        imagef = response.file;
      });
    }
    setState(() {
      if (imagef != null) image_source = imagef.path;
      if (imagef != null) image = File(image_source);
    });
  }

  pickMultipleImageFromGallery(ImageSource s) async {
    var imagef = await ImagePicker.pickImage(source: s);
    if (imagef != null) print(imagef.path);
    setState(() {
      if (imagef != null) images.add(imagef);
      if (imagef != null) images_source.add(imagef.path);
    });
  }

  Widget showImage() {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
        child: Image.file(
          image,
          width: 150,
          height: 150,
        ));
  }

  Widget showMultipleImageInput() {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
                child: Text(
              images.length == 0 ? "Select an Image" : "Add another Image",
              style: TextStyle(color: Colors.white),
            )),
            color: Colors.indigo[700],
            onPressed: () {
              //loadAssets();
              pickMultipleImageFromGallery(ImageSource.gallery);
            }));
  }

  Widget showImageInput() {
    return Container(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
                child: Text(
              "Select an Image",
              style: TextStyle(color: Colors.white),
            )),
            color: Colors.indigo[700],
            onPressed: () {
              pickImageFromGallery(ImageSource.gallery);
            }));
  }

  Widget showLinkInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child: Card(
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
            validator: (value) =>
                value.trim().isEmpty ? "Can\'t be empty" : null,
            onSaved: (value) => link = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showNameinput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child: Card(
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
              hintText: 'Username',
            ),
            validator: (value) =>
                value.trim().isEmpty ? "Can\'t be empty" : null,
            onSaved: (value) => un = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showEmailnput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child: Card(
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
              hintText: 'Email',
            ),
            validator: (value) =>
                value.trim().isEmpty ? "Can\'t be empty" : null,
            onSaved: (value) => email = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showphoneinput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child: Card(
        elevation: 5,
        color: Colors.blue[50],
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.number,
            autofocus: false,
            decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Mobile number',
            ),
            validator: (value) =>
                value.trim().isEmpty ? "Can\'t be empty" : null,
            onSaved: (value) => phone = value.trim(),
          ),
        ),
      ),
    );
  }

  Widget showcredinput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child: Card(
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
              hintText: 'Credentials',
            ),
            validator: (value) =>
                value.trim().isEmpty ? "Can\'t be empty" : null,
            onSaved: (value) => cred = value.trim(),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      if (proofss == 1) {
        /*if(cat==7)
        {
          if(images.length>0){
            form.save();
            return(true);
          }
        }
        else */
        if (image_source != null) {
          form.save();
          return (true);
        }
      } else {
        form.save();
        return (true);
      }
    }
    return (false);
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      print("validated");
      setState(() {
        _errorMessage = "";
        _isLoading = true;
        onclick = true;
      });
      String url = g.preurl + posturl;
      var request = MultipartRequest('POST', Uri.parse(url));
      /*Dio dio = new Dio();
    FormData formdata = new FormData.fromMap({
      "id":id,
      "uid":g.uid,
      if(proofun==1)
      "username":un,
      if(prooflink==1)
      "link":link,
      if(proofcred==1)
      "cred":cred,
      if(proofemail==1)
      "email":email,
      if(proofphone==1)
      "phone":phone,
      if(proofss==1)
        if(cat==7)
        "ss": [
          for(int i=0;i<images.length;i++)
          await dio.MultipartFile.fromFile(images_source[i]),
    ]

    });*/
      request.files.add(MultipartFile.fromString('id', id));
      request.files.add(MultipartFile.fromString('uid', g.uid));
      if (proofun == 1)
        request.files.add(MultipartFile.fromString("username", un));
      if (prooflink == 1)
        request.files.add(MultipartFile.fromString("link", link));
      if (proofcred == 1)
        request.files.add(MultipartFile.fromString("cred", cred));
      if (proofemail == 1)
        request.files.add(MultipartFile.fromString("email", email));
      if (proofphone == 1)
        request.files.add(MultipartFile.fromString("phone", phone));
      if (proofss == 1) {
        /*if(cat==7)
      {
        print("123333333333333333333333333");
        List<MultipartFile> newList = new List<MultipartFile>();
        for(int i=0;i<images.length;i++)
         { 
           print(i);
           newList.add(
              await MultipartFile.fromPath('ss',images_source[i])
            );
           /*ByteData byteData = await images[i].getByteData();
            List<int> imageData = byteData.buffer.asUint8List();
        MultipartFile mf= MultipartFile.fromBytes('ss',imageData);
        newList.add(
          mf
        );*/
         }
         //print(newList);
         request.files.addAll(
          newList
        );
      }
      else{*/
        /*List<MultipartFile> newList = new List<MultipartFile>();
      MultipartFile mf= await MultipartFile.fromPath('ss',image_source);
      newList.add(
          mf
        );
        newList.add(
          mf
        );*/
        request.files.add(await MultipartFile.fromPath('ss', image_source));

        ///}
      }
      print("request.....................................");
      print(request.files);
      var res = await request.send();
      var response = await Response.fromStream(res);
      print("failed....................." + response.statusCode.toString());
      print(response.body);
      setState(() {
        _errorMessage = "Successfully Submitted";
        _isLoading = false;
        onclick = false;
      });
      Timer(Duration(milliseconds: 1000), () {
        Navigator.pop(context);
      });
    } else {
      setState(() {
        _errorMessage = "Please submit all the required proofs";
      });
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
          title: Text("Submit Proofs", style: TextStyle(color: Colors.white)),
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
                  "submitting   ",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            if (_isLoading) _showCircularProgress(),
            if (!_isLoading)
              Padding(
                padding: EdgeInsets.fromLTRB(0, 23, 0, 0),
                child: Text(
                  "submit  ",
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
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                  ),
                  if (proofun == 1)
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text((cat == 1)
                          ? "Enter Facebook Username"
                          : (cat == 3)
                              ? "Enter Instagram Username"
                              : (cat == 4)
                                  ? "Enter Youtube Username"
                                  : (cat == 5)
                                      ? "Enter Instagram Username"
                                      : ""),
                    ),
                  if (proofun == 1) showNameinput(),
                  if (proofemail == 1)
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text("Enter the Email address used"),
                    ),
                  if (proofemail == 1) showEmailnput(),
                  if (prooflink == 1)
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text((cat == 1)
                          ? "Link to the post"
                          : (cat == 3)
                              ? "Enter Instagram Handle Link"
                              : (cat == 5)
                                  ? "Link to the post"
                                  : ""),
                    ),
                  if (prooflink == 1) showLinkInput(),
                  if (proofphone == 1)
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text("Enter Whatsapp Number"),
                    ),
                  if (proofphone == 1) showphoneinput(),
                  if (proofcred == 1)
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text((cat == 7)
                          ? "Enter the Username which you registered"
                          : "Enter Social Media Username"),
                    ),
                  if (proofcred == 1) showcredinput(),
                  if (proofss == 1)
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
                      child: Text((cat == 3)
                          ? "Upload a Screenshot of the Story"
                          : (cat == 4)
                              ? "Upload a Screenshot of the Video liked"
                              : (cat == 6)
                                  ? "Upload a Screenshot of the Form submitted"
                                  : "Upload a Screenshot of the task"),
                    ),
                  /*if(images.length>0)
                        buildGridView(),
                        if(proofss==1&&cat==7)showMultipleImageInput(),*/
                  if (image_source != null) showImage(),
                  //if(proofss==1&&cat!=7)showImageInput(),
                  if (proofss == 1) showImageInput(),
                  //if(proofss==1)showImageInput(),
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
    );
  }
}
