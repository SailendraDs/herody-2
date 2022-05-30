import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:herody/update_profile.dart';
import 'package:herody/update_profile_password.dart';
import 'globaldata.dart' as g;

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool onclick=false;

Widget showeducation() {
  return(
    Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Card(
        child:Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child:Text("Education",style: TextStyle(color:Colors.grey[700],fontSize: 15),),
                  ),
                  Container(
                    child:IconButton(
                      icon: Icon(Icons.keyboard_arrow_down), 
                      onPressed: null,
                    ),
                  )
                ],
              ),

            ],
          )
        )
      )
    )
  );
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
  return MaterialApp(
      title: "Herody",
          debugShowCheckedModeBanner: false,
          home:Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              children:[
                Stack(
                  children: [
                    Image.asset("assets/pbackg.jpg",),
                    Container(
                      padding:EdgeInsets.fromLTRB(0, 20, 0, 0) ,
                      child:IconButton(
                        icon:Icon(Icons.keyboard_backspace,color: Colors.white,),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ),
                    Container(
                      width: double.infinity,
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(padding: EdgeInsets.fromLTRB(0, 100, 0, 0)),
                          CircleAvatar(
                            radius: 52,
                            backgroundColor: Colors.white,
                            child:CircleAvatar(backgroundImage:NetworkImage((g.data["profile_photo"]!=null)?"https://herody.in/assets/user/images/user_profile/"+g.data["profile_photo"]:"https://d3q6qq2zt8nhwv.cloudfront.net/m/1_extra_hzavn771.jpg"),radius: 50,),
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0),),
                          Container(
                            padding:EdgeInsets.fromLTRB(0, 5, 0, 5) ,
                            width: double.infinity,
                            color: Colors.indigo[800],
                            child:Text(g.data["name"],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.center,),
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text("Email:",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                          Text(" ",style: TextStyle(fontSize: 10)),
                                          Text("Phone:",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                          Text(" ",style: TextStyle(fontSize: 10)),
                                          Text("State:",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                          Text(" ",style: TextStyle(fontSize: 10)),
                                          Text("City:",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                          Text(" ",style: TextStyle(fontSize: 10)),
                                          Text("Pincode:",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                          Text(" ",style: TextStyle(fontSize: 10)),
                                          Text("Address:",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                        ],
                                      ),
                                      Text("  "),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          (g.data["email"]!=null)?Text(""+g.data["email"],style: TextStyle(fontSize: 15,color: Colors.grey[600]),)
                                          :Text("---",style: TextStyle(fontSize: 15,color: Colors.grey[600]),),
                                          Text(" ",style: TextStyle(fontSize: 10)),
                                          (g.data["phone"]!=null&&g.data["phone"]!="null")?Text(""+g.data["phone"],style: TextStyle(fontSize: 15,color: Colors.grey[600]),)
                                          :Text("---",style: TextStyle(fontSize: 15,color: Colors.grey[600]),),
                                          Text(" ",style: TextStyle(fontSize: 10)),
                                          (g.data["state"]!=null)?Text(""+g.data["state"],style: TextStyle(fontSize: 15,color: Colors.grey[600]),)
                                          :Text("---",style: TextStyle(fontSize: 15,color: Colors.grey[600]),),
                                          Text(" ",style: TextStyle(fontSize: 10)),
                                          (g.data["city"]!=null)?Text(""+g.data["city"],style: TextStyle(fontSize: 15,color: Colors.grey[600]),)
                                          :Text("---",style: TextStyle(fontSize: 15,color: Colors.grey[600]),),
                                          Text(" ",style: TextStyle(fontSize: 10)),
                                          (g.data["address"]!=null)?Text(""+g.data["zip_code"],style: TextStyle(fontSize: 15,color: Colors.grey[600]),)
                                          :Text("---",style: TextStyle(fontSize: 15,color: Colors.grey[600]),),
                                          Text(" ",style: TextStyle(fontSize: 10)),
                                          (g.data["address"]!=null)?Container(
                                            width: 200,
                                            child: Text(
                                              ""+g.data["address"],style: TextStyle(fontSize: 15,color: Colors.grey[600]),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 7,
                                            ),
                                          )
                                          :Text("---",style: TextStyle(fontSize: 15,color: Colors.grey[600]),),
                                        ],
                                      )
                                    ],
                                  ),
                              ]
                            )
                          ),
                          Divider(),
                          showPrimaryButton(),
                          InkWell(
                            child: new Text('Change Password?',style: TextStyle(color:Colors.pink),),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PasswordEdit(),
                                ));
                            },
                        ),
                        ],
                      )
                    )
                  ],
                )
              ]
          )
        )
  );
}
}