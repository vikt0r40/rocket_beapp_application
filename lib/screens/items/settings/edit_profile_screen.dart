import 'dart:io';

import 'package:be_app_mobile/models/be_user.dart';
import 'package:be_app_mobile/service/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../autorization/components/main_button.dart';
import '../../../autorization/helpers/font_size.dart';
import '../../../autorization/helpers/theme_colors.dart';
import '../../../helpers/font_helper.dart';
import '../../../models/general.dart';
import '../../../widgets/loading.dart';
import '../woo_commerce/woo_globals.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key, required this.general}) : super(key: key);
  final General general;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  File fileImage = File("");
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (isRTL) {
      return Directionality(textDirection: TextDirection.rtl, child: mainWidget());
    } else {
      return mainWidget();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _nameController.text = FirebaseAuth.instance.currentUser?.displayName ?? "";
    _emailController.text = FirebaseAuth.instance.currentUser?.email ?? "";
    super.initState();
  }

  Widget mainWidget() {
    return Scaffold(
      backgroundColor: widget.general.getApplicationColor(),
      appBar: AppBar(
        backgroundColor: widget.general.getTopNavigationColor(),
        elevation: 0,
        iconTheme: IconThemeData(
          color: widget.general.getTopNavigationItemColor(), //change your color here
        ),
      ),
      body: isLoading
          ? Loading(general: widget.general)
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mainLocalization.localization.profileEditTitle,
                        style: getFontStyle(FontSize.xxLarge, Colors.black, FontWeight.w600, widget.general),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: Text(
                          mainLocalization.localization.profileEditSubtitle,
                          style: getFontStyle(FontSize.medium, ThemeColors.greyTextColor, FontWeight.w600, widget.general),
                        ),
                      ),
                      const SizedBox(height: 70),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            ///Name Input Field
                            TextFormField(
                              controller: _nameController,
                              validator: (value) {
                                if (_nameController.text.isEmpty) {
                                  return mainLocalization.localization.authThisFieldCantBeEmpty;
                                }
                                return null;
                              },
                              style: getFontStyle(14, Colors.white, FontWeight.normal, widget.general),
                              keyboardType: TextInputType.name,
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                fillColor: Colors.black87,
                                filled: true,
                                hintText: mainLocalization.localization.authFullName,
                                hintStyle: getFontStyle(FontSize.medium, ThemeColors.textFieldHintColor, FontWeight.w400, widget.general),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(18)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            ///E-mail Input Field
                            TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (_emailController.text.isEmpty) {
                                  return mainLocalization.localization.authThisFieldCantBeEmpty;
                                }
                                return null;
                              },
                              style: getFontStyle(14, Colors.white, FontWeight.normal, widget.general),
                              cursorColor: Colors.white,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                fillColor: ThemeColors.textFieldBgColor,
                                filled: true,
                                hintText: mainLocalization.localization.authEmail,
                                hintStyle: getFontStyle(FontSize.medium, ThemeColors.textFieldHintColor, FontWeight.w400, widget.general),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(18)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            ///Password Input Field
                            TextFormField(
                              controller: _passwordController,
                              validator: (value) {
                                if (_passwordController.text.isEmpty) {
                                  return mainLocalization.localization.authThisFieldCantBeEmpty;
                                }
                                return null;
                              },
                              obscureText: true,
                              style: getFontStyle(14, ThemeColors.whiteTextColor, FontWeight.normal, widget.general),
                              keyboardType: TextInputType.visiblePassword,
                              cursorColor: ThemeColors.primaryColor,
                              decoration: InputDecoration(
                                fillColor: ThemeColors.textFieldBgColor,
                                filled: true,
                                hintText: mainLocalization.localization.authPass,
                                hintStyle: getFontStyle(FontSize.medium, ThemeColors.textFieldHintColor, FontWeight.w400, widget.general),
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.all(Radius.circular(18)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 70),
                            MainButton(
                              text: mainLocalization.localization.profileEditButton,
                              onTap: () {
                                _formKey.currentState!.validate();
                                updateAction();
                              },
                              general: widget.general,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget profileImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.file(
          fileImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void updateAction() async {
    setState(() {
      isLoading = true;
    });
    if (FirebaseAuth.instance.currentUser != null) {
      if (_nameController.text.isNotEmpty) {
        await FirebaseAuth.instance.currentUser?.updateDisplayName(_nameController.text);
      }
      if (_emailController.text.isNotEmpty) {
        await FirebaseAuth.instance.currentUser?.updateEmail(_emailController.text);
      }
      if (_passwordController.text.isNotEmpty) {
        await FirebaseAuth.instance.currentUser?.updatePassword(_passwordController.text);
      }
    }
    BeUser user = await APIService().getUserSettings();
    user.displayName = _nameController.text;
    user.email = _emailController.text;
    await APIService().updateUserSettingsWithUser(user);
    Navigator.pop(context);

    setState(() {
      isLoading = false;
    });
  }
}
