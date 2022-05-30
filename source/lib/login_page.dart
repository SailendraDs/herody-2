import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'globaldata.dart' as g;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:flutter_truecaller/flutter_truecaller.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.loggedin});
  final VoidCallback loggedin;
  @override
  State<StatefulWidget> createState() =>
      new _LoginSignupPageState(loggedin: loggedin);
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  _LoginSignupPageState({this.loggedin});

  final VoidCallback loggedin;
  SharedPreferences prefs;
  //String username = 'on-board@herody.in';
  //String password = 'Jaketa2020';
  //String username = 'herody.onboard@gmail.com';
  //String password = 'JaketaEnts2020';
  //String username = 'nagulan1645@gmail.com';
  //String password = '2into2IS4\$';
  final FlutterTruecaller caller = new FlutterTruecaller();
  final _formKey = new GlobalKey<FormState>();
  String _uname = "";
  String _tcid = "";
  String _umobile = "";
  String _cpassword = "";
  String _rcode = "";
  String _email = "";
  String _password = "";
  String _errorMessage = "";
  String initialLink;
  var data = null;
  var tcdata = null;
  bool _isLoginForm;
  bool _isTruecallerLogin = false;
  bool _isLoading;
  bool onclick = false;
  bool otppage = false;
  bool _changepassword = false;
  bool email = false;
  int otp;

  Future<Null> initUniLinks() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      print(initialLink);
    } on PlatformException {
      print("didint find");
      // Handle exception by warning the user their action did not succeed
      // return?
    }
  }

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
  // Perform login or signup

  void validateAndSubmit() async {
    if (validateAndSave()) {
      print("validated");
      setState(() {
        _errorMessage = "";
        //_isLoading = true;
        onclick = true;
      });
      prefs = await SharedPreferences.getInstance();
      if (_isLoginForm) {
        setState(() {
          _isLoading = true;
        });

        await loginCallback();
        if (data != null) {
          switch (data["response"]["code"]) {
            case "SUCCESS":
              setState(() {
                otppage = true;
              });
              verifyPhone();
              break;
            case "PHONE NUMBER NOT CORRECT":
              setState(() {
                _isLoginForm = true;
                otppage = false;
                _isLoading = true;
                _errorMessage = "Account does not exist \n Please Sign Up";
                _isLoading = false;
              });
              break;
            default:
              setState(() {
                _errorMessage = "PHONE NUMBER NOT CORRECT";
              });
              break;
          }
        } else {
          setState(() {
            _errorMessage = "Account does not exist \n Please Sign Up";
          });
        }
        //  verifyPhone();
      } else {
        setState(() {
          _errorMessage = "Creating account...";
        });
        int temp = await signup();
        if (data != null) {
          print(data["response"]["code"]);
          _isLoading = true;
          switch (data["response"]["code"]) {
            case "SUCCESS":
              getotp();
              setState(() {
                otppage = true;
                _errorMessage = "";
              });
              verifyPhone();

              // sendEmail();
              break;
            case "REFRAL CODE DOES NOT EXIST":
              setState(() {
                _errorMessage = "Referal Code doesnot exist";
              });
              break;
            case "EMAIL ALREADY EXISTS":
              setState(() {
                _errorMessage = "Phone number already exists";
              });
              break;
            case "PASSWORDS DO NOT MATCH":
              setState(() {
                _errorMessage = "Passwords do not match";
              });
              break;
          }
        }
      }
      setState(() {
        _isLoading = false;
        onclick = false;
      });
    }
  }

  void tcvalidateAndSubmit() async {
    if (_email.length != 0 && _umobile.length != 0) {
      print("validated");
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });
      prefs = await SharedPreferences.getInstance();
      var url = g.preurl + 'user/loginTC';
      Response response = await post(url, body: {
        "email": _uname,
        'name': _uname,
        'phone': _umobile,
      });
      data = json.decode(response.body);
      g.uid = (data["response"]["user"]["id"]).toString();

      url = g.preurl + 'user/details';
      response = await post(url, body: {'id': g.uid});
      data = await json.decode(response.body);
      print(data["response"]["code"]);
      switch (data["response"]["code"]) {
        case "SUCCESS":
          if (data["response"]["user"]["email_verified_at"] == null) {
            String url = g.preurl + "user/email-verified";
            Response response = await post(url,
                body: {"id": data["response"]["user"]["id"].toString()});
            var data1 = json.decode(response.body);
          }
          g.data = (data["response"]["user"]);
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('userid', g.uid);

          widget.loggedin();
          break;
        default:
          setState(() {
            _errorMessage = "Something seems incorrect";
          });
          break;
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = "Something seems incorrect";
      });
    }
  }

  void otpvalidateAndSubmit() async {
    if (validateAndSave()) {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });
      var url = g.preurl + 'user/verifyMobile';
      Response response = await post(url,
          body: {"uid": data["response"]["user"]["id"].toString()});
      setState(() {
        otppage = false;
      });
      if (_umobile.isEmpty) {
        g.uid = (data["response"]["user"]["id"]).toString();
        g.data = (data["response"]["user"]);
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userid', g.uid);
        widget.loggedin();
      } else
        toggleFormMode();
      setState(() {
        _isLoading = false;
      });
    }
  }

  void sendEmail() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    // _showVerifyEmailSentDialog();
    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();
    if (remoteConfig.getString("VERIFICATION_MAIL_METHOD").toString() == "1") {
      String email = _email;
      String confirmlink = "https://herody.in/user/email-verified/" +
          (data["response"]["user"]["id"]).toString();
      print("haha");
      print(data["response"]["user"]["id"]);
      String username = remoteConfig.getString("SENDGRID_FROM_MAIL").toString();
      String api = remoteConfig.getString("SENDGRID_API_KEY").toString();
      var mail1 = '''{
  "personalizations": [3
    {
      "to": [
        {
          "email": "$email"
        }
      ],
      "subject": "Herody Email Verification"
    }
  ],
  "from": {
    "email": "$username"
  },
  "content": [
    {
      "type": "text/html",
      "value": "<!DOCTYPE html><html><body><h2>Welcome!</h2><p>We're excited to have you get started. First, you need to confirm your account. Just press the below link.<br></p><a href=$confirmlink >Confirm Account</a><p>If you have any questions, just reply to help@herody.in — we're always happy to help out.</p><p>Cheers,<br>Herody Team<br><br>Need more help?<br>We’re here to help you out</p></body></html>"    }
  ]
}''';
      Map<String, String> headers = new Map();
      headers["Authorization"] = "Bearer " + api;
      headers["Content-Type"] = "application/json";

      var url = 'https://api.sendgrid.com/v3/mail/send';
      var response = await post(url, headers: headers, body: mail1);
      print('Response status: ${response.statusCode}');
      print('Response header: ${response.headers}');
      print('Response body: ${response.body}');
    } else {
      print("hehe");
      String username = remoteConfig.getString("MAIL_USERNAME").toString();
      String password = remoteConfig.getString("MAIL_PASSWORD").toString();
      String host = remoteConfig.getString("MAIL_HOST").toString();
      int port = int.parse(remoteConfig.getString("MAIL_PORT").toString());
      String fromname = remoteConfig.getString("MAIL_FROM_NAME").toString();
      String frommail = remoteConfig.getString("MAIL_FROM_ADDRESS").toString();
      bool ssl = (remoteConfig.getString("MAIL_ENCRYPTION").toString() == "1")
          ? true
          : false;
      final smtpServer = SmtpServer(
        host,
        port: port,
        ssl: ssl,
        username: username,
        password: password,
      );
      final message = Message()
        ..from = Address(frommail, fromname)
        ..recipients.add(_email)
        ..subject = 'Herody Email Verification'
        ..html = '''<!doctype html>
                        <html>
                            <head>
                                <meta charset='utf-8'>
                                <meta name='viewport' content='width=device-width, initial-scale=1'>
                                <title>Herody - Email Verification</title>
                                <link href='https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css' rel='stylesheet'>
                                <link href='' rel='stylesheet'>
                                <style></style>
                                <script type='text/javascript' src='https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js'></script>
                                <script type='text/javascript' src='https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js'></script>
                                <script type='text/javascript'></script>
                            </head>
                            <body>
                            <!DOCTYPE html>
<html>

<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <style type="text/css">
        @media screen {
            @font-face {
                font-family: 'Lato';
                font-style: normal;
                font-weight: 400;
                src: local('Lato Regular'), local('Lato-Regular'), url(https://fonts.gstatic.com/s/lato/v11/qIIYRU-oROkIk8vfvxw6QvesZW2xOQ-xsNqO47m55DA.woff) format('woff');
            }

            @font-face {
                font-family: 'Lato';
                font-style: normal;
                font-weight: 700;
                src: local('Lato Bold'), local('Lato-Bold'), url(https://fonts.gstatic.com/s/lato/v11/qdgUG4U09HnJwhYI-uK18wLUuEpTyoUstqEm5AMlJo4.woff) format('woff');
            }

            @font-face {
                font-family: 'Lato';
                font-style: italic;
                font-weight: 400;
                src: local('Lato Italic'), local('Lato-Italic'), url(https://fonts.gstatic.com/s/lato/v11/RYyZNoeFgb0l7W3Vu1aSWOvvDin1pK8aKteLpeZ5c0A.woff) format('woff');
            }

            @font-face {
                font-family: 'Lato';
                font-style: italic;
                font-weight: 700;
                src: local('Lato Bold Italic'), local('Lato-BoldItalic'), url(https://fonts.gstatic.com/s/lato/v11/HkF_qI1x_noxlxhrhMQYELO3LdcAZYWl9Si6vvxL-qU.woff) format('woff');
            }
        }

        /* CLIENT-SPECIFIC STYLES */
        body,
        table,
        td,
        a {
            -webkit-text-size-adjust: 100%;
            -ms-text-size-adjust: 100%;
        }

        table,
        td {
            mso-table-lspace: 0pt;
            mso-table-rspace: 0pt;
        }

        img {
            -ms-interpolation-mode: bicubic;
        }

        /* RESET STYLES */
        img {
            border: 0;
            height: auto;
            line-height: 100%;
            outline: none;
            text-decoration: none;
        }

        table {
            border-collapse: collapse !important;
        }

        body {
            height: 100% !important;
            margin: 0 !important;
            padding: 0 !important;
            width: 100% !important;
        }

        /* iOS BLUE LINKS */
        a[x-apple-data-detectors] {
            color: inherit !important;
            text-decoration: none !important;
            font-size: inherit !important;
            font-family: inherit !important;
            font-weight: inherit !important;
            line-height: inherit !important;
        }

        /* MOBILE STYLES */
        @media screen and (max-width:600px) {
            h1 {
                font-size: 32px !important;
                line-height: 32px !important;
            }
        }

        /* ANDROID CENTER FIX */
        div[style*="margin: 16px 0;"] {
            margin: 0 !important;
        }
    </style>
</head>

<body style="background-color: #f4f4f4; margin: 0 !important; padding: 0 !important;">
    <!-- HIDDEN PREHEADER TEXT -->
    <div style="display: none; font-size: 1px; color: #fefefe; line-height: 1px; font-family: 'Lato', Helvetica, Arial, sans-serif; max-height: 0px; max-width: 0px; opacity: 0; overflow: hidden;"> We're thrilled to have you here! Get ready to dive into your new account. </div>
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <!-- LOGO -->
        <tr>
            <td bgcolor="#FFA73B" align="center">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                    <tr>
                        <td align="center" valign="top" style="padding: 40px 10px 40px 10px;"> </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td bgcolor="#FFA73B" align="center" style="padding: 0px 10px 0px 10px;">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                    <tr>
                        <td bgcolor="#ffffff" align="center" valign="top" style="padding: 40px 20px 20px 20px; border-radius: 4px 4px 0px 0px; color: #111111; font-family: 'Lato', Helvetica, Arial, sans-serif; font-size: 48px; font-weight: 400; letter-spacing: 4px; line-height: 48px;">
                            <h1 style="font-size: 48px; font-weight: 400; margin: 2;">Welcome!</h1> <img src="https://herody.in/assets/main/images/Viti.png" width="125" height="120" style="display: block; border: 0px;" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td bgcolor="#f4f4f4" align="center" style="padding: 0px 10px 0px 10px;">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                    <tr>
                        <td bgcolor="#ffffff" align="left" style="padding: 20px 30px 40px 30px; color: #666666; font-family: 'Lato', Helvetica, Arial, sans-serif; font-size: 18px; font-weight: 400; line-height: 25px;">
                            <p style="margin: 0;">We're excited to have you get started. First, you need to confirm your account. Just press the button below.</p>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#ffffff" align="left">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td bgcolor="#ffffff" align="center" style="padding: 20px 30px 60px 30px;">
                                        <table border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td align="center" style="border-radius: 3px;" bgcolor="#FFA73B"><a href="https://herody.in/user/email-verified/''' +
            (data["response"]["user"]["id"]).toString() +
            '''" target="_blank" style="font-size: 20px; font-family: Helvetica, Arial, sans-serif; color: #ffffff; text-decoration: none; color: #ffffff; text-decoration: none; padding: 15px 25px; border-radius: 2px; border: 1px solid #FFA73B; display: inline-block;">Confirm Account</a></td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr> <!-- COPY -->
                    
                
                    <tr>
                        <td bgcolor="#ffffff" align="left" style="padding: 0px 30px 20px 30px; color: #666666; font-family: 'Lato', Helvetica, Arial, sans-serif; font-size: 18px; font-weight: 400; line-height: 25px;">
                            <p style="margin: 0;">If you have any questions, just reply to help@herody.in — we're always happy to help out.</p>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#ffffff" align="left" style="padding: 0px 30px 40px 30px; border-radius: 0px 0px 4px 4px; color: #666666; font-family: 'Lato', Helvetica, Arial, sans-serif; font-size: 18px; font-weight: 400; line-height: 25px;">
                            <p style="margin: 0;">Cheers,<br>Herody Team</p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td bgcolor="#f4f4f4" align="center" style="padding: 30px 10px 0px 10px;">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                    <tr>
                        <td bgcolor="#FFECD1" align="center" style="padding: 30px 30px 30px 30px; border-radius: 4px 4px 4px 4px; color: #666666; font-family: 'Lato', Helvetica, Arial, sans-serif; font-size: 18px; font-weight: 400; line-height: 25px;">
                            <h2 style="font-size: 20px; font-weight: 400; color: #111111; margin: 0;">Need more help?</h2>
                            <p style="margin: 0;"><a href="mailto:help@herody.in" target="_blank" style="color: #FFA73B;">We&rsquo;re here to help you out</a></p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td bgcolor="#f4f4f4" align="center" style="padding: 0px 10px 0px 10px;">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 600px;">
                    <tr>
                        <td bgcolor="#f4f4f4" align="left" style="padding: 0px 30px 30px 30px; color: #666666; font-family: 'Lato', Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 400; line-height: 18px;"> <br>
                            <p style="margin: 0;">If these emails get annoying, please feel free to <a href="#" target="_blank" style="color: #111111; font-weight: 700;">unsubscribe</a>.</p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>

</html>
                            </body>
                        </html>''';
      print(message);
      //var connection = PersistentConnection(smtpServer);
      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' + sendReport.toString());
      } on MailerException catch (e) {
        print('Message not sent.');
      }
      //await connection.close();
      //return 1;
    }
  }

  Future<int> loginCallback() async {
    var url = g.preurl + 'user/login';
    Response response = await post(url, body: {"phone": _umobile});
    data = json.decode(response.body);

    return (1);
  }

  Future<int> signup() async {
    var url = g.preurl + 'user/register';
    final response = (_rcode == "")
        ? await post(url, body: {
            "name": _uname,
            "phone": _umobile,
            "email": _email,
          })
        : await post(url, body: {
            "name": _uname,
            "phone": _umobile,
            "email": _email,
            "ref_by": _rcode
          });
    data = json.decode(response.body);
    return (1);
  }

  Future<int> sendotp() async {
    var rng = new Random();
    otp = rng.nextInt(9000) + 1000;
    setState(() {
      otppage = true;
    });
    /* Response res = await post("https://api.textlocal.in/send/?", body: {
      "apikey": "Lo0VLCnbv40-T9s0YjiZ5fHfT64Uqsuu1z73feaATR",
      "numbers": "+917061417968",
      "message": "The OTP to verify your mobile number at Herody is: " +
          otp.toString(),
      "sender": "TXTLCL"
    });*/

    return (1);
  }

  int noofclick = 0;
  int noofresendotpclick = 0;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      setState(() {
        otppage = true;
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: "+91$_umobile", // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            this.verificationId = verId;
          },
          codeSent: smsOTPSent,
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) async {
            // String data = phoneAuthCredential.toString();
            //verifyPhone();
            print(phoneAuthCredential);
            smsOTPSent(verificationId);
            //await prefs.setBool('isLoggedIn', true);
            //await prefs.setString('userid', "2");
            //widget.loggedin();
            /* if (data.split(":")[2].split(",")[0] == 'true') {
              Fluttertoast.showToast(
                  msg:
                      "This Number is already in use \t \n \n Try with other number",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.blue.shade200,
                  textColor: Colors.red.shade900,
                  fontSize: 16.0);
            }*/
          },
          verificationFailed: (AuthException exception) {
            print('${exception.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        otppage = true;
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  _validateOtp(String value) async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
          verificationId: verificationId, smsCode: value);
      final AuthResult user = await _auth.signInWithCredential(credential);
      final FirebaseUser currentUser = await _auth.currentUser();
      if (user.user.uid == currentUser.uid) {
        Fluttertoast.showToast(
            msg: "Code verified Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue.shade200,
            textColor: Colors.red.shade900,
            fontSize: 16.0);

        setState(() {
          // otppage = false;
          // _isLoginForm = true;
          // _isLoading = true;
        });
        try {
          await loginCallback();
          if (data != null) {
            print(data);
            print('Signed in: ' + data["response"]["code"]);
            switch (data["response"]["code"]) {
              case "SUCCESS":
                setState(() {
                  _showCircularProgress();
                  _isLoading = true;
                });
                if (data["response"]["user"]["email_verified_at"] == null) {
                  //  if (initialLink != null) {
                  String url = g.preurl + "user/email-verified";
                  Response response = await post(url,
                      body: {"id": data["response"]["user"]["id"].toString()});
                  var data1 = json.decode(response.body);
                  g.uid = (data["response"]["user"]["id"]).toString();
                  g.data = (data["response"]["user"]);
                  await prefs.setBool('isLoggedIn', true);
                  await prefs.setString('userid', g.uid);
                  widget.loggedin();
                } else {
                  g.uid = (data["response"]["user"]["id"]).toString();
                  g.data = (data["response"]["user"]);
                  await prefs.setBool('isLoggedIn', true);
                  await prefs.setString('userid', g.uid);
                  widget.loggedin();
                }
                break;
              case "PHONE NUMBER NOT CORRECT":
                setState(() {
                  _isLoginForm = true;
                  otppage = false;
                  _isLoading = true;
                  _errorMessage = "Account does not exist \n Please Sign Up";
                  _isLoading = false;
                });
                break;
              default:
                setState(() {
                  _errorMessage = "PHONE NUMBER NOT CORRECT";
                });
                break;
            }
          }
          noofclick = 0;
        } catch (e) {
          print(e);
        }
      }
    } catch (e) {
      handleError(e);
      setState(() {
        otppage = true;
        _isLoginForm = false;
        _isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "incorrect OTP \n Try again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red.shade200,
          textColor: Colors.blue.shade900,
          fontSize: 16.0);
    }
    return "0";
  }

  @override
  void initState() {
    try {
      _googleSignIn.disconnect();
      _errorMessage = "";
      _isLoading = false;
      _isLoginForm = true;
      _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
        print("Goggle success bitches.................");
        print(account.email);
        print(account.displayName);
        //print(account.)
        setState(() {
          _email = account.email;
          _umobile = "null";
          _uname = account.displayName == null ? "USER" : account.displayName;
        });
        tcvalidateAndSubmit();
      });
    } catch (e) {
      print(e);
    }
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    setState(() {
      _isLoading = true;
    });
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
      _isTruecallerLogin = false;
      _isLoading = false;
    });
  }

  Future<int> getotp() async {
    String url = g.preurl + "user/verifyMobile";
    Response response = await post(url,
        body: {"uid": data["response"]["user"]["id"].toString()});
    var data1 = jsonDecode(response.body);
    return (1);
  }

  void sendresetlink() async {
    if (validateAndSave()) {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
        onclick = true;
      });
      String url = g.preurl + "user/forgot-password";
      Response response = await post(url, body: {"email": _email});
      var data = jsonDecode(response.body);
      setState(() {
        _errorMessage = "Password reset link sent to your mail-id";
        _isLoading = false;
        onclick = false;
      });
    }
  }

  Widget _showCircularProgress() {
    return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                  (_isLoading) ? Colors.indigo[900] : Colors.transparent)),
          //(email)?Text("Sending Verification Email",style: TextStyle(color: Colors.indigo[900]),):Container(),
        ]));
  }

  /*int _showVerifyEmailSentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Account created ✓",
            style: TextStyle(color: Colors.indigo[700]),
          ),
          content: new Text(
              "Link to verify your Mail-id will be sent to your email in a few minutes. Verify it before logging in.\nIf email undelivered, login with details provided into App to resend email."),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Okay"),
              onPressed: () {
                verifyPhone();
                Navigator.of(context).pop();

                resetForm();

                setState(() {
                  _errorMessage = "";
                  _isLoginForm = true;
                });
              },
            ),
          ],
        );
      },
    );
    return (1);
  }*/

  @override
  Widget build(BuildContext context) {
    initUniLinks();
    return new Scaffold(
        backgroundColor: Colors.white,
        body: AbsorbPointer(
            absorbing: _isLoading,
            child: Stack(
              children: <Widget>[
                _showForm(),
                _showCircularProgress(),
              ],
            )));
  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(0.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            physics: AlwaysScrollableScrollPhysics(),
            shrinkWrap: false,
            children: <Widget>[
              showLogo(),
              name(),
              SizedBox(
                height: 20,
              ),
              if (!_isLoginForm && !otppage && !_changepassword)
                showNameInput(),
              if (_isLoginForm && !otppage && !_changepassword)
                showNumberInput(),
              if (!otppage && !_isLoginForm) showEmailInput(),
              // if (!otppage && !_changepassword) showPasswordInput(),
              if (!_isLoginForm && !otppage && !_changepassword)
                showNumberInput(),
              if (!_isLoginForm && !otppage && !_changepassword)
                showCodeInput(),
              if (otppage) verifyp(),
              //if (_isLoginForm && !otppage && !_changepassword)
              //  showforgotpasswordButton(),
              showErrorMessage(),
              // if (_isLoginForm && !otppage && !_changepassword && email)
              // showResendEmailButton(),
              SizedBox(
                height: 10,
              ),
              showPrimaryButton(),
              SizedBox(
                height: 20,
              ),
              if (!otppage) showSecondaryButton(),
              if (!otppage && !_changepassword)
                Text("━━━━━━━━━━  or  ━━━━━━━━━━",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue[800],
                    )),
              if (!otppage && !_changepassword) googlebutton(),
              if (!otppage && !_changepassword) truecallerbutton(),
              if (!_isLoginForm && !otppage) terms(),
              bottomborder(),
            ],
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage != null && _errorMessage.length > 0) {
      return new Container(
          alignment: Alignment.center,
          child: new Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: new Text(
                _errorMessage,
                style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )));
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget name() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              (otppage)
                  ? "Verify Your Mobile Number"
                  : !_changepassword
                      ? _isLoginForm
                          ? "Sign In"
                          : "Sign Up"
                      : "Reset Password",
              style: new TextStyle(
                  color: Colors.indigo[900],
                  fontWeight: FontWeight.normal,
                  fontSize: 35),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.0, 30, 16.0, 0.0),
        child: Image.asset(
          'assets/logo&name.png',
          height: 90,
        ),
      ),
    );
  }

  Widget verifyp() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(" "),
          Text(
            "Enter the OTP sent to " + "$_umobile",
            style: TextStyle(fontSize: 19),
          ),
          Text(" "),
          Container(
            padding: EdgeInsets.fromLTRB(60, 10, 60, 10),
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: PinInputTextFormField(
                  decoration: UnderlineDecoration(
                      textStyle: TextStyle(fontSize: 20, color: Colors.black),
                      colorBuilder:
                          PinListenColorBuilder(Colors.blue, Colors.pink)),
                  pinLength: 6,
                  validator: (value) {
                    try {
                      _validateOtp(value);
                      setState(() {
                        _isLoading = true;
                      });
                      //  otpmethod(value);
                    } catch (e) {
                      print(e);
                    }
                    return "";
                  }
                  /*(value.trim().isEmpty || value.trim() != verificationId)
                        ? "OTP incorrect"
                        : Fluttertoast.showToast(
                            msg: "Code verified Successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.blue.shade200,
                            textColor: Colors.red.shade900,
                            fontSize: 16.0),*/
                  ),
            ),
          ),
          FlatButton(
            onPressed: () {
              verifyPhone();
              noofresendotpclick = noofresendotpclick + 1;
              print(noofresendotpclick);
              if (noofclick == 6) {
                Fluttertoast.showToast(
                    msg: "Maximum resend password attempts reached",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.blue.shade700,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            },
            child: noofresendotpclick != 6
                ? Text(
                    "Resend OTP",
                    style: TextStyle(color: Colors.red),
                  )
                : Text(""),
          )
        ],
      ),
    );
  }

  /*void otpmethod(value) {
    FlutterOtp otpObj = FlutterOtp();
    otpObj.sendOtp('Herody', '+91'); //Pass phone number as String
    otpObj.generateOtp(1000);
    bool isCorrectOTP = otpObj.resultChecker(int.parse(value));
    if (isCorrectOTP) {
      print('Success');
    } else {
      print('Failure');
    }
  }*/

  Widget showNameInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15.0),
      child: Card(
        elevation: 5,
        color: Colors.blue[50],
        child: new TextFormField(
          onTap: () {
            setState(() {
              _errorMessage = "";
            });
          },
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Full Name',
              icon: new Icon(
                Icons.account_circle,
                color: Colors.grey,
              )),
          validator: (value) =>
              value.trim().isEmpty ? 'Fullname can\'t be empty' : null,
          onSaved: (value) => _uname = value.trim(),
        ),
      ),
    );
  }

  Widget showNumberInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15.0),
      child: Card(
        elevation: 5,
        color: Colors.blue[50],
        child: new TextFormField(
          onTap: () {
            setState(() {
              _errorMessage = "";
            });
          },
          maxLines: 1,
          keyboardType: TextInputType.phone,
          autofocus: false,
          decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Mobile Number',
              icon: new Icon(
                Icons.stay_current_portrait,
                color: Colors.grey,
              )),
          validator: (value) => value.trim().isEmpty
              ? 'Mobile Number can\'t be empty'
              : value.trim().length != 10
                  ? "Enter a valid 10-digit Mobile Number"
                  : null,
          onSaved: (value) => _umobile = value.trim(),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15.0),
      child: Card(
        elevation: 5,
        color: Colors.blue[50],
        child: new TextFormField(
          onTap: () {
            setState(() {
              _errorMessage = "";
            });
          },
          maxLines: 1,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Email',
              icon: new Icon(
                Icons.mail,
                color: Colors.grey,
              )),
          validator: (value) =>
              value.trim().isEmpty ? 'Email can\'t be empty' : null,
          onSaved: (value) => _email = value.trim(),
        ),
      ),
    );
  }

  /* Widget showPasswordInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15.0),
      child: Card(
        elevation: 5,
        color: Colors.blue[50],
        child: new TextFormField(
          onTap: () {
            setState(() {
              _errorMessage = "";
            });
          },
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Password',
              icon: new Icon(
                Icons.lock_outline,
                color: Colors.grey,
              )),
          validator: (value) =>
              value.isEmpty ? 'Password can\'t be empty' : null,
          onSaved: (value) => _password = value.trim(),
        ),
      ),
    );
  }

  Widget showCPasswordInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15.0),
      child: Card(
        elevation: 5,
        color: Colors.blue[50],
        child: new TextFormField(
          onTap: () {
            setState(() {
              _errorMessage = "";
            });
          },
          maxLines: 1,
          obscureText: true,
          autofocus: false,
          decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Re-enter Password',
              icon: new Icon(
                Icons.lock,
                color: Colors.grey,
              )),
          validator: (value) =>
              value.isEmpty ? 'Confirmation Password can\'t be empty' : null,
          onSaved: (value) => _cpassword = value.trim(),
        ),
      ),
    );
  }*/

  Widget showCodeInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 15.0, 16.0, 15.0),
      child: Card(
        elevation: 5,
        color: Colors.blue[50],
        child: new TextFormField(
          onTap: () {
            setState(() {
              _errorMessage = "";
            });
          },
          maxLines: 1,
          keyboardType: TextInputType.text,
          autofocus: false,
          decoration: new InputDecoration(
              border: InputBorder.none,
              hintText: 'Referral Code (optional)',
              icon: new Icon(
                Icons.receipt,
                color: Colors.grey,
              )),
          onSaved: (value) => _rcode = value.trim(),
        ),
      ),
    );
  }

  Widget showforgotpasswordButton() {
    return new Container(
      alignment: Alignment.topRight,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: FlatButton(
        child: new Text(
          _isLoginForm ? 'Forgot Password?' : null,
          style: new TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.w300, color: Colors.pink),
          textAlign: TextAlign.right,
        ),
        onPressed: () {
          print(g.uid);
          setState(() {
            _errorMessage = "";
            _changepassword = !_changepassword;
          });
        },
      ),
    );
  }

  Widget showResendEmailButton() {
    return new Container(
      alignment: Alignment.center,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      child: FlatButton(
        child: new Text(
          _isLoginForm ? 'Resend Email?' : null,
          style: new TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Colors.indigo[400]),
          textAlign: TextAlign.right,
        ),
        onPressed: () async {
          setState(() {
            _errorMessage = "Sending Verification Email...";
            _isLoading = true;
          });

          sendEmail();
          setState(() {
            _errorMessage = "Verification Email sent to " + _email;
            _isLoading = false;
            email = false;
          });
        },
      ),
    );
  }

  Widget showSecondaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(16.0, 22, 16.0, 10.0),
        child: SizedBox(
            height: 50.0,
            child: new RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: !onclick ? Color(0xff045de9) : Colors.pink,
              child: new Text(
                  (_changepassword)
                      ? "Sign in"
                      : _isLoginForm
                          ? 'Create an account'
                          : 'Have an account? Sign in',
                  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                if (_changepassword) {
                  setState(() {
                    _errorMessage = "";
                    _changepassword = !_changepassword;
                  });
                } else {
                  setState(() {
                    _errorMessage = "";
                    toggleFormMode();
                  });
                }
              },
            )
            /* new Text(
          (_changepassword)
              ? "Sign in"
              : _isLoginForm
                  ? 'Create an account'
                  : 'Have an account? Sign in',
          style: new TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w300,
              color: Color(0xff045de9))),
      onPressed: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        if (_changepassword) {
          setState(() {
            _errorMessage = "";
            _changepassword = !_changepassword;
          });
        } else {
          setState(() {
            _errorMessage = "";
            toggleFormMode();
          });
        }
      },
    );*/
            ));
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(16.0, 22, 16.0, 0.0),
        child: SizedBox(
          height: 50.0,
          child: new RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(10.0)),
              color: !onclick ? Color(0xff045de9) : Colors.pink,
              child: new Text(
                  (_changepassword)
                      ? "Send Password Reset Link"
                      : (otppage)
                          ? 'Submit'
                          : _isLoginForm
                              ? 'Login'
                              : 'Create account',
                  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: () async {
                //sendEmail();
                //await initUniLinks();
                // sendEmail();
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                setState(() {
                  _errorMessage = "";
                });
                (otppage)
                    ? otpvalidateAndSubmit()
                    : (_changepassword)
                        ? sendresetlink()
                        : validateAndSubmit();
              }),
        ));
  }

  Widget bottomborder() {
    return new Container(
        padding: EdgeInsets.only(
            top: (otppage)
                ? 170
                : (_changepassword)
                    ? 230
                    : (_isLoginForm)
                        ? 170
                        : 0),
        alignment: Alignment.bottomCenter,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            //Text("or",style: TextStyle(fontSize: 15,color: Colors.grey[800],fontWeight: FontWeight.bold)),
            Image.asset("assets/appbar.png")
          ],
        ));
  }

  Widget truecallerbutton() {
    return new Container(
      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: new RaisedButton(
          elevation: 0,
          shape: new RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue[600]),
            borderRadius: new BorderRadius.circular(20),
          ),
          color: Colors.white,
          child: new Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/truecaller.png"),
                  height: 20,
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      _isLoginForm
                          ? "Sign-in with Truecaller"
                          : "Sign-up with Truecaller",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                    )),
              ],
            ),
          ),
          onPressed: () async {
            setState(() {
              _errorMessage = "";
              _isLoading = true;
            });
            Future<String> result = caller.initializeSDK(
              sdkOptions: FlutterTruecallerScope.SDK_OPTION_WITHOUT_OTP,
              footerType: FlutterTruecallerScope.FOOTER_TYPE_LATER,
              consentTitleOptions:
                  FlutterTruecallerScope.SDK_CONSENT_TITLE_LOG_IN,
              consentMode: FlutterTruecallerScope.CONSENT_MODE_POPUP,
            );
            bool isUsable = await caller.isUsable;
            setState(() {
              _isLoading = false;
            });
            if (isUsable) {
              await caller.getProfile();
              FlutterTruecaller.trueProfile.listen((event) {
                setState(() {
                  _email = event.email.toString();
                  _uname = event.firstName + event.lastName;
                  _umobile = event.phoneNumber.toString();
                });
                if (_umobile.length != 0) tcvalidateAndSubmit();
              });
            } else {
              setState(() {
                _errorMessage =
                    "Install Truecaller app & Register in it to continue with this option";
              });
            }
            //
          }),
    );
  }

  Widget googlebutton() {
    return new Container(
      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: new RaisedButton(
          elevation: 0,
          shape: new RoundedRectangleBorder(
            side: BorderSide(color: Colors.blue[600]),
            borderRadius: new BorderRadius.circular(20),
          ),
          color: Colors.white,
          child: new Padding(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/google.png"),
                  height: 20,
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      _isLoginForm
                          ? "Sign-in with Google"
                          : "Sign-up with Google",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                    )),
              ],
            ),
          ),
          onPressed: () async {
            setState(() {
              _errorMessage = "";
              _isLoading = true;
            });
            try {
              await _googleSignIn.signIn();
              print(_googleSignIn.currentUser.email);
            } catch (error) {
              print(error);
            }
            setState(() {
              _isLoading = false;
            });
            //
          }),
    );
  }

  Widget terms() {
    return Container(
      padding: EdgeInsets.fromLTRB(50, 0, 50, 30),
      alignment: Alignment.center,
      child: Text(
        "By creating an account you agree with our Terms & Conditions",
        style: TextStyle(color: Colors.grey),
        textAlign: TextAlign.center,
      ),
    );
  }
}
