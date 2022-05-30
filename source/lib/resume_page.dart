import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:herody/update_resume_ach.dart';
import 'package:herody/update_resume_exp.dart';
import 'package:herody/update_resume_hobby.dart';
import 'package:herody/update_resume_skill.dart';
import 'package:herody/update_resume_social.dart';
import 'package:http/http.dart';
import 'globaldata.dart' as g;
import 'pdf_viewer.dart';
import 'update_resume_edu.dart';
import 'update_resume_project.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

class Resume extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ResumeState();
}

class _ResumeState extends State<Resume> {
  int onclickedu = 1;
  int onclickskill = 1;
  int onclickexp = 1;
  int onclickach = 1;
  int onclickhobby = 1;
  int onclickproject = 1;
  var edu_data;
  var skill_data;
  var exp_data;
  var project_data;
  List<String> ach_data = null;
  List<String> hobby_data = null;
  bool onclick = false;

  void deleteedu(int eid) async {
    String url = g.preurl + "user/eduDelete";
    Response response = await post(url, body: {"id": eid.toString()});
    setState(() {
      var edata = json.decode(response.body)["response"];
    });
  }

  void getedu() async {
    String url = g.preurl + "user/edu";
    Response response = await post(url, body: {"uid": g.uid});
    setState(() {
      edu_data = json.decode(response.body)["response"];
    });
  }

  Widget showeducation() {
    return (Container(
        color: Colors.blue[50],
        padding: EdgeInsets.all(10),
        child: Card(
            shadowColor: Colors.blue,
            elevation: 8,
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              Image.asset(
                                "assets/eduicon.png",
                                height: 24,
                              ),
                              Text(
                                "  Education",
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 15),
                              ),
                            ])),
                        Container(
                          child: IconButton(
                            icon: (onclickedu % 2 == 0)
                                ? Icon(Icons.keyboard_arrow_up)
                                : Icon(Icons.keyboard_arrow_down),
                            onPressed: () {
                              setState(() {
                                onclickedu++;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    if (onclickedu % 2 == 0) Divider(),
                    if (onclickedu % 2 == 0 &&
                        edu_data != null &&
                        edu_data["edus"].length == 0)
                      Container(
                        child: Text("No Educational details to display",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ),
                    if (onclickedu % 2 == 0)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            edu_data == null ? 0 : edu_data["edus"].length,
                        itemBuilder: (BuildContext context, i) {
                          return new Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      edu_data["edus"][i]["type"] + "\n",
                                      style: TextStyle(color: Colors.pink),
                                    ),
                                    Container(
                                      width: 230,
                                      child: Text(
                                        edu_data["edus"][i]["name"],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    ),
                                    Text(
                                      edu_data["edus"][i]["course"],
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 13),
                                    ),
                                    Text(
                                      edu_data["edus"][i]["start"] +
                                          " - " +
                                          edu_data["edus"][i]["end"],
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 10),
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete_forever),
                                          onPressed: () async {
                                            onclickedu++;
                                            await deleteedu(
                                                edu_data["edus"][i]["id"]);
                                            await getedu();
                                            onclickedu++;
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return new Divider();
                        },
                      ),
                    if (onclickedu % 2 == 0) new Divider(),
                    if (onclickedu % 2 == 0)
                      showPrimaryButton(
                          "Add Education", EducationEdit(), onclickedu, getedu),
                  ],
                )))));
  }

  void deleteskill(int eid) async {
    String url = g.preurl + "user/skillsDelete";
    Response response = await post(url, body: {"id": eid.toString()});
    setState(() {
      var sdata = json.decode(response.body)["response"];
    });
  }

  void getskill() async {
    print(g.data["email"]);
    print(g.data["Phone"]);
    String url = g.preurl + "user/skills";
    Response response = await post(url, body: {"uid": g.uid});
    setState(() {
      skill_data = json.decode(response.body)["response"];
    });
  }

  Widget showskills() {
    return (Container(
        color: Colors.blue[50],
        padding: EdgeInsets.all(10),
        child: Card(
            shadowColor: Colors.blue,
            elevation: 8,
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              Image.asset(
                                "assets/skillicon.png",
                                height: 24,
                              ),
                              Text(
                                "  Skills",
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 15),
                              ),
                            ])),
                        Container(
                          child: IconButton(
                            icon: (onclickskill % 2 == 0)
                                ? Icon(Icons.keyboard_arrow_up)
                                : Icon(Icons.keyboard_arrow_down),
                            onPressed: () {
                              setState(() {
                                onclickskill++;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    if (onclickskill % 2 == 0) Divider(),
                    if (onclickskill % 2 == 0 &&
                        skill_data != null &&
                        skill_data["skills"].length == 0)
                      Container(
                        child: Text(
                          "No Skills to display",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                      ),
                    if (onclickskill % 2 == 0)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: skill_data == null
                            ? 0
                            : skill_data["skills"].length,
                        itemBuilder: (BuildContext context, i) {
                          return new Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 230,
                                      child: Text(
                                        skill_data["skills"][i]["name"],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        if (skill_data["skills"][i]["rating"] ==
                                            0)
                                          Icon(
                                            Icons.star_border,
                                            color: Colors.yellow[700],
                                          ),
                                        (skill_data["skills"][i]["rating"] >= 1)
                                            ? Icon(Icons.star,
                                                color: Colors.yellow[700])
                                            : Icon(
                                                Icons.star_border,
                                                color: Colors.yellow[700],
                                              ),
                                        (skill_data["skills"][i]["rating"] >= 2)
                                            ? Icon(Icons.star,
                                                color: Colors.yellow[700])
                                            : Icon(
                                                Icons.star_border,
                                                color: Colors.yellow[700],
                                              ),
                                        (skill_data["skills"][i]["rating"] >= 3)
                                            ? Icon(Icons.star,
                                                color: Colors.yellow[700])
                                            : Icon(
                                                Icons.star_border,
                                                color: Colors.yellow[700],
                                              ),
                                        (skill_data["skills"][i]["rating"] >= 4)
                                            ? Icon(Icons.star,
                                                color: Colors.yellow[700])
                                            : Icon(
                                                Icons.star_border,
                                                color: Colors.yellow[700],
                                              ),
                                        (skill_data["skills"][i]["rating"] >= 5)
                                            ? Icon(Icons.star,
                                                color: Colors.yellow[700])
                                            : Icon(
                                                Icons.star_border,
                                                color: Colors.yellow[700],
                                              ),
                                      ],
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete_forever),
                                          onPressed: () async {
                                            onclickskill++;
                                            await deleteskill(
                                                skill_data["skills"][i]["id"]);
                                            await getskill();
                                            onclickskill++;
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return new Divider();
                        },
                      ),
                    if (onclickskill % 2 == 0) new Divider(),
                    if (onclickskill % 2 == 0)
                      showPrimaryButton(
                          "Add Skill", SkillEdit(), onclickskill, getskill),
                  ],
                )))));
  }

  void deleteexp(int eid) async {
    String url = g.preurl + "user/expDelete";
    Response response = await post(url, body: {"id": eid.toString()});
    setState(() {
      var edata = json.decode(response.body)["response"];
    });
  }

  void getexp() async {
    String url = g.preurl + "user/exp";
    Response response = await post(url, body: {"uid": g.uid});
    setState(() {
      exp_data = json.decode(response.body)["response"];
    });
  }

  Widget showexperience() {
    return (Container(
        color: Colors.blue[50],
        padding: EdgeInsets.all(10),
        child: Card(
            shadowColor: Colors.blue,
            elevation: 8,
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              Image.asset(
                                "assets/expicon.png",
                                height: 24,
                              ),
                              Text(
                                "  Experience",
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 15),
                              ),
                            ])),
                        Container(
                          child: IconButton(
                            icon: (onclickexp % 2 == 0)
                                ? Icon(Icons.keyboard_arrow_up)
                                : Icon(Icons.keyboard_arrow_down),
                            onPressed: () {
                              setState(() {
                                onclickexp++;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    if (onclickexp % 2 == 0) Divider(),
                    if (onclickexp % 2 == 0 &&
                        exp_data != null &&
                        exp_data["exps"].length == 0)
                      Container(
                        child: Text("No Experience to display",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ),
                    if (onclickexp % 2 == 0)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                            exp_data == null ? 0 : exp_data["exps"].length,
                        itemBuilder: (BuildContext context, i) {
                          return new Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 230,
                                      child: Text(
                                        exp_data["exps"][i]["company"],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    ),
                                    Text(
                                      exp_data["exps"][i]["designation"],
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 13),
                                    ),
                                    Text(
                                      exp_data["exps"][i]["start"] +
                                          " - " +
                                          exp_data["exps"][i]["end"],
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 10),
                                    ),
                                    Container(
                                      width: 230,
                                      child: Text(
                                        exp_data["exps"][i]["des"],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 13),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete_forever),
                                          onPressed: () async {
                                            onclickexp++;
                                            await deleteexp(
                                                exp_data["exps"][i]["id"]);
                                            await getexp();
                                            onclickexp++;
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return new Divider();
                        },
                      ),
                    if (onclickexp % 2 == 0) new Divider(),
                    if (onclickexp % 2 == 0)
                      showPrimaryButton("Add Experience", ExperienceEdit(),
                          onclickexp, getexp),
                  ],
                )))));
  }

  void deleteproject(int eid) async {
    String url = g.preurl + "user/projectsDelete";
    Response response = await post(url, body: {"id": eid.toString()});
    setState(() {
      var edata = json.decode(response.body)["response"];
    });
  }

  void getproject() async {
    String url = g.preurl + "user/projects";
    Response response = await post(url, body: {"uid": g.uid});
    setState(() {
      project_data = json.decode(response.body)["response"];
    });
  }

  Widget showprojects() {
    return (Container(
        color: Colors.blue[50],
        padding: EdgeInsets.all(10),
        child: Card(
            shadowColor: Colors.blue,
            elevation: 8,
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              Image.asset(
                                "assets/projicon.png",
                                height: 24,
                              ),
                              Text(
                                "  Projects",
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 15),
                              ),
                            ])),
                        Container(
                          child: IconButton(
                            icon: (onclickproject % 2 == 0)
                                ? Icon(Icons.keyboard_arrow_up)
                                : Icon(Icons.keyboard_arrow_down),
                            onPressed: () {
                              setState(() {
                                onclickproject++;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    if (onclickproject % 2 == 0) Divider(),
                    if (onclickproject % 2 == 0 &&
                        project_data != null &&
                        project_data["projects"].length == 0)
                      Container(
                        child: Text("No Projects to display",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ),
                    if (onclickproject % 2 == 0)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: project_data == null
                            ? 0
                            : project_data["projects"].length,
                        itemBuilder: (BuildContext context, i) {
                          return new Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 230,
                                      child: Text(
                                        project_data["projects"][i]["title"],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    ),
                                    Text(
                                      " ",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Container(
                                      width: 230,
                                      child: Text(
                                        project_data["projects"][i]["des"],
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete_forever),
                                          onPressed: () async {
                                            onclickproject++;
                                            await deleteproject(
                                                project_data["projects"][i]
                                                    ["id"]);
                                            await getproject();
                                            onclickproject++;
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return new Divider();
                        },
                      ),
                    if (onclickproject % 2 == 0) new Divider(),
                    if (onclickproject % 2 == 0)
                      showPrimaryButton("Add Project", ProjectEdit(),
                          onclickproject, getproject),
                  ],
                )))));
  }

  void deleteach(int index) async {
    String s = ",";
    for (int i = 0; i < ach_data.length; i++) {
      if (i != index) s = s + ach_data[i] + ",";
    }
    String url = g.preurl + "user/achievementsUpdate";
    Response response = await post(url, body: {"uid": g.uid, "ach": s});
  }

  void getach() async {
    List<String> alist = [];
    String url = g.preurl + "user/details";
    Response response = await post(url, body: {"id": g.uid});
    print(response.body);
    var data1 = json.decode(response.body)["response"];
    String data = data1["user"]["achievements"];
    setState(() {
      g.data = data1["user"];
    });
    if (data != null) {
      String s = "";
      for (int i = 0; i < data.length; i++) {
        if (data.substring(i, i + 1) == ",") {
          if (s != "") alist.add(s.trim());
          s = "";
        } else {
          s += data.substring(i, i + 1);
        }
      }
    }
    print(data);
    print(alist);
    setState(() {
      ach_data = alist;
    });
  }

  Widget showachievements() {
    return (Container(
        color: Colors.blue[50],
        padding: EdgeInsets.all(10),
        child: Card(
            shadowColor: Colors.blue,
            elevation: 8,
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              Image.asset(
                                "assets/achicon.png",
                                height: 24,
                              ),
                              Text(
                                "  Achievements",
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 15),
                              ),
                            ])),
                        Container(
                          child: IconButton(
                            icon: (onclickach % 2 == 0)
                                ? Icon(Icons.keyboard_arrow_up)
                                : Icon(Icons.keyboard_arrow_down),
                            onPressed: () {
                              setState(() {
                                onclickach++;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    if (onclickach % 2 == 0) Divider(),
                    if (onclickach % 2 == 0 &&
                        g.data != null &&
                        ach_data.length == 0)
                      Container(
                        child: Text("No Achievements to display",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ),
                    if (onclickach % 2 == 0)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: ach_data == [] ? 0 : ach_data.length,
                        itemBuilder: (BuildContext context, i) {
                          return new Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 230,
                                      child: Text(
                                        ach_data[i],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete_forever),
                                          onPressed: () async {
                                            setState(() {
                                              onclickach++;
                                            });
                                            await deleteach(i);
                                            await getach();
                                            setState(() {
                                              onclickach++;
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return new Divider();
                        },
                      ),
                    if (onclickach % 2 == 0) new Divider(),
                    if (onclickach % 2 == 0)
                      showPrimaryButton("Add Achievements", AchievementsEdit(),
                          onclickach, getach),
                  ],
                )))));
  }

  void deletehobby(int index) async {
    String s = ",";
    for (int i = 0; i < hobby_data.length; i++) {
      if (i != index) s = s + hobby_data[i] + ",";
    }
    String url = g.preurl + "user/hobbiesUpdate";
    Response response = await post(url, body: {"uid": g.uid, "hobby": s});
  }

  void gethobby() async {
    List<String> alist = [];
    String url = g.preurl + "user/details";
    Response response = await post(url, body: {"id": g.uid});
    print(response.body);
    var data1 = json.decode(response.body)["response"];
    String data = data1["user"]["hobbies"];
    setState(() {
      g.data = data1["user"];
    });
    if (data != null) {
      String s = "";
      for (int i = 0; i < data.length; i++) {
        if (data.substring(i, i + 1) == ",") {
          if (s != "") alist.add(s.trim());
          s = "";
        } else {
          s += data.substring(i, i + 1);
        }
      }
    }
    print(data);
    print(alist);
    setState(() {
      hobby_data = alist;
    });
  }

  Widget showhobbies() {
    return (Container(
        color: Colors.blue[50],
        padding: EdgeInsets.all(10),
        child: Card(
            shadowColor: Colors.blue,
            elevation: 8,
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              Image.asset(
                                "assets/hobicon.png",
                                height: 24,
                              ),
                              Text(
                                "  Hobbies",
                                style: TextStyle(
                                    color: Colors.grey[700], fontSize: 15),
                              ),
                            ])),
                        Container(
                          child: IconButton(
                            icon: (onclickhobby % 2 == 0)
                                ? Icon(Icons.keyboard_arrow_up)
                                : Icon(Icons.keyboard_arrow_down),
                            onPressed: () {
                              setState(() {
                                onclickhobby++;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    if (onclickhobby % 2 == 0) Divider(),
                    if (onclickhobby % 2 == 0 &&
                        g.data != null &&
                        hobby_data.length == 0)
                      Container(
                        child: Text("No Hobbies to display",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ),
                    if (onclickhobby % 2 == 0)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: hobby_data == [] ? 0 : hobby_data.length,
                        itemBuilder: (BuildContext context, i) {
                          return new Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 230,
                                      child: Text(
                                        hobby_data[i],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 10,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete_forever),
                                          onPressed: () async {
                                            setState(() {
                                              onclickhobby++;
                                            });
                                            await deletehobby(i);
                                            await gethobby();
                                            setState(() {
                                              onclickhobby++;
                                            });
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return new Divider();
                        },
                      ),
                    if (onclickhobby % 2 == 0) new Divider(),
                    if (onclickhobby % 2 == 0)
                      showPrimaryButton(
                          "Add Hobby", HobbyEdit(), onclickhobby, gethobby),
                  ],
                )))));
  }

  void getsocial() async {
    String url = g.preurl + "user/details";
    Response response = await post(url, body: {"id": g.uid});
    print(response.body);
    var data1 = json.decode(response.body)["response"];
    setState(() {
      g.data = data1["user"];
    });
  }

  Widget socialprofiles() {
    return Container(
      color: Colors.blue[50],
      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Column(
        children: [
          Container(
              color: Colors.blue[50],
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.indigo[800],
                          border: Border(
                            top:
                                BorderSide(color: Colors.indigo[800], width: 0),
                            right:
                                BorderSide(color: Colors.indigo[800], width: 0),
                            left: BorderSide(color: Colors.blue[50], width: 0),
                            bottom:
                                BorderSide(color: Colors.blue[50], width: 0),
                          )),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10)),
                            color: Colors.blue[50]),
                        width: 10,
                        height: 10,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 2, 15, 10),
                      decoration: BoxDecoration(
                        color: Colors.indigo[800],
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20)),
                      ),
                      child: Text(
                        "Social Media Profiles",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.indigo[800],
                          border: Border(
                            top:
                                BorderSide(color: Colors.indigo[800], width: 0),
                            left:
                                BorderSide(color: Colors.indigo[800], width: 0),
                            right: BorderSide(color: Colors.blue[50], width: 0),
                            bottom:
                                BorderSide(color: Colors.blue[50], width: 0),
                          )),
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10)),
                              color: Colors.blue[50]),
                          width: 10,
                          height: 10),
                    ),
                  ])),
          //Text("Social Media Profiles",style: TextStyle(color:Colors.indigo[800],fontWeight: FontWeight.bold),),
          Text(" "),
          Row(
            children: [
              Image.asset(
                "assets/insta.jfif",
                // "https://www.edigitalagency.com.au/wp-content/uploads/new-instagram-logo-png-transparent-light.png",
                height: 20,
                width: 20,
              ),
              (g.data["insta"] != null)
                  ? Text(
                      "   " + g.data["insta"],
                      style: TextStyle(
                          color: Colors.pink, fontWeight: FontWeight.bold),
                    )
                  : Text("   -- Instagram --",
                      style: TextStyle(color: Colors.grey[700])),
            ],
          ),
          Text(" "),
          Row(
            children: [
              Image.asset(
                "assets/facebook.png",
                //"https://1000logos.net/wp-content/uploads/2016/11/Facebook-Logo.png",
                height: 20,
                width: 20,
              ),
              (g.data["fb"] != null)
                  ? Text("   " + g.data["fb"],
                      style: TextStyle(
                          color: Colors.pink, fontWeight: FontWeight.bold))
                  : Text("   -- Facebook --",
                      style: TextStyle(color: Colors.grey[700])),
            ],
          ),
          Text(" "),
          Row(
            children: [
              Image.asset(
                //"https://www2.le.ac.uk/offices/careers-new/copy2_of_images/linkedin-logo/image",
                "assets/linkedin.png",
                height: 20,
                width: 20,
              ),
              (g.data["linkedin"] != null)
                  ? Text("   " + g.data["linkedin"],
                      style: TextStyle(
                          color: Colors.pink, fontWeight: FontWeight.bold))
                  : Text("   -- Linkedin --",
                      style: TextStyle(color: Colors.grey[700])),
            ],
          ),
          Text(" "),
          Row(
            children: [
              Image.network(
                "https://elementarylibrarian.com/wp-content/uploads/2013/11/twitter-bird-white-on-blue.png",
                height: 20,
                width: 20,
              ),
              (g.data["twitter"] != null)
                  ? Text("   " + g.data["twitter"],
                      style: TextStyle(
                          color: Colors.pink, fontWeight: FontWeight.bold))
                  : Text("   -- Twitter --",
                      style: TextStyle(color: Colors.grey[700])),
            ],
          ),
          Text(" "),
          Row(
            children: [
              Image.network(
                "https://cdn.iconscout.com/icon/free/png-256/github-153-675523.png",
                height: 20,
                width: 20,
              ),
              (g.data["github"] != null)
                  ? Text("   " + g.data["github"],
                      style: TextStyle(
                          color: Colors.pink, fontWeight: FontWeight.bold))
                  : Text("   -- Github --",
                      style: TextStyle(color: Colors.grey[700])),
            ],
          ),
          showPrimaryButton("Edit Profile ID", SocialEdit(), 0, getsocial),
        ],
      ),
    );
  }

  Widget showPrimaryButton(
      String btext, var nextclass, int inc, var updatefunction) {
    return new Container(
        padding: EdgeInsets.fromLTRB(66.0, 0, 66.0, 0),
        child: SizedBox(
          child: new RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Colors.indigo[900],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit,
                    size: 15,
                    color: Colors.white,
                  ),
                  Text('  ' + btext,
                      style:
                          new TextStyle(fontSize: 15.0, color: Colors.white)),
                ],
              ),
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => nextclass,
                    ));
                setState(() {
                  inc++;
                });
                await updatefunction();
                setState(() {
                  inc++;
                });
              }),
        ));
  }

  void makepdf() async {
    final pw.Document doc = pw.Document();
    final output = await getExternalStorageDirectory();
    print(output.path);
    final file = File("${output.path}/Resume.pdf");
    final PdfImage imageach = await pdfImageFromImageProvider(
      pdf: doc.document,
      image: const AssetImage('assets/achicon.png'),
    );
    final PdfImage imageedu = await pdfImageFromImageProvider(
      pdf: doc.document,
      image: const AssetImage('assets/eduicon.png'),
    );
    final PdfImage imageexp = await pdfImageFromImageProvider(
      pdf: doc.document,
      image: const AssetImage('assets/expicon.png'),
    );
    final PdfImage imagehobby = await pdfImageFromImageProvider(
      pdf: doc.document,
      image: const AssetImage('assets/hobicon.png'),
    );
    final PdfImage imageskill = await pdfImageFromImageProvider(
      pdf: doc.document,
      image: const AssetImage('assets/skillicon.png'),
    );
    final PdfImage imageproject = await pdfImageFromImageProvider(
      pdf: doc.document,
      image: const AssetImage('assets/projicon.png'),
    );
    final PdfImage imagesocial = await pdfImageFromImageProvider(
      pdf: doc.document,
      image: const AssetImage('assets/social.png'),
    );
    final PdfImage imageinsta = await pdfImageFromImageProvider(
      pdf: doc.document,
      image: NetworkImage(
          "https://www.edigitalagency.com.au/wp-content/uploads/new-instagram-logo-png-transparent-light.png"),
    );
    final PdfImage imagefb = await pdfImageFromImageProvider(
      pdf: doc.document,
      image: NetworkImage(
          "https://1000logos.net/wp-content/uploads/2016/11/Facebook-Logo.png"),
    );
    final PdfImage imagelinkedin = await pdfImageFromImageProvider(
      pdf: doc.document,
      image: NetworkImage(
          "https://www2.le.ac.uk/offices/careers-new/copy2_of_images/linkedin-logo/image"),
    );
    final PdfImage imagegit = await pdfImageFromImageProvider(
      pdf: doc.document,
      image: NetworkImage(
          "https://cdn.iconscout.com/icon/free/png-256/github-153-675523.png"),
    );
    final PdfImage imagetwit = await pdfImageFromImageProvider(
      pdf: doc.document,
      image: NetworkImage(
          "https://elementarylibrarian.com/wp-content/uploads/2013/11/twitter-bird-white-on-blue.png"),
    );
    doc.addPage(pw.MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          if (context.pageNumber == 1) {
            return null;
          }
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 10 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3 * PdfPageFormat.mm),
              // decoration: const pw.BoxDecoration(
              //     border: pw.BoxBorder(
              //         bottom: true, width: 0.5, color: PdfColors.grey)),
              child: pw.Text('Resume',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (pw.Context context) => <pw.Widget>[
              pw.Stack(children: [
                pw.Paragraph(
                    padding: pw.EdgeInsets.fromLTRB(0, 20, 270, 0),
                    text: g.data["name"],
                    style:
                        pw.TextStyle(color: PdfColors.indigo700, fontSize: 20)),
                pw.Paragraph(
                    padding: pw.EdgeInsets.fromLTRB(250, 10, 0, 0),
                    margin: pw.EdgeInsets.all(0),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                    text: 'Email:  ' + g.data["email"]),
                pw.Paragraph(
                    padding: pw.EdgeInsets.fromLTRB(250, 25, 0, 0),
                    margin: pw.EdgeInsets.all(0),
                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                    text: 'Phone:  ' + g.data["phone"]),
                if (g.data["state"] != null && g.data["zip_code"] != null)
                  pw.Paragraph(
                      padding: pw.EdgeInsets.fromLTRB(250, 40, 0, 0),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                      text: 'State:  ' +
                          g.data["state"] +
                          " - " +
                          g.data["zip_code"]),
              ]),
              if (exp_data["exps"].length >= 1)
                pw.Container(
                  height: 3,
                  width: double.infinity,
                  color: PdfColors.grey,
                ),
              if (exp_data["exps"].length >= 1)
                pw.Container(padding: pw.EdgeInsets.all(10)),
              if (exp_data["exps"].length >= 1)
                pw.Container(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Stack(
                        children: [
                          pw.Container(
                            child: pw.Image(imageexp),
                            height: 20,
                            width: 20,
                          ),
                          pw.Container(
                            width: 200,
                            padding: pw.EdgeInsets.fromLTRB(40, 0, 0, 20),
                            child: pw.Text("EXPERIENCES",
                                style: pw.TextStyle(
                                    color: PdfColors.indigo700, fontSize: 15)),
                          ),
                        ],
                      ),
                      pw.Container(
                          padding: pw.EdgeInsets.fromLTRB(40, 0, 0, 5),
                          alignment: pw.Alignment.topLeft,
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(exp_data["exps"][0]["company"],
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                              pw.Text(exp_data["exps"][0]["designation"],
                                  style: pw.TextStyle(color: PdfColors.grey)),
                              pw.Text(
                                  exp_data["exps"][0]["start"] +
                                      " - " +
                                      exp_data["exps"][0]["end"],
                                  style: pw.TextStyle(color: PdfColors.grey)),
                              pw.Text(exp_data["exps"][0]["des"]),
                              pw.Container(padding: pw.EdgeInsets.all(10)),
                            ],
                          )),
                    ],
                  ),
                ),
              for (var i = 1; i < exp_data["exps"].length; i++)
                pw.Container(
                    padding: pw.EdgeInsets.fromLTRB(40, 0, 0, 5),
                    alignment: pw.Alignment.topLeft,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(exp_data["exps"][i]["company"],
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(exp_data["exps"][i]["designation"],
                            style: pw.TextStyle(color: PdfColors.grey)),
                        pw.Text(
                            exp_data["exps"][i]["start"] +
                                " - " +
                                exp_data["exps"][i]["end"],
                            style: pw.TextStyle(color: PdfColors.grey)),
                        pw.Text(exp_data["exps"][i]["des"]),
                        pw.Container(padding: pw.EdgeInsets.all(10)),
                      ],
                    )),
              if (edu_data["edus"].length >= 1)
                pw.Container(
                  height: 3,
                  width: double.infinity,
                  color: PdfColors.grey,
                ),
              if (edu_data["edus"].length >= 1)
                pw.Container(padding: pw.EdgeInsets.all(10)),
              if (edu_data["edus"].length >= 1)
                pw.Container(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Stack(
                        children: [
                          pw.Container(
                            // ignore: deprecated_member_use
                            child: pw.Image(imageedu),
                            height: 20,
                            width: 20,
                          ),
                          pw.Container(
                            width: 170,
                            padding: pw.EdgeInsets.fromLTRB(40, 0, 0, 20),
                            child: pw.Text("EDUCATIONS",
                                style: pw.TextStyle(
                                    color: PdfColors.indigo700, fontSize: 15)),
                          ),
                        ],
                      ),
                      pw.Container(
                          padding: pw.EdgeInsets.fromLTRB(40, 0, 0, 5),
                          alignment: pw.Alignment.topLeft,
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(edu_data["edus"][0]["name"],
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                              pw.Text(edu_data["edus"][0]["type"]),
                              pw.Text(edu_data["edus"][0]["course"],
                                  style: pw.TextStyle(color: PdfColors.grey)),
                              pw.Text(
                                  edu_data["edus"][0]["start"] +
                                      " - " +
                                      edu_data["edus"][0]["end"],
                                  style: pw.TextStyle(color: PdfColors.grey)),
                              pw.Container(padding: pw.EdgeInsets.all(5)),
                            ],
                          )),
                    ],
                  ),
                ),
              for (var i = 1; i < edu_data["edus"].length; i++)
                pw.Container(
                    padding: pw.EdgeInsets.fromLTRB(40, 0, 0, 5),
                    alignment: pw.Alignment.topLeft,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(edu_data["edus"][i]["name"],
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(edu_data["edus"][i]["type"]),
                        pw.Text(edu_data["edus"][i]["course"],
                            style: pw.TextStyle(color: PdfColors.grey)),
                        pw.Text(
                            edu_data["edus"][i]["start"] +
                                " - " +
                                edu_data["edus"][i]["end"],
                            style: pw.TextStyle(color: PdfColors.grey)),
                        pw.Container(padding: pw.EdgeInsets.all(5)),
                      ],
                    )),
              if (project_data["projects"].length >= 1)
                pw.Container(
                  height: 3,
                  width: double.infinity,
                  color: PdfColors.grey,
                ),
              if (project_data["projects"].length >= 1)
                pw.Container(padding: pw.EdgeInsets.all(10)),
              if (project_data["projects"].length >= 1)
                pw.Container(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Stack(
                        children: [
                          pw.Container(
                            child: pw.Image(imageproject),
                            height: 20,
                            width: 20,
                          ),
                          pw.Container(
                            width: 170,
                            padding: pw.EdgeInsets.fromLTRB(40, 0, 0, 20),
                            child: pw.Text("PROJECTS",
                                style: pw.TextStyle(
                                    color: PdfColors.indigo700, fontSize: 15)),
                          ),
                        ],
                      ),
                      pw.Container(
                          padding: pw.EdgeInsets.fromLTRB(40, 0, 0, 5),
                          alignment: pw.Alignment.topLeft,
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(project_data["projects"][0]["title"],
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                              pw.Text(project_data["projects"][0]["des"]),
                              pw.Container(padding: pw.EdgeInsets.all(5)),
                            ],
                          )),
                    ],
                  ),
                ),
              for (var i = 1; i < project_data["projects"].length; i++)
                pw.Container(
                    padding: pw.EdgeInsets.fromLTRB(40, 0, 0, 5),
                    alignment: pw.Alignment.topLeft,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(project_data["projects"][i]["title"],
                            style:
                                pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.Text(project_data["projects"][i]["des"]),
                        pw.Container(padding: pw.EdgeInsets.all(5)),
                      ],
                    )),
              if (ach_data.length >= 1)
                pw.Container(
                  height: 3,
                  width: double.infinity,
                  color: PdfColors.grey,
                ),
              if (ach_data.length >= 1)
                pw.Container(padding: pw.EdgeInsets.all(10)),
              if (ach_data.length >= 1)
                pw.Container(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Stack(
                        children: [
                          pw.Container(
                            child: pw.Image(imageach),
                            height: 20,
                            width: 20,
                          ),
                          pw.Container(
                            width: 200,
                            padding: pw.EdgeInsets.fromLTRB(40, 0, 0, 20),
                            child: pw.Text("ACHIEVEMENTS",
                                style: pw.TextStyle(
                                    color: PdfColors.indigo700, fontSize: 15)),
                          ),
                        ],
                      ),
                      pw.Bullet(
                          padding: pw.EdgeInsets.fromLTRB(30, 0, 0, 5),
                          text: ach_data[0]),
                    ],
                  ),
                ),
              for (var i = 1; i < ach_data.length; i++)
                pw.Bullet(
                    padding: pw.EdgeInsets.fromLTRB(30, 0, 0, 5),
                    text: ach_data[i]),
              if (skill_data["skills"].length >= 1)
                pw.Container(
                  height: 3,
                  width: double.infinity,
                  color: PdfColors.grey,
                ),
              if (skill_data["skills"].length >= 1)
                pw.Container(padding: pw.EdgeInsets.all(10)),
              if (skill_data["skills"].length >= 1)
                pw.Container(
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Stack(
                          children: [
                            pw.Container(
                              child: pw.Image(imageskill),
                              height: 20,
                              width: 20,
                            ),
                            pw.Container(
                              width: 170,
                              padding: pw.EdgeInsets.fromLTRB(40, 0, 0, 20),
                              child: pw.Text("SKILLS",
                                  style: pw.TextStyle(
                                      color: PdfColors.indigo700,
                                      fontSize: 15)),
                            ),
                          ],
                        ),
                        pw.Bullet(
                            padding: pw.EdgeInsets.fromLTRB(30, 0, 0, 5),
                            text: skill_data["skills"][0]["name"] +
                                " - " +
                                skill_data["skills"][0]["rating"].toString() +
                                "/5"),
                      ]),
                ),
              for (var i = 1; i < skill_data["skills"].length; i++)
                pw.Bullet(
                    padding: pw.EdgeInsets.fromLTRB(30, 0, 0, 5),
                    text: skill_data["skills"][i]["name"] +
                        " - " +
                        skill_data["skills"][i]["rating"].toString() +
                        "/5"),
              if (hobby_data.length >= 1)
                pw.Container(
                  height: 3,
                  width: double.infinity,
                  color: PdfColors.grey,
                ),
              if (hobby_data.length >= 1)
                pw.Container(padding: pw.EdgeInsets.all(10)),
              if (hobby_data.length >= 1)
                pw.Container(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Stack(
                        children: [
                          pw.Container(
                            child: pw.Image(imagehobby),
                            height: 20,
                            width: 20,
                          ),
                          pw.Container(
                            width: 170,
                            padding: pw.EdgeInsets.fromLTRB(40, 0, 0, 20),
                            child: pw.Text("HOBBIES",
                                style: pw.TextStyle(
                                    color: PdfColors.indigo700, fontSize: 15)),
                          ),
                        ],
                      ),
                      pw.Bullet(
                          padding: pw.EdgeInsets.fromLTRB(30, 0, 0, 5),
                          text: hobby_data[0]),
                    ],
                  ),
                ),
              for (var i = 1; i < hobby_data.length; i++)
                pw.Bullet(
                    padding: pw.EdgeInsets.fromLTRB(30, 0, 0, 5),
                    text: hobby_data[i]),
              if (g.data["insta"] != null ||
                  g.data["fb"] != null ||
                  g.data["linkedin"] != null ||
                  g.data["github"] != null ||
                  g.data["twitter"] != null)
                pw.Container(
                  height: 3,
                  width: double.infinity,
                  color: PdfColors.grey,
                ),
              if (g.data["insta"] != null ||
                  g.data["fb"] != null ||
                  g.data["linkedin"] != null ||
                  g.data["github"] != null ||
                  g.data["twitter"] != null)
                pw.Container(padding: pw.EdgeInsets.all(10)),
              if (g.data["insta"] != null ||
                  g.data["fb"] != null ||
                  g.data["linkedin"] != null ||
                  g.data["github"] != null ||
                  g.data["twitter"] != null)
                pw.Container(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Stack(
                        children: [
                          pw.Container(
                            child: pw.Image(imagesocial),
                            height: 20,
                            width: 20,
                          ),
                          pw.Container(
                            width: 200,
                            padding: pw.EdgeInsets.fromLTRB(40, 0, 0, 20),
                            child: pw.Text("Social Media Accounts",
                                style: pw.TextStyle(
                                    color: PdfColors.indigo700, fontSize: 15)),
                          ),
                        ],
                      ),
                      if (g.data["insta"] != null)
                        pw.Container(
                          padding: pw.EdgeInsets.fromLTRB(40, 10, 20, 0),
                          child: pw.Row(children: [
                            pw.Container(
                              // ignore: deprecated_member_use
                              child: pw.Image(imageinsta),
                              height: 20,
                              width: 20,
                            ),
                            pw.Text(" - " + g.data["insta"]),
                          ]),
                        ),
                      if (g.data["fb"] != null)
                        pw.Container(
                          padding: pw.EdgeInsets.fromLTRB(40, 10, 20, 0),
                          child: pw.Row(children: [
                            pw.Container(
                              child: pw.Image(imagefb),
                              height: 20,
                              width: 20,
                            ),
                            pw.Text(" - " + g.data["fb"]),
                          ]),
                        ),
                      if (g.data["linkedin"] != null)
                        pw.Container(
                          padding: pw.EdgeInsets.fromLTRB(40, 10, 20, 0),
                          child: pw.Row(children: [
                            pw.Container(
                              child: pw.Image(imagelinkedin),
                              height: 20,
                              width: 20,
                            ),
                            pw.Text(" - " + g.data["linkedin"]),
                          ]),
                        ),
                      if (g.data["github"] != null)
                        pw.Container(
                          padding: pw.EdgeInsets.fromLTRB(40, 10, 20, 0),
                          child: pw.Row(children: [
                            pw.Container(
                              child: pw.Image(imagegit),
                              height: 20,
                              width: 20,
                            ),
                            pw.Text(" - " + g.data["github"]),
                          ]),
                        ),
                      if (g.data["twitter"] != null)
                        pw.Container(
                          padding: pw.EdgeInsets.fromLTRB(40, 10, 20, 10),
                          child: pw.Row(children: [
                            pw.Container(
                              child: pw.Image(imagetwit),
                              height: 20,
                              width: 20,
                            ),
                            pw.Text(" - " + g.data["twitter"]),
                          ]),
                        ),
                    ],
                  ),
                ),
            ]));
    await file.writeAsBytes(doc.save());
    print(output.path);
    setState(() {
      onclick = false;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PDFScreen(output.path + "/Resume.pdf")));
  }

  Widget shopdfButton() {
    return new Container(
        color: Colors.indigo[900],
        padding: EdgeInsets.fromLTRB(50.0, 15, 50, 15),
        child: SizedBox(
          child: new RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (onclick)
                      ? Container(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Colors.indigo)))
                      : Icon(
                          Icons.file_download,
                          size: 25,
                          color: Colors.indigo[900],
                        ),
                  Text('  Convert to PDF',
                      style: new TextStyle(
                          fontSize: 18, color: Colors.indigo[900])),
                ],
              ),
              onPressed: () async {
                setState(() {
                  onclick = true;
                });
                print(exp_data);
                makepdf();
              }),
        ));
  }

  Widget build(BuildContext context) {
    if (edu_data == null) getedu();
    if (skill_data == null) getskill();
    if (exp_data == null) getexp();
    if (ach_data == null) getach();
    if (hobby_data == null) gethobby();
    if (project_data == null) getproject();
    return MaterialApp(
        title: "Herody",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Resume",
                style: TextStyle(color: Colors.white),
              ),
              automaticallyImplyLeading: true,
              leading: IconButton(
                color: Colors.white,
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: Colors.indigo[800],
            ),
            body: ListView(children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(20, 20, 10, 20),
                      height: 120,
                      width: 110,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage((g
                                    .data["profile_photo"] !=
                                null)
                            ? "https://herody.in/assets/user/images/user_profile/" +
                                g.data["profile_photo"]
                            : "https://d3q6qq2zt8nhwv.cloudfront.net/m/1_extra_hzavn771.jpg"),
                        radius: 35,
                      ),
                    ),
                    Container(
                      height: 110,
                      width: 2,
                      color: Colors.grey,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 160,
                      padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            g.data["name"],
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[800]),
                            textAlign: TextAlign.left,
                          ),
                          Text(" ", style: TextStyle(fontSize: 5)),
                          g.data["email"] == "null"
                              ? Text(
                                  "Email:  " + "",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.indigo[800]),
                                  textAlign: TextAlign.left,
                                )
                              : Text(
                                  "Email:  " + "${g.data["email"]}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.indigo[800]),
                                  textAlign: TextAlign.left,
                                ),
                          Text(" ", style: TextStyle(fontSize: 5)),
                          Text(
                            "${g.data["phone"]}" == "null"
                                ? "Phone:  " + ""
                                : "Phone:  " + "${g.data["phone"]}",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Colors.indigo[800]),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ]),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    height: 20,
                    width: double.infinity,
                    color: Colors.indigo[800],
                  ),
                  showeducation(),
                  showskills(),
                  showexperience(),
                  showprojects(),
                  showachievements(),
                  showhobbies(),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    height: 20,
                    width: double.infinity,
                    color: Colors.indigo[800],
                  ),
                  socialprofiles(),
                  shopdfButton()
                ],
              ),
            ])));
  }
}
