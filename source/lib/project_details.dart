import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:herody/update_project_proofs.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'globaldata.dart' as g;
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class Projectdetails extends StatefulWidget {
  Projectdetails({this.id,this.statusid});
  final String id;
  final int statusid;
  @override
  State<StatefulWidget> createState() => new _ProjectdetailsState(id:id,statusid: statusid);
}

class _ProjectdetailsState extends State<Projectdetails> {
  _ProjectdetailsState({this.id,this.statusid});
  final _formKey = new GlobalKey<FormState>();
  final String id;
  final int statusid;
  int sid=-2;
  int proofimage=0;
  int prooffile=0;
  int prooflink=0;
  var data;
  var pdata;
  var userdata;
  var applydata;
  bool onclick=false;
  bool applied=false;
  bool displayquestions=false;
  bool flag=true;
  bool servererror=false;
  bool refresh=false;
  List<String> answer=[];
  String _errorMessage="";
  List month=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
  //List status=["Applied","Selected","Rejected","Proof Submitted","Proof Rejected","Certificate Issued","Payout"];
  List status=["Applied","Shortlisted","Selected","Rejected","Proof Submitted","Certificate Issued","Payout"];

  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Container(
        alignment: Alignment.center,
        child:new Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            fontWeight: FontWeight.bold),
        )
        )
      );
    } else {
      return new Container(
        height: 0.0,
        width: 0,
      );
    }
  }

  void getdata()async{
    String url=g.preurl+"project/details";
    Response response=await post(url,body: {"id":id});
    try{
    setState(() {
      data = json.decode(response.body)["response"];
      if(data["project"]["proofs"].contains("Image"))
      proofimage=1;
      if(data["project"]["proofs"].contains("File"))
      prooffile=1;
      if(data["project"]["proofs"].contains("Link"))
      prooflink=1;
    });
    }
    catch(e){
      /*setState(() {
        servererror=true;
      });*/
      print(e);
    }
  }

  void submitdata() async{
    if(displayquestions){
    if( validateAndSave()){
    setState(() {
      onclick=true;
    });
    String url=g.preurl+"project/apply";
    print(answer.toString());
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
    for(int i=0;i<answer.length;i++)
    request.files.add(
      MultipartFile.fromString(
        'answer[]',answer[i]
      )
    );
    print("sending......................................");
    print(request.fields);
    StreamedResponse res= await request.send();
    var response = await Response.fromStream(res);
    print(response.body);
    await determine();
    setState(() {
      onclick=false;
      applied=true;
    });
    }
    else{
      setState(() {
        _errorMessage="Please answer all the above questions";
      });
    }
    }
    else
    {
      setState(() {
        displayquestions=true;
      });
    }
  }

  Future<int> determine() async{
    if(!onclick && !refresh){
      setState(() {
        refresh=true;
      });
    print("11111111");
    String url=g.preurl+"user/jprojects";
    Response response=await post(url,body: {"id":g.uid});
    try{
    userdata = json.decode(response.body)["response"];
    int i;
    for(i=0;i<userdata["projectsinfo"].length;i++){
      if(userdata["projectsinfo"][i]["id"].toString()==id){
        setState(() {
          if(onclick!=true){
          applied=true;
          sid=userdata["projects"][i]["status"];
          }
        });
        break;
      }
    }
    if(i==userdata["projectsinfo"].length)
    {
      setState(() {
        sid=-1;
      });
    }
    }
    catch(e){
      print("Didnt refresh !!!!!!!!!!!!!!!!!!!!!!");
      print(e);
    }
    setState(() {
        refresh=false;
      });
    }
    return(1);
  }

  Widget showPrimaryButton() {
    return new Container(
      width: double.infinity,
        padding: EdgeInsets.fromLTRB(16.0,15, 16.0, 15),
        child: SizedBox(
          height: 50.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)
                ),
            color: !onclick?Colors.indigo[900]:Colors.pink,
            child: new Text( (displayquestions&&!applied)?(onclick)?"Submitting...":"Submit":applied?"Applied":'Apply Now',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed:(){
              FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
              if(!applied)
                submitdata();
            }
          ),
        ));
  }

  Widget projectdetails() {
    return Container(
      child:ListView(
              children: [
                Container(
                  color: Colors.blueGrey[50],
                child:Card(
                  shadowColor:Colors.blue ,
                  elevation: 10,
                  margin: EdgeInsets.fromLTRB(5, 10, 5, 20),
                  child:Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Row(
                      children: [
                        Image(image:NetworkImage("https://herody.in/assets/employer/profile_images/"+data["company"]["profile_photo"]),loadingBuilder: (context, child, loadingProgress) => (loadingProgress!=null)?Container(height: 160,width: 160,alignment: Alignment.center,child:CircularProgressIndicator()):child,width: 160,height:160,),
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child:Container(
                              width: 2,
                              height: 200,
                              color: Colors.indigo[800],
                            ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.business,color: Colors.black,),
                                Container(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  width: MediaQuery.of(context).size.width-260,
                                  child: Text(
                                    "Company: "+data["company"]["cname"].toString(),style: TextStyle(color: Colors.grey[700]),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
                                ),
                              ],
                            ),
                            Text(" "),
                            Row(
                              children: [
                                Image.asset("assets/rupee.png",height:20),
                                Container(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  width:MediaQuery.of(context).size.width-260,
                                  child: Text(
                                    "Stipend: ₹"+data["project"]["stipend"].toString(),style: TextStyle(color: Colors.grey[700]),
                                    overflow: TextOverflow.ellipsis,
                                     maxLines: 5,
                                  ),
                                ),
                              ],
                            ),
                            Text(" "),
                            Row(
                              children: [
                                Icon(Icons.date_range,color: Colors.black,),
                                Container(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  width: MediaQuery.of(context).size.width-260,
                                  child: Text(
                                    "Duration: "+data["project"]["duration"],style: TextStyle(color: Colors.grey[700]),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
                                ),
                              ],
                            ),
                            Text(" "),
                            Row(
                              children: [
                                Icon(Icons.place,color: Colors.black,),
                                Container(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  width: MediaQuery.of(context).size.width-260,
                                  child: Text(
                                    "Location: "+data["project"]["place"],style: TextStyle(color: Colors.grey[700]),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
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
                if(sid>-1)Container(
                  color: Colors.blueGrey[50],
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(10, 0, 20, 10),
                  child:Container( 
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.pink,
                    ),
                    child:Text("Current Status:  "+status[sid],style: TextStyle(color:Colors.white,fontSize: 20),textAlign: TextAlign.center,),
                  ),
                ),
                Container(
                  color: Colors.blue[100], 
                  height:30,
                  width:double.infinity,
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child:Text("About Internship\n",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child:Html(data:data["project"]["des"],
                  onLinkTap: (url) {
                    launch(url);
                  },
                  customRender: (node, children){
                  if (node is dom.Element) {
                    switch (node.localName) {
                      case "custom_tag": // using this, you can handle custom tags in your HTML 
                        return Column(children: children);
                    }
                  }
                },
                )
                ),
                Container(
                  width:double.infinity,
                  color: Colors.blue[100],
                  height:30,
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child:Text("About Company\n",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                ),
                if(data["company"]["website"]!=null)Container(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                  child: InkWell(
                            child: new Text("Website: "+data["company"]["website"],style: TextStyle(color:Colors.pink),),
                            onTap: () {
                              launch("http://"+data["company"]["website"]);
                            },
                        ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                  child:Html(data:data["company"]["description"],
                  onLinkTap: (url) {
                    launch(url);
                  },
                  customRender: (node, children){
                  if (node is dom.Element) {
                    switch (node.localName) {
                      case "custom_tag": // using this, you can handle custom tags in your HTML 
                        return Column(children: children);
                    }
                  }
                },
                )
                ),
                Container(
                  width:double.infinity,
                  color: Colors.blue[100],
                  height:30,
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child:Text("Internship Start Date\n",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child:Row(
                    children: [
                      Icon(Icons.event,color: Colors.grey[800],),
                      Text(" "+data["project"]["start"].toString().substring(8,10)+" "+month[int.parse(data["project"]["start"].toString().substring(5,7))-1]+" "+data["project"]["start"].toString().substring(0,4),textAlign: TextAlign.left,style: TextStyle(color: Colors.black),)
                    ],
                  )
                ),
                Container(
                  width:double.infinity,
                  color: Colors.blue[100],
                  height:30,
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child:Text("Internship Benefits",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child:Html(data:data["project"]["benefits"],
                  onLinkTap: (url) {
                    launch(url);
                  },
                  customRender: (node, children){
                  if (node is dom.Element) {
                    switch (node.localName) {
                      case "custom_tag": // using this, you can handle custom tags in your HTML 
                        return Column(children: children);
                    }
                  }
                },
                )
                ),
                Container(
                  width:double.infinity,
                  color: Colors.blue[100],
                  height:30,
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child:Text("Skills Required",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child:Html(data:data["project"]["skills"],
                  onLinkTap: (url) {
                    launch(url);
                  },
                  customRender: (node, children){
                  if (node is dom.Element) {
                    switch (node.localName) {
                      case "custom_tag": // using this, you can handle custom tags in your HTML 
                        return Column(children: children);
                    }
                  }
                },
                )
                ),
                Container(
                  width:double.infinity,
                  color: Colors.blue[100],
                  height:30,
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child:Text("Proofs Required",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child:Text("•  "+data["project"]["proofs"].toString().substring(0,data["project"]["proofs"].length-1).replaceAll(',', '\n•  '),textAlign: TextAlign.left,style: TextStyle(color: Colors.black),)
                ),
                if(sid==2)Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                      RaisedButton(
                        color: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Text("Submit Proofs",style: TextStyle(color:Colors.white),),
                        onPressed: () async{
                          if(sid==2)Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Submitproofs(id:id,prooffile: prooffile,proofimage: proofimage,prooflink: prooflink),
                                ));
                          if(sid==2)await determine();
                        },
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 10)
                    )
                  ],
                ),
                Container(
                  width:double.infinity,
                  color: Colors.blue[100],
                  height:30,
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child:Text("Apply Before Date\n",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                  child:Row(
                    children: [
                      Icon(Icons.event,color: Colors.grey[800],),
                      Text(" "+data["project"]["end"].toString().substring(8,10)+" "+month[int.parse(data["project"]["end"].toString().substring(5,7))-1]+" "+data["project"]["end"].toString().substring(0,4),textAlign: TextAlign.left,style: TextStyle(color: Colors.black),)
                    ],
                  )
                ),
                if(!applied && displayquestions)Container(
                  width:double.infinity,
                  color: Colors.blue[100],
                  height:30,
                  padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                  child:Text("Answer below Questions to apply",style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                ),
                if(!applied && displayquestions)Form(
                key: _formKey,
                child:ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                    itemCount: (data == null ) ?0: data["questions"].length,
                    itemBuilder: (BuildContext context, i) {
                      return Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          margin: const EdgeInsets.only(top: 5.0),
                          child:Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.bottomLeft,
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  width: 370,
                                  child: Text(
                                    "\n"+(i+1).toString()+") "+data["questions"][i]["question"].toString(),style: TextStyle(fontSize: 18,color: Colors.grey[700]),textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                  ),
                                ),
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: TextFormField(
                                    minLines: 10,
                                    maxLines: 20,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                      hintText: 'Write your answer here',
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
                                    validator: (value) => value.trim().isEmpty ? 'Answer can\'t be empty' : null,
                                    onSaved: (value) => answer.add(value.trim()),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Container(height: 0,width: 0,);
                    },
                  ),
              ),
              if(!applied)showErrorMessage(),
              if(sid!=-2)showPrimaryButton(),
              if(sid==0)Text("Your Application is currently being reviewed\nCheck the above Current Status for further details\n\n",textAlign: TextAlign.center,style: TextStyle(color:Colors.grey,fontSize: MediaQuery.of(context).size.width/30,),),
              ],
      ),
            );
  }

  @override
  Widget build(BuildContext context) {
    print("---------------");
    if(data==null && statusid!=-1)sid=statusid;
    determine();
    if(data==null)getdata();
    return MaterialApp(
      title: "Herody",
          debugShowCheckedModeBanner: false,
          home:Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              centerTitle: true,
              title: Text(data==null?"":data["project"]["title"]),
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon:Icon(Icons.arrow_back),
                onPressed:(){ Navigator.pop(context);},
              ),
              backgroundColor: Colors.indigo[900],
            ),
            body: data==null?
            (servererror)?
              Center(
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Image.asset("assets/maintenance.png",height: 130,),
                    Text("App under maintenance!",textAlign: TextAlign.center,style: TextStyle(fontSize: 25,color: Colors.grey[800]),),
                    Text("Check back later",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,color: Colors.grey[800]),),
                    Container(height: 100,width: 20,)
                  ]
                ),
              )
              :
              Center(
                child:CircularProgressIndicator(valueColor:new AlwaysStoppedAnimation<Color>(Colors.indigo)))
              :projectdetails(),
          ),
    );
  }
}