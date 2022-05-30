import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:http/http.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'globaldata.dart' as g;
import 'package:intl/intl.dart';

class Wallet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _WalletState();
}

class _WalletState extends State<Wallet> {
  var trans_data;
  var balance = '';
  var alltrans_data;
  var methods_data;
  int onclickmethod = 1;
  String _uremarks = "";
  String amount = "";
  List<String> _errorMessage = [];
  List<bool> showForm = [];
  List<bool> submitted = [];
  List<bool> _isLoading = [];
  final _formKey = new GlobalKey<FormState>();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _upi_id = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _account_holder_name = TextEditingController();
  TextEditingController _account_no = TextEditingController();
  TextEditingController _ifsc_code = TextEditingController();
  TextEditingController _withdraw_amount = TextEditingController();
  String _accountHolderName;
  String _accountNumber;
  String _IFSCcode;
  double _damount;
  double min_amount;

  void getdata() async {
    String url = g.preurl + "user/allTransactions";
    setState(() async {
      Response response = await post(url, body: {"id": g.uid});

      print(response.body);

      trans_data = jsonDecode(response.body);
      balance = trans_data["response"]["user_balance"].toString();
      print(trans_data);
    });
  }

  void getalltrans() async {
    String url = g.preurl + "user/transactions";
    Response response = await post(url, body: {"uid": g.uid});
    print(response.body);
    setState(() {
      alltrans_data = jsonDecode(response.body);
    });
    print(alltrans_data);
  }

  void gettransactionmethods() async {
    String url = g.preurl + "user/withdrawMethod";
    Response response = await post(url);
    setState(() {
      methods_data = json.decode(response.body)["response"];
    });
  }

  Widget showRemarksInput(String hint, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        decoration: new InputDecoration(
            //border: InputBorder.none,
            hintText: null == hint ? 'Enter Remarks' : hint,
            icon: new Icon(
              Icons.textsms,
              color: Colors.grey,
            )),
        controller: controller,
        validator: (value) =>
            value.trim().isEmpty ? '$hint can\'t be empty' : null,
        onSaved: (value) => _uremarks = value.trim(),
      ),
    );
  }

  Widget showAmountInput(int i) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        onChanged: (value) => _errorMessage[i] = "",
        decoration: new InputDecoration(
          //border: InputBorder.none,
          hintText: '',
          icon: ImageIcon(AssetImage("assets/rupeeicon.png")),
        ),
        validator: (value) =>
            (value.trim().isEmpty) ? 'Amount should not be empty' : null,
        onSaved: (value) {
          amount = value.trim();

          _damount = double.parse(amount);
        },
      ),
    );
  }

  Widget showAccountNumberInput(int i) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        onChanged: (value) => _errorMessage[i] = "",
        decoration: new InputDecoration(
          //border: InputBorder.none,
          hintText: '',
          icon: Icon(
            Icons.home,
            size: 25,
          ),
        ),
        validator: (value) =>
            (value.trim().isEmpty) ? 'Account Number can not be empty' : null,
        onSaved: (value) => _accountNumber = value.trim(),
      ),
    );
  }

  Widget showAccountHolderNameInput(int i) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        onChanged: (value) => _errorMessage[i] = "",
        decoration: new InputDecoration(
          //border: InputBorder.none,
          hintText: '',
          icon: Icon(Icons.account_circle),
        ),
        validator: (value) =>
            (value.trim().isEmpty) ? 'This field should not be empty ' : null,
        onSaved: (value) => _accountHolderName = value.trim(),
      ),
    );
  }

  Widget showIFSCCodemInput(int i) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        onChanged: (value) => _errorMessage[i] = "",
        decoration: new InputDecoration(
          //border: InputBorder.none,
          hintText: '',
          icon: Icon(Icons.code),
        ),
        validator: (value) =>
            (value.trim().isEmpty) ? 'This field should not be empty ' : null,
        onSaved: (value) {
          _IFSCcode = value.trim();
        },
      ),
    );
  }

  getValueFromRemoteConfig() async {
    String amount;
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();

    amount = remoteConfig.getString("AMOUNT");
    setState(() {
      min_amount = double.parse(amount);
      print(min_amount.toString() + "==========================");
    });
  }

  bool validateAndSave(int i) {
    getValueFromRemoteConfig();
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      if (trans_data["response"]["user_balance"] >= double.parse(amount) &&
          double.parse(amount) >= min_amount)
        return true;
      else if (double.parse(amount) <= min_amount) {
        setState(() {
          _errorMessage[i] = "Balance should be more than ₹100";
        });
      } else {
        setState(() {
          _errorMessage[i] = "Insufficient Balance";
        });
      }
    }
    return false;
  }

  void validateAndSubmit(int id, int i) async {
    if (validateAndSave(i)) {
      print("validated");
      setState(() {
        _isLoading[i] = true;
      });

      final RemoteConfig remoteConfig = await RemoteConfig.instance;
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();

      String accountNumber =
          remoteConfig.getString("BANK_AC_NUMBER").toString();
      String currency = remoteConfig.getString("CURRENCY");
      String purpose = remoteConfig.getString("PURPOSE");
      String razor_key = remoteConfig.getString("RAZOR_KEY");
      String razor_pwd = remoteConfig.getString("RAZOR_PWD");
      String account_type = remoteConfig.getString("ACCOUNT_TYPE");
      // String upiAccount_type = remoteConfig.getString("VPA");
      String if_low_balance = remoteConfig.getString("QUEUED_IF_LOW_BALANCE");
      bool lowbalance;

      if (if_low_balance == "true") {
        lowbalance = true;
      } else {
        lowbalance = false;
      }

      String url = "https://api.razorpay.com/v1/payouts";
      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$razor_key:$razor_pwd'));
      print(basicAuth);
      var body;
      methods_data["method"][i]["name"] == "UPI ID (VPA)"
          ? body = json.encode({
              "account_number": accountNumber,
              "amount": _damount * 100,
              "currency": currency,
              "mode": "UPI",
              "purpose": "payout",
              "fund_account": {
                "account_type": "vpa",
                "vpa": {"address": _upi_id.text},
                "contact": {
                  "name": _name.text,
                  "email": '',
                  "contact": _phoneNumber.text,
                  "notes": {
                    "notes_key_1": "Tea, Earl Grey, Hot",
                    "notes_key_2": "Tea, Earl Grey… decaf."
                  }
                }
              },
              "queue_if_low_balance": lowbalance,
              "notes": {
                "notes_key_1": "Beam me up Scotty",
                "notes_key_2": "Engage"
              }
            })
          : body = json.encode({
              "account_number": accountNumber,
              "amount": _damount * 100,
              "currency": currency,
              "mode": "NEFT",
              "purpose": "payout",
              "fund_account": {
                "account_type": "bank_account",
                "bank_account": {
                  "name": _account_holder_name.text,
                  "ifsc": _ifsc_code.text,
                  "account_number": _account_no.text
                },
                "contact": {
                  "name": _account_holder_name.text,
                  "email": '',
                  "contact": _phoneNumber.text,
                  "notes": {
                    "notes_key_1": "Tea, Earl Grey, Hot",
                    "notes_key_2": "Tea, Earl Grey… decaf."
                  }
                }
              },
              "queue_if_low_balance": lowbalance,
              "notes": {
                "notes_key_1": "Beam me up Scotty",
                "notes_key_2": "Engage"
              }
            });

      Map<String, String> headers = {
        "Content-Type": "application/json",
        'Accept': 'application/json',
        'Authorization': basicAuth
      };

      Response response = await post(url, body: body, headers: headers);
      print("response status code for payout" + response.statusCode.toString());
      var d = json.decode(response.body);
      print(d);
      print(response);

      String withDrawUrl = g.preurl + "razorp/withdraw";
      Map<String, String> header = {
        "Content-Type": "application/json",
        'Accept': 'application/json',
      };
      // ignore: unrelated_type_equality_checks
      if (response.statusCode == 200) {
        Response responseObj = await post(withDrawUrl,
            body: jsonEncode({"id": g.uid, "amt": _damount}), headers: header);
        var withdrawResponse = jsonDecode(responseObj.body);
        print(withdrawResponse);

        if (withdrawResponse["response"]["code"] == "SUCCESS") {
          if (methods_data["method"][i]["name"] == "UPI ID (VPA)") {
            Firestore.instance.collection("transactions").add({
              "uid": g.uid,
              "method": methods_data["method"][i]["name"],
              "amount": _damount,
              "UPI ID": _upi_id.text,
              "name": _name.text,
              "mobile no": _phoneNumber.text,
              "date": DateTime.now(),
            });
          } else {
            Firestore.instance.collection("transactions").add({
              "uid": g.uid,
              "method": methods_data["method"][i]["name"],
              "amount": _damount,
              "account holder name": _account_holder_name.text,
              "account no": _account_no.text,
              "ifsc code": _ifsc_code.text,
              "date": DateTime.now(),
            });
          }
        }

        alertbox(
            context,
            AlertType.success,
            "Success",
            "Payment is processed, it will take 24 hours",
            Colors.blue.shade300,
            "Ok");
        setState(() {
          balance = trans_data["response"]["user_balance"].toString();
        });
      } else {
        alertbox(
            context,
            AlertType.error,
            "${d["error"]["code"]}",
            " ${d["error"]["description"]}",
            Colors.lightBlue.shade600,
            "Try Again");
      }
      setState(() {
        showForm[i] = false;
        _isLoading[i] = false;
        submitted[i] = true;
        _uremarks = null;
        amount = null;
      });
    }
  }

  Widget showErrorMessage(int i) {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Container(
          alignment: Alignment.center,
          child: new Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: new Text(
                _errorMessage[i],
                style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              )));
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget _showCircularProgress(int i) {
    return Container(
        width: double.infinity,
        height: 60,
        alignment: Alignment.bottomCenter,
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.purple[900])));
  }

  Widget showPrimaryButton(int i, int id) {
    return new Container(
        padding: EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
        child: SizedBox(
          child: new RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: (_isLoading[i]) ? Colors.pink : Colors.indigo[900],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!submitted[i])
                    Icon(
                      Icons.save_alt,
                      size: 15,
                      color: Colors.white,
                    ),
                  Text(
                      (submitted[i])
                          ? 'Submitted'
                          : (showForm[i])
                              ? '  Transfer'
                              : '  Withdraw Money',
                      style:
                          new TextStyle(fontSize: 15.0, color: Colors.white)),
                ],
              ),
              onPressed: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                if (!submitted[i]) {
                  if (showForm[i] == false) {
                    setState(() {
                      for (var j = 0; j < showForm.length; j++) {
                        showForm[j] = false;
                      }
                      for (var j = 0; j < showForm.length; j++) {
                        _errorMessage[j] = "";
                      }
                      showForm[i] = true;
                      _formKey.currentState?.reset();
                    });
                  } else {
                    validateAndSubmit(id, i);
                  }
                }
              }),
        ));
  }

  Widget showtransactionmethods() {
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
                        // Image.network(
                        // "http://getdrawings.com/free-icon/rupee-icon-53.png",
                        // height: 50,
                        // ),
                        Text(
                          "  Methods to Withdraw your Money",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          child: IconButton(
                            icon: (onclickmethod % 2 == 0)
                                ? Icon(Icons.keyboard_arrow_up)
                                : Icon(Icons.keyboard_arrow_down),
                            onPressed: () {
                              setState(() {
                                onclickmethod++;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    if (onclickmethod % 2 == 0)
                      Divider(thickness: 2, color: Colors.pink),
                    if (onclickmethod % 2 == 0 &&
                        methods_data != null &&
                        methods_data["method"].length == 0)
                      Container(
                        child: Text(
                            "Sorry! All withdrawal methods are currently disabled",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                      ),
                    if (onclickmethod % 2 == 0)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: methods_data == null
                            ? 0
                            : methods_data["method"].length,
                        itemBuilder: (BuildContext context, i) {
                          showForm.add(false);
                          submitted.add(false);
                          _isLoading.add(false);
                          _errorMessage.add("");
                          return new Container(
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 10),
                                      child: Text(
                                        methods_data["method"][i]["name"],
                                        style: TextStyle(
                                            color: Colors.pink,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 5,
                                      ),
                                    ),
                                    Image.network(
                                      "https://herody.in/assets/user/images/withdraw/" +
                                          methods_data["method"][i]["image"],
                                      width: 200,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 10, 0, 20),
                                      width: 330,
                                      child: Text(
                                        "Note:-\n" +
                                            methods_data["method"][i]["detail"],
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 13),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                if (showForm[i] == true)
                                  Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 0),
                                          child: Text(
                                            (i == 0)
                                                ? "Enter Mobile number associated with Paytm:"
                                                : (i == 1)
                                                    ? "Enter Account holder name"
                                                    : "Enter Bank Account details (as mentioned above) to receive money to your Bank:",
                                            style: TextStyle(
                                                color: Colors.indigo[700]),
                                          ),
                                        ),
                                        (i == 0)
                                            ? showRemarksInput(
                                                "Mobile Number", _phoneNumber)
                                            : showRemarksInput(
                                                "Account holder name",
                                                _account_holder_name),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 0),
                                          child: Text("Amount to Withdraw",
                                              style: TextStyle(
                                                  color: Colors.indigo[700])),
                                        ),
                                        showAmountInput(i),
                                        // Container(
                                        //   padding: EdgeInsets.fromLTRB(
                                        //       10, 10, 10, 0),
                                        //   child: Text("Your UPI ID",
                                        //       style: TextStyle(
                                        //           color: Colors.indigo[700])),
                                        // ),
                                        // showAccountNumberInput(i),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 0),
                                          child: Text(
                                            (i == 0)
                                                ? "Enter your UPI ID"
                                                : (i == 1)
                                                    ? "Enter you Account Number:"
                                                    : "Enter you Account Number:",
                                            style: TextStyle(
                                                color: Colors.indigo[700]),
                                          ),
                                        ),
                                        (i == 0)
                                            ? showRemarksInput(
                                                "UPI ID", _upi_id)
                                            : showRemarksInput(
                                                "Account Number", _account_no),

                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              10, 10, 10, 0),
                                          child: Text(
                                            (i == 0)
                                                ? "Your Name"
                                                : (i == 1)
                                                    ? "Enter IFSC code:"
                                                    : "Enter IFSC code:",
                                            style: TextStyle(
                                                color: Colors.indigo[700]),
                                          ),
                                        ),
                                        (i == 0)
                                            ? showRemarksInput("Name", _name)
                                            : showRemarksInput(
                                                "IFSC code", _ifsc_code),
                                        // Container(
                                        //   padding: EdgeInsets.fromLTRB(
                                        //       10, 10, 10, 0),
                                        //   child: Text("IFSC code",
                                        //       style: TextStyle(
                                        //           color: Colors.indigo[700])),
                                        // ),
                                        // showIFSCCodeInput(i),
                                        // Container(
                                        //   padding: EdgeInsets.fromLTRB(
                                        //       10, 10, 10, 0),
                                        //   child: Text(
                                        //       (i == 1) ? "Your Name"
                                        //       style: TextStyle(
                                        //           color: Colors.indigo[700])),
                                        // ),
                                        // showAccountHolderNameInput(i),
                                      ],
                                    ),
                                  ),
                                if (_isLoading[i]) _showCircularProgress(i),
                                if (showForm[i] == true) showErrorMessage(i),
                                showPrimaryButton(
                                    i, methods_data["method"][i]["id"]),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return new Divider(
                            thickness: 2,
                            color: Colors.pink,
                          );
                        },
                      ),
                  ],
                )))));
  }

  ScrollController _scrollController = ScrollController();
  Widget showAlltrans() {
    return SingleChildScrollView(
      child: Container(
        width: 200,
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.only(top: 0),
                child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("transactions")
                        .where("uid", isEqualTo: "${g.uid}")
                        .orderBy("date")
                        .snapshots(),
                    // ignore: missing_return
                    builder: (_, snapshot) {
                      if (snapshot.data == null ||
                          snapshot.data.documents.length == 0) {
                        return Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                              decoration: BoxDecoration(
                                  color: Colors.yellow[800],
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black, blurRadius: 5),
                                  ],
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(20),
                                    left: Radius.circular(20),
                                  )),
                              child: Text(
                                "  Transactions History",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: Text(
                                "No transactions made yet",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            snapshot.data.documents.length != 0
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Text(
                                        "Date",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 70,
                                      ),
                                      Text(
                                        "Amount",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 50,
                                      ),
                                      Text(
                                        "Payment Method",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                : Center(
                                    child: Text(
                                      "No transactions made yet",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent),
                                    ),
                                  ),
                            SizedBox(
                              height: 20,
                            ),
                            ListView.builder(
                                reverse: true,
                                controller: _scrollController,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (_, index) {
                                  return Card(
                                      elevation: 2,
                                      shadowColor: Colors.grey.shade400,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            "${DateFormat.yMMMd().format(snapshot.data.documents[index].data["date"].toDate())}",
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.blue),
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          Container(
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: Text(
                                                "₹ ${snapshot.data.documents[index].data["amount"]}",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.green),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 60,
                                          ),
                                          Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              snapshot.data.documents[index]
                                                  .data["method"],
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.pink),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 25,
                                          )
                                        ],
                                      ));
                                }),
                          ],
                        );
                      }
                    })),
          ],
        ),
      ),
    );
  }

  /*Widget showAlltranssssss() {
    return Container(
      color: Colors.blue[50],
      padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
                decoration: BoxDecoration(
                    color: Colors.yellow[800],
                    boxShadow: [
                      BoxShadow(color: Colors.black, blurRadius: 5),
                    ],
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(20),
                    )),
                child: Text(
                  "  Transactions History",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Image.asset(
                  "assets/rupee_icon.png",
                  //"https://cdn4.iconfinder.com/data/icons/logos-3/426/rs-512.png",
                  height: 30,
                ),
              )
            ],
          ),
          (alltrans_data != null &&
                  alltrans_data["response"]["transactions"].length != 0)
              ? ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: alltrans_data == null
                      ? 0
                      : alltrans_data["response"]["transactions"].length,
                  itemBuilder: (BuildContext context, i) {
                    print("inside");
                    return Container(
                        child: Stack(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: (alltrans_data["response"]["transactions"]
                                          [i]["transition"]
                                      .toString()
                                      .startsWith("+"))
                                  ? Colors.green
                                  : Colors.red,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 10,
                          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(minHeight: 50),
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    width: 200,
                                    child: Text(
                                      alltrans_data["response"]["transactions"]
                                          [i]["reason"],
                                      style: TextStyle(color: Colors.grey[800]),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    "₹ " +
                                        alltrans_data["response"]
                                                    ["transactions"][i]
                                                ["transition"]
                                            .toString()
                                            .substring(1),
                                    style: TextStyle(
                                        color: (alltrans_data["response"]
                                                        ["transactions"][i]
                                                    ["transition"]
                                                .toString()
                                                .startsWith("+"))
                                            ? Colors.green
                                            : Colors.red,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(10, 40, 0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (alltrans_data["response"]
                                            ["transactions"][i]["transition"]
                                        .toString()
                                        .startsWith("+"))
                                    ? Colors.green
                                    : Colors.red,
                              ),
                              child: Icon(
                                (alltrans_data["response"]["transactions"][i]
                                            ["transition"]
                                        .toString()
                                        .startsWith("+"))
                                    ? Icons.arrow_drop_up
                                    : Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Container();
                  },
                )
              : Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: Text(
                    "No Transcations made yet.",
                    style: TextStyle(
                        color: Colors.grey[700], fontWeight: FontWeight.bold),
                  ))
        ],
      ),
    );
  }*/
  alertbox(context, alert_type, title, description, color, buttontitle) {
    return Alert(
      closeFunction: () {},
      closeIcon: Icon(null),
      context: context,
      type: alert_type,
      title: "$title",
      desc: "$description",
      style: AlertStyle(
        animationType: AnimationType.shrink,
        descStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: null == color ? Colors.blue : color),
        descTextAlign: TextAlign.start,
        animationDuration: Duration(milliseconds: 200),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(
            color: Colors.blue,
          ),
        ),
        titleStyle: TextStyle(
          color: Colors.red,
        ),
        alertAlignment: Alignment.center,
      ),
      buttons: [
        DialogButton(
          child: Text(
            "${buttontitle}",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    ).show();
  }

  Widget build(BuildContext context) {
    setState(() {
      if (trans_data == null) getdata();
    });

    if (methods_data == null) gettransactionmethods();

    if (alltrans_data == null) getalltrans();

    return MaterialApp(
        title: "Herody",
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              title: Text(
                "Wallet",
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
            body: (trans_data != null)
                ? ListView(
                    children: [
                      Image.network(
                        "https://img.freepik.com/free-vector/wallet-with-money-gold-coin_138676-148.jpg?size=626&ext=jpg",
                        height: 200,
                      ),
                      Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset("assets/mygigs.png", height: 24),
                                Column(
                                  children: [
                                    Text(
                                      "   Gigs Earnings",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              "₹ " +
                                  trans_data["response"]["gigEarnings"]
                                      .toString(),
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        color: Colors.white,
                        child: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset("assets/myinternships.png",
                                    height: 24),
                                Column(
                                  children: [
                                    Text(
                                      "   Internships Earnings",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              "₹ " +
                                  trans_data["response"]["projectEarnings"]
                                      .toString(),
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        color: Colors.white,
                        child: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset("assets/myprojects.png",
                                    height: 24),
                                Column(
                                  children: [
                                    Text(
                                      "   Projects Earnings",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              "₹ " +
                                  trans_data["response"]["campaignEarnings"]
                                      .toString(),
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      /*      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        color: Colors.white,
                        child: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset("assets/myinternships.png",
                                    height: 24),
                                Column(
                                  children: [
                                    Text(
                                      "   Internships Earnings",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              "₹ " +
                                  trans_data["response"]["projectEarnings"]
                                      .toString(),
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),*/
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        color: Colors.white,
                        child: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset("assets/referral.png", height: 20),
                                Column(
                                  children: [
                                    Text(
                                      "   Referral Earnings",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              "₹ " +
                                  trans_data["response"]["referralEarnings"]
                                      .toString(),
                              style: TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      Container(
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB(10, 5, 10, 20),
                          child: Text("Number of Referrals:  " +
                              trans_data["response"]["referred"].toString())),
                      Container(
                        alignment: Alignment.center,
                        color: Colors.indigo[700],
                        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                        child: StatefulBuilder(builder: (context, setState) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "Balance:",
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.white),
                                  ),
                                ],
                              ),
                              StatefulBuilder(builder: (context, setState) {
                                return Text(
                                  "₹ " +
                                      trans_data["response"]["user_balance"]
                                          .toString(),
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                );
                              }),
                            ],
                          );
                        }),
                      ),
                      showtransactionmethods(),
                      Container(
                        padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                        color: Colors.blue[50],
                        child: Container(
                          height: 2,
                          color: Colors.grey,
                        ),
                      ),
                      showAlltrans(),
                    ],
                  )
                : Container(
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.indigo[800])),
                  )));
  }
}
