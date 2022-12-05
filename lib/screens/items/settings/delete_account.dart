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
import '../woo_commerce/woo_globals.dart';

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
                  mainLocalization.localization.profileDeleteTitle,
                  style: getFontStyle(FontSize.xxLarge, Colors.black, FontWeight.w600, widget.general),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    mainLocalization.localization.deleteAccountMessage,
                    style: getFontStyle(FontSize.medium, Colors.black, FontWeight.w600, widget.general),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                MainButton(
                  text: mainLocalization.localization.deleteAccountButton,
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
                    mainLocalization.localization.deleteAccountHint,
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
            title: Text(mainLocalization.localization.deleteAccountEnterPass),
            content: TextField(
              controller: passwordController,
              decoration: InputDecoration(hintText: mainLocalization.localization.deleteAccountAccountPass),
            ),
            actions: <Widget>[
              MainButton(
                text: mainLocalization.localization.deleteAccountCancelButton,
                onTap: () {
                  Navigator.pop(context);
                },
                general: widget.general,
                backgroundColor: Colors.redAccent,
                textColor: Colors.white,
              ),
              MainButton(
                text: mainLocalization.localization.deleteAccountConfirmButton,
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
      var snackBar = SnackBar(content: Text(mainLocalization.localization.authInvalidPassword));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
