import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:be_app_mobile/autorization/service/auth_service.dart';
import 'package:be_app_mobile/models/app_options.dart';
import 'package:be_app_mobile/models/general.dart';
import 'package:be_app_mobile/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../autorization/pages/login_page.dart';
import '../../../helpers/font_helper.dart';
import '../../../models/be_app.dart';
import '../../../service/api_service.dart';
import 'delete_account.dart';
import 'edit_profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key, required this.general, required this.options}) : super(key: key);
  final General general;
  final AppOptions options;
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AuthService service = AuthService();
  bool isPushNotificationsEnabled = true;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getBoolValue(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
          isPushNotificationsEnabled = snapshot.data ?? true;
          return mainWidget();
        } else {
          return Stack(
            children: [
              mainWidget(),
              Center(
                child: Loading(
                  general: widget.general,
                ),
              )
            ],
          );
        }
      },
    );
  }

  Widget mainWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 0),
      child: ListView(
        children: [
          Text(
            "Settings",
            style: getFontStyle(30, Theme.of(context).primaryColor, FontWeight.bold, widget.general),
          ),
          const SizedBox(
            height: 15,
          ),
          SettingsGroup(
            settingsGroupTitle: "Settings",
            settingsGroupTitleStyle: getFontStyle(25, Colors.black, FontWeight.bold, widget.general),
            items: [
              SettingsItem(
                onTap: () {},
                icons: FontAwesomeIcons.bell,
                iconStyle: IconStyle(),
                title: "Push notifications",
                titleStyle: const TextStyle(color: Colors.black),
                subtitle: "Enable push notifications",
                trailing: Switch.adaptive(
                  value: isPushNotificationsEnabled,
                  inactiveTrackColor: Colors.grey,
                  activeColor: Colors.green,
                  onChanged: (value) async {
                    isPushNotificationsEnabled = value;
                    await saveBoolValue(value);
                    if (isPushNotificationsEnabled) {
                      await FirebaseMessaging.instance.subscribeToTopic("messaging");
                    } else {
                      await FirebaseMessaging.instance.unsubscribeFromTopic("messaging");
                    }

                    await APIService().updateUserSettings();
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          // You can add a settings title
          SettingsGroup(
            settingsGroupTitle: "Account",
            settingsGroupTitleStyle: getFontStyle(25, Colors.black, FontWeight.bold, widget.general),
            items: [
              SettingsItem(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        general: widget.general,
                      ),
                    ),
                  );
                },
                icons: Icons.edit,
                iconStyle: IconStyle(
                  backgroundColor: Colors.orangeAccent,
                ),
                title: "Edit account",
                titleStyle: const TextStyle(color: Colors.black),
                subtitle: "Tap to change your profile data",
              ),
              SettingsItem(
                onTap: () {
                  signOutAction();
                },
                icons: Icons.exit_to_app_rounded,
                iconStyle: IconStyle(
                  backgroundColor: Colors.black26,
                ),
                title: "Sign out",
                titleStyle: const TextStyle(color: Colors.black),
                subtitle: "Sign out from your account",
              ),
              SettingsItem(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeleteAccount(
                        general: widget.general,
                        options: widget.options,
                      ),
                    ),
                  );
                },
                icons: Icons.delete,
                iconStyle: IconStyle(
                  backgroundColor: Colors.redAccent,
                ),
                title: "Delete account",
                subtitle: "Delete permanently account",
                titleStyle: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  signOutAction() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage(model: BeAppModel(options: widget.options, general: widget.general))),
        (Route<dynamic> route) => false);
  }

  saveBoolValue(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('pushes', value);
  }

  Future<bool> getBoolValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('pushes') ?? true;
  }
}
