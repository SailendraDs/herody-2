import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:herody/update_profile.dart';
import 'package:herody/update_profile_password.dart';
import 'globaldata.dart' as g;
import 'package:web_scraper/web_scraper.dart';


class Developerpage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _DeveloperpageState();
}

class _DeveloperpageState extends State<Developerpage> {
  bool onclick=false;
  String size="-";
  String downloads="-";
  

void showeducation() async{
   final webScraper = WebScraper('https://play.google.com/store');
    if(await webScraper.loadWebPage('/apps/details?id=com.jaketa.herody')){
      String s=webScraper.getPageContent().toString();
      while(s.contains("htlgb")){
        int start=s.indexOf("htlgb");
        s=s.substring(start+7);
        int pstart=s.indexOf("<");
        String s1=s.substring(0,pstart);
        if(s1.endsWith("M")){
          setState(() {
          size=s1.substring(0,s1.length-1);
          });
        }
        if(s1.endsWith("+")){
          setState(() {
          downloads=s1.substring(0,s1.length-1);
          });
        }
      }
      /*print(s.substring(start-50,start+30));
      //int start=webScraper.getPageContent().toString().indexOf("class=\"IQ1z0d\"");
        //print(webScraper.getPageContent().toString().substring(start));
        print("---------------0");
        print(webScraper.getAllScripts());
        List<Map<String, dynamic>> elements = webScraper.getElement('div.IQ1z0d > a.span', ['href']);
        print("value");
        print(elements);*/
    }
}

Widget showPrimaryButton() {
  onclick=false;
    return new Container(
        padding: EdgeInsets.fromLTRB(66.0,25, 66.0, 15),
        child: SizedBox(
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10.0)
                ),
            color: !onclick?Colors.indigo[900]:Colors.pink,
            child:Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit,size: 15,color: Colors.white,),
                Text('  Edit Profile',
                style: new TextStyle(fontSize: 15.0, color: Colors.white)),
              ],
            ),
            onPressed:()async{
              onclick=true;
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileEdit(),
                  ));
                        setState(() {
              g.data=g.data;
            });
            }
          ),
        ));
  }
  

Widget build(BuildContext context){
  showeducation();
  return MaterialApp(
      title: "Herody",
          debugShowCheckedModeBanner: false,
          home:Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              children:[
                Stack(
                  children: [
                    //Image.network("https://i.pinimg.com/236x/0a/08/dd/0a08ddad20ceb8c7a8cc85234c6e38c2--marvel.jpg",height: MediaQuery.of(context).size.height,),
                    Container(
                      padding:EdgeInsets.fromLTRB(0, 20, 0, 0) ,
                      child:IconButton(
                        icon:Icon(Icons.keyboard_backspace,color: Colors.indigo,),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                      width: double.infinity,
                      margin:EdgeInsets.fromLTRB(0, 80, 0, 0) ,
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.blue,blurRadius: 30)],
                        borderRadius: BorderRadius.vertical(bottom: Radius.elliptical(150, 50),top: Radius.elliptical(150, 50)),
                        gradient: LinearGradient(begin: Alignment.topCenter,end: Alignment.bottomCenter,colors: [Colors.indigo[700],Colors.blue])
                      ),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.fromLTRB(0, 100, 0, 0),),
                          Container(
                            width: double.infinity,
                            child:Text("Developed by",style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.white),textAlign: TextAlign.center,),
                          ),
                          Container(
                            padding:EdgeInsets.fromLTRB(0, 5, 0, 5) ,
                            width: double.infinity,
                            child:Text("NAGULAN S",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 50),
                            width: double.infinity,
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Downloads",style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.white),textAlign: TextAlign.center,),
                                      Padding(padding: EdgeInsets.all(5)),
                                      Text(downloads+"",style: TextStyle(fontSize: MediaQuery.of(context).size.width/14,fontWeight: FontWeight.normal,color: Colors.white),textAlign: TextAlign.center,),
                                    ],
                                  ),
                                ),
                                  Container(
                                    width: 2,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                    ),
                                  ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Size",style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.white),textAlign: TextAlign.center,),
                                      Padding(padding: EdgeInsets.all(5)),
                                      Text(size+((size=="-")?"":"+"),style: TextStyle(fontSize: MediaQuery.of(context).size.width/14,fontWeight: FontWeight.normal,color: Colors.white),textAlign: TextAlign.center,),
                                      Text("MB",style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.white),textAlign: TextAlign.center,),
                                    ],
                                  ),
                                ),
                                  Container(
                                    width: 2,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white
                                    ),
                                  ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Duration",style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.white),textAlign: TextAlign.center,),
                                      Padding(padding: EdgeInsets.all(5)),
                                      Text("45+",style: TextStyle(fontSize: MediaQuery.of(context).size.width/14,fontWeight: FontWeight.normal,color: Colors.white),textAlign: TextAlign.center,),
                                      Text("days",style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.white),textAlign: TextAlign.center,),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ),
                          Container(
                            width: double.infinity,
                            child:Text("Developed using",style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.white),textAlign: TextAlign.center,),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 20, 0, 50),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.network("https://cdn.dribbble.com/users/528264/screenshots/3140440/firebase_logo.png",height:MediaQuery.of(context).size.width/5),
                                Image.network("https://d2eip9sf3oo6c2.cloudfront.net/tags/images/000/001/245/square_280/flutterlogo.png",height:MediaQuery.of(context).size.width/5),
                                Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/3/34/Android_Studio_icon.svg/1200px-Android_Studio_icon.svg.png",height:MediaQuery.of(context).size.width/5),
                                Image.network("https://purecode.sa/wp-content/uploads/three-4.png",height:MediaQuery.of(context).size.width/5),
                              ],
                            ),
                          ),
                        Container(
                            width: double.infinity,
                            child:Text("Contacts",style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.white),textAlign: TextAlign.center,),
                          ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          width: double.infinity,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                              Icon(Icons.email,color: Colors.white,),
                              Padding(padding: EdgeInsets.fromLTRB(40, 0, 0, 0)),
                              Text("nagulan1645@gmail.com",style: TextStyle(fontSize:  MediaQuery.of(context).size.width/19,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,),
                            ],
                          )
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          width: double.infinity,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                              Icon(Icons.phone,color: Colors.white,),
                              Padding(padding: EdgeInsets.fromLTRB(40, 0, 0, 0)),
                              Text("8695775599",style: TextStyle(fontSize: MediaQuery.of(context).size.width/19,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,),
                            ],
                          )
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 100),
                          width: double.infinity,
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(padding: EdgeInsets.fromLTRB(20, 0, 0, 0)),
                              Icon(Icons.link,color: Colors.white,),
                              Padding(padding: EdgeInsets.fromLTRB(40, 0, 0, 0)),
                              Text("linkedin.com/in/nagulan-s",style: TextStyle(fontSize: MediaQuery.of(context).size.width/19,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,),
                            ],
                          )
                        ),
                        //Image.network("https://www.shyamfuture.com/assets/front/images/thumbnail_mobileappdevelopment_top.png",)
                        ],
                      )
                    ),
                    Image.network("https://4.bp.blogspot.com/-1LBva3U1LCI/W6kL2pl9ZYI/AAAAAAAAFys/grkBZRKkAWE1eLAh6DPffThJ7gP__SREACLcBGAs/w1200-h630-p-k-no-nu/play_logo_16_9%2B%25285%2529.png",width: MediaQuery.of(context).size.width-200)
                        ],
                      ),
                    ),
                    Container(
                      width:  MediaQuery.of(context).size.width,
                      margin:EdgeInsets.fromLTRB(0, 50, 0, 0) ,
                      alignment: Alignment.center,
                      child: CircleAvatar(
                            radius: 52,
                            backgroundColor: Colors.white,
                            child:CircleAvatar(backgroundImage:NetworkImage((g.data["profile_photo"]!=null)?"https://herody.in/assets/user/images/user_profile/"+g.data["profile_photo"]:"https://d3q6qq2zt8nhwv.cloudfront.net/m/1_extra_hzavn771.jpg"),radius: 50,),
                          ),
                    ),
                  ],
                )
              ]
          )
        )
  );
}
}