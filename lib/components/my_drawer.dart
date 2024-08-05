import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Pages/login_screen.dart';
import '../utils/constants.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Center(
            child: UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      kLogoBlue,
                      kColorBase,
                    ],
                  ),
                  // color: Colors.green[600],
                ),
                accountName: Text(glbName,
                    style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                accountEmail: Text(
                  glbMobile,
                  style: const TextStyle(
                    fontSize: 11.0,
                    color: Colors.white,
                  ),
                ),
                currentAccountPicture: Image.asset('images/logo.png')),
          ),

          DrawerTile(
            title: 'Exit',
            leading: const Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, LoginScreen.id);
            },
          ),
        ],
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  const DrawerTile(
      {super.key,
      required this.title,
      required this.leading,
      required this.onPressed});

  final String title;
  final Icon leading;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.blueGrey,
        ),
      ),
      leading: leading,
      onTap: () {
        return onPressed();
      },
    );
  }
}
