import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components/my_button.dart';
import '../components/my_text_field_white.dart';
import '../components/my_visible_indicator.dart';
import '../models/forgot_password_model.dart';
import '../utils/constants.dart';
import '../utils/my_logo_alert.dart';
import 'login_screen.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});
  static const String id = 'forgot_password';

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var fireApp;
  bool isLoading = false;
  double scrWidth = 0;
  String myPwd = '';
  TextEditingController uMobile = TextEditingController();

  @override
  void initState() {
    super.initState();
    fireApp = Firebase.initializeApp();
  }

  void showPwd() async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds:5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: false));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";
    String url = 'forget_password_volunteer.php';

    FormData formData = FormData.fromMap({"mobile": uMobile.text});
    await dio.post(url, data: formData).then((value) {
      GeneralModel generalResponse = GeneralModel.fromJson(value.data);
      isLoading = false;
      if (generalResponse.status) {
        myPwd = generalResponse.message;
        _changePWD(context);
      } else {
        myLogoAlert(
            context: context,
            message: generalResponse.message,
            navigateEnabled: false,
            route: '');
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    scrWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 150.0),
                  child: CircleAvatar(
                    backgroundImage: AssetImage("images/IIFLOGO.jpeg"),
                    backgroundColor: Colors.white,
                    radius: 50,
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                const Text(
                  'FORGOT PASSWORD',
                  style: kHeadingStyle,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
                  child: Text(
                    'We will first validate your number',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey),
                  ),
                ),
                MyTextFieldWhite(
                  displayIcon: const Icon(
                    FontAwesomeIcons.phone,
                    color: Colors.blue,
                  ),
                  isPassword: false,
                  controller: uMobile,
                  isNumber: true,
                  isLast: true,
                  displayLabel: 'Enter Phone',
                  onChanged: (value) {
                    uMobile.text = value;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    MyButton(
                        title: 'Cancel',
                        color: Colors.red.shade600,
                        onPressed: () {
                          String rt = LoginScreen.id;
                          Navigator.pop(context);
                          Navigator.pushNamed(context, rt);
                        },
                        width: 130),
                    MyButton(
                        title: 'Submit',
                        color: kColorGreen,
                        onPressed: () {
                          setState(() {
                            if (uMobile.text == '') {
                              myLogoAlert(
                                  context: context,
                                  navigateEnabled: false,
                                  route: '',
                                  message: 'Please enter a valid number');
                            } else {
                              isLoading = true;
                              _validateNumber(uMobile.text, context);
                            }
                          });
                        },
                        width: 130),
                  ],
                ),
                myVisibleIndicator(isVisible: isLoading),

              ],
            )
          ],
        ),
      ),
    );
  }

  Future _validateNumber(String phone, BuildContext context) async {
    final FirebaseAuth fbAuth = FirebaseAuth.instance;

    phone = '+91$phone';

    fbAuth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (AuthCredential authCred) {
          fbAuth.signInWithCredential(authCred).then((UserCredential result) {
            showPwd();
          }).catchError((e) {
            setState(() {
              isLoading = false;
              myLogoAlert(
                  context: context,
                  navigateEnabled: false,
                  route: '',
                  message: e.toString());
            });
          });
        },
        verificationFailed: (FirebaseAuthException ex) {
          setState(() {
            isLoading = false;
            myLogoAlert(
                context: context,
                navigateEnabled: false,
                route: '',
                message: ex.toString());
          });
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          final code = TextEditingController();

          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Column(
                  children: [
                    Center(child: Text("Enter Verification Code")),
                    Padding(
                      padding: EdgeInsets.only(top: 4.0, left: 10.0),
                      child: Text(
                        '*Wait for 5 seconds to auto submit',
                        style: kDialogStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        '*OTP expires in 60 seconds',
                        style: kDialogStyle,
                      ),
                    ),
                  ],
                ),
                content: MyTextFieldWhite(
                  displayIcon: const Icon(
                    Icons.password,
                    color: Colors.blue,
                  ),
                  isPassword: false,
                  controller: code,
                  isNumber: true,
                  displayLabel: 'Enter OTP',
                  isLast: true,
                  onChanged: (val) {
                    code.text = val;
                  },
                ),
                actions: [
                  MyButton(
                      title: 'Submit',
                      color: kColorGreen,
                      onPressed: () {
                        if (code.text == '') {
                          //do nothing
                        } else {
                          var cred = PhoneAuthProvider.credential(
                              verificationId: verificationId,
                              smsCode: code.text);
                          fbAuth
                              .signInWithCredential(cred)
                              .then((UserCredential result) {
                            Navigator.pop(context);
                            showPwd();
                          }).catchError((e) {
                            Navigator.pop(context);
                            setState(() {
                              isLoading = false;
                              myLogoAlert(
                                  context: context,
                                  navigateEnabled: false,
                                  route: '',
                                  message: e.toString());
                            });
                          });
                        }
                      },
                      width: 100
                  ),
                ],
              ),

          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        });
  }

  void _changePWD(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(0.8),
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.padding),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: remarkBox(context),
          );
        });
  }

  remarkBox(context) {
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: GestureDetector(
            child: Container(
              width: scrWidth,
              padding: const EdgeInsets.only(
                  left: Constants.padding,
                  top: 10,
                  right: Constants.padding,
                  bottom: Constants.padding + 20),
              margin: const EdgeInsets.only(top: Constants.avatarRadius),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Constants.padding),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 10),
                        blurRadius: 10),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        FontAwesomeIcons.copy,
                        color: Colors.transparent,
                        size: 20,
                      ),
                      Text(
                        'Your Password',
                        style: kListNameStyle,
                      ),
                      Icon(
                        FontAwesomeIcons.copy,
                        color: Colors.blueGrey,
                        size: 20,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    myPwd,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Copy to clipboard',
                    style: TextStyle(fontSize: 10, color: Colors.blueGrey),
                  )
                ],
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Clipboard.setData(ClipboardData(text: myPwd)).then((_) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Password Copied to Clipboard")));
              });
            },
          ),
        ),
      ],
    );
  }
}
