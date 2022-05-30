import 'package:flutter/material.dart';
import 'package:flutter_phone_state/extensions_static.dart';
import 'package:flutter_phone_state/flutter_phone_state.dart';
import 'package:herody/globaldata.dart' as g;

class CallSession extends StatefulWidget {
  @override
  _CallSessionState createState() => _CallSessionState();
}

class _CallSessionState extends State<CallSession> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: callSession(),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "Herody",
          style: TextStyle(fontSize: 28.0),
        ),
      ),
    );
  }

  Widget callSession() {
    return Container(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
            child: Container(
              height: 40,
              color: Colors.grey[300],
              child: ListTile(
                title: Text(
                    "Telecalling Internship - Herody - Apply before 23 Jan 2021",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: Container(
              height: 35,
              color: Colors.grey[300],
              child: ListTile(
                title: Text(
                    "End Date:                                                                        23 Jan 2021",
                    style: TextStyle(
                      fontSize: 13,
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 15),
            child: Container(
              height: 50,
              color: Colors.grey[300],
              child: ListTile(
                title: Text(
                    "Total calls attempted:                                                              00",
                    style: TextStyle(
                      fontSize: 13,
                    )),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: Container(
              color: Color(0xffd7faef),
              height: 30,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                    width: MediaQuery.of(context).size.width - 260,
                    child: Text(
                      "Session timer",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
            child: Container(
              color: Color(0xffd7faef),
              height: 50,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 5),
                    width: MediaQuery.of(context).size.width - 160,
                    child: Text(
                      "00:58",
                      style: TextStyle(
                        color: Color(0xff00d68f),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 10, 10),
                child: Container(
                  width: 150,
                  height: 100,
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Text(" Project earnings",
                        style: TextStyle(
                          color: Color(0xff00d68f),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                child: Container(
                  width: 150,
                  height: 100,
                  color: Colors.grey[100],
                  child: Padding(
                    padding: const EdgeInsets.all(9.0),
                    child: Text(" Minutes spoken",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        )),
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.headset_mic_outlined,
                      color: Color(0xff00d68f),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 5),
                      width: MediaQuery.of(context).size.width - 260,
                      child: Text(
                        "Call later list",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(180, 0, 0, 0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: Container(
                  width: 700,
                  height: 4,
                  color: Colors.grey[200],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                child: Row(
                  children: [
                    Icon(
                      Icons.bar_chart_outlined,
                      color: Color(0xff00d68f),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 0, 5),
                      width: MediaQuery.of(context).size.width - 160,
                      child: Text(
                        "Progress report",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(80, 0, 0, 0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 5),
                child: Container(
                  width: 700,
                  height: 4,
                  color: Colors.grey[200],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
