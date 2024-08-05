
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/my_button.dart';
import '../components/my_text_field_white.dart';
import '../components/my_visible_indicator.dart';
import '../utils/constants.dart';
import '../utils/my_logo_alert.dart';
import '../utils/shared_preference_data.dart';
import 'event_list.dart';
import 'forget_password.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  TextEditingController mobileTEC = TextEditingController();
  TextEditingController passTEC = TextEditingController();

  @override
  void initState() {
    getUserPrefData();
    super.initState();
  }

  bool checkFields() {
    if (mobileTEC.text == '') {
      return false;
    } else if (passTEC.text == '') {
      return false;
    }
    return true;
  }

  void procLoginSuccess() {
    Navigator.pop(context);
    Navigator.pushNamed(context, SelectEvent.id);
  }

  void _loginUser() async {
    var dio = Dio();
    dio.options.baseUrl = kAPIBaseURL;
    dio.options.connectTimeout = const Duration(milliseconds: 5000);
    dio.options.receiveTimeout = const Duration(milliseconds: 5000);
    dio.interceptors.add(LogInterceptor(requestBody: false));
    dio.options.headers["Authorization"] = "Bearer $glbAuthToken";

    String url = 'login_volunteer.php';

    FormData formData = FormData.fromMap(
      {
        "mobile": mobileTEC.text,
        "password": passTEC.text,
        "token": "1",
      },
    );
    await dio.post(url, data: formData).then((value) {
      setState(() {
        isLoading = false;
        if (value.data["status"]) {
          glbName = value.data["data"][0]["name"];
          glbID = value.data["data"][0]["id"];

          glbMobile = mobileTEC.text;
          glbPassword = passTEC.text;
          SharedPrefData(
            userMobile: mobileTEC.text,
            userPWD: passTEC.text,
          ).setUserData();
          procLoginSuccess();
        } else {
          setState(() {
            isLoading = false;
            myLogoAlert(
                message: value.data["message"],
                context: context,
                navigateEnabled: false,
                route: '');
          });
        }
      });
    });
  }

  getUserPrefData() async {
    final pref = await SharedPreferences.getInstance();
    setState(() {
      mobileTEC.text = pref.getString('userMobile')!;
      passTEC.text = pref.getString('userPWD')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorWhite,
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: ((MediaQuery.sizeOf(context).height) / 3) - 50,
                ),
                myVisibleIndicator(isVisible: isLoading),
                const Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 100,

                    child: Image(
                      image: AssetImage('images/IIFLOGO.jpeg'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                MyTextFieldWhite(
                    displayIcon: const Icon(
                      Icons.phone,
                      color: Colors.blue,
                    ),
                    isPassword: false,
                    controller: mobileTEC,
                    isNumber: true,
                    isLast: false,
                    displayLabel: 'Enter Mobile',
                    onChanged: (val) {
                      setState(() {
                        mobileTEC.text = val;
                      });
                    }),
                MyTextFieldWhite(
                    displayIcon: const Icon(
                      Icons.key,
                      color: Colors.blue,
                    ),
                    isPassword: true,
                    controller: passTEC,
                    isNumber: false,
                    isLast: true,
                    displayLabel: 'Enter Password',
                    onChanged: (val) {
                      setState(() {
                        passTEC.text = val;
                      });
                    }),
                MyButton(
                    title: 'Login',
                    color: kColorGreen,
                    onPressed: () {
                      setState(() {
                        bool check = checkFields();
                        if (check) {
                          isLoading = true;
                          _loginUser();
                        } else {
                          myLogoAlert(
                              context: context,
                              message: 'Username / Password cannot be blank',
                              navigateEnabled: false,
                              route: '');
                        }
                      });
                    },
                    width: 100),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: GestureDetector(
                    child: const Text(
                      'Forgot Password',
                      style: TextStyle(color: Colors.blue, fontSize: 13),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, ForgotPassword.id);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
