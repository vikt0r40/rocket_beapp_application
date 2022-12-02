import 'package:be_app_mobile/models/app_options.dart';
import 'package:be_app_mobile/models/be_app.dart';
import 'package:be_app_mobile/models/general.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../autorization/components/main_button.dart';
import '../../../autorization/helpers/font_size.dart';
import '../../../autorization/pages/login_page.dart';
import '../../../helpers/font_helper.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key, required this.general, required this.options}) : super(key: key);
  final General general;
  final AppOptions options;
  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.general.getApplicationColor(),
      appBar: AppBar(
        backgroundColor: widget.general.getTopNavigationColor(),
        elevation: 0,
        iconTheme: IconThemeData(
          color: widget.general.getTopNavigationItemColor(), //change your color here
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Delete Account",
                  style: getFontStyle(FontSize.xxLarge, Colors.black, FontWeight.w600, widget.general),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Account deletion will erase your entire account including all courses that are related. You will no longer be able to login with this account and watch your purchased or favorite courses. Your personal info and support messages will be erased as well. There is no recovery after account deletion. Make sure this is exactly what you want!",
                    style: getFontStyle(FontSize.medium, Colors.black, FontWeight.w600, widget.general),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                MainButton(
                  text: "CONFIRM DELETION",
                  onTap: () {
                    deleteAccountAction();
                  },
                  general: widget.general,
                  backgroundColor: Colors.redAccent,
                  textColor: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    "You will permanently lose your courses, messages and profile info. After this, there is no turning back",
                    style: getFontStyle(FontSize.medium, Colors.grey, FontWeight.w600, widget.general),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void deleteAccountAction() async {
    await displayTextInputDialog(context);
  }

  Future<void> displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Enter password"),
            content: TextField(
              controller: passwordController,
              decoration: InputDecoration(hintText: "Account Password"),
            ),
            actions: <Widget>[
              MainButton(
                text: "Cancel",
                onTap: () {
                  Navigator.pop(context);
                },
                general: widget.general,
                backgroundColor: Colors.redAccent,
                textColor: Colors.white,
              ),
              MainButton(
                text: "Submit",
                onTap: () async {
                  await reAuthenticateWithCredential(passwordController.text);
                },
                general: widget.general,
                backgroundColor: Colors.greenAccent,
                textColor: Colors.white,
              ),
            ],
          );
        });
  }

  Future<void> reAuthenticateWithCredential(String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final credential = EmailAuthProvider.credential(
        email: user?.email ?? "",
        password: password,
      );
      await user?.reauthenticateWithCredential(credential);
      await FirebaseFirestore.instance.collection("users").doc(user?.uid ?? "").delete();
      await user?.delete();
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage(model: BeAppModel(options: widget.options, general: widget.general))),
          (Route<dynamic> route) => false);
    } on Exception catch (e) {
      Navigator.pop(context);
      passwordController.text = "";
      var snackBar = SnackBar(content: Text("Invalid Password"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
