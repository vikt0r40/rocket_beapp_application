import 'package:be_app_mobile/autorization/service/auth_service.dart';
import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/be_app.dart';
import 'package:be_app_mobile/models/woo_user.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:be_app_mobile/service/woocommerce_service.dart';
import 'package:be_app_mobile/widgets/loading.dart';
import 'package:flutter/material.dart';

import '../../models/be_user.dart';
import '../../models/invite.dart';
import '../components/main_button.dart';
import '../helpers/font_size.dart';
import '../helpers/theme_colors.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key, required this.model}) : super(key: key);
  final BeAppModel model;
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _invitationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (isRTL) {
      return Directionality(textDirection: TextDirection.rtl, child: mainWidget());
    } else {
      return mainWidget();
    }
  }

  Widget mainWidget() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: ThemeColors.scaffoldBgColor,
        elevation: 0,
      ),
      body: isLoading == true
          ? Stack(
              children: [
                bodyWidget(),
                Center(
                  child: Loading(
                    general: widget.model.general,
                  ),
                )
              ],
            )
          : bodyWidget(),
    );
  }

  Widget bodyWidget() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mainLocalization.localization.authNewHere,
                style: getFontStyle(FontSize.xxLarge, ThemeColors.whiteTextColor, FontWeight.w600, widget.model.general),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7),
                child: Text(
                  mainLocalization.localization.authFillForm,
                  style: getFontStyle(FontSize.medium, ThemeColors.greyTextColor, FontWeight.w600, widget.model.general),
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
                      style: getFontStyle(14, ThemeColors.whiteTextColor, FontWeight.normal, widget.model.general),
                      keyboardType: TextInputType.name,
                      cursorColor: ThemeColors.primaryColor,
                      decoration: InputDecoration(
                        fillColor: ThemeColors.textFieldBgColor,
                        filled: true,
                        hintText: mainLocalization.localization.authFullName,
                        hintStyle: getFontStyle(FontSize.medium, ThemeColors.textFieldHintColor, FontWeight.w400, widget.model.general),
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
                      style: getFontStyle(14, ThemeColors.whiteTextColor, FontWeight.normal, widget.model.general),
                      cursorColor: ThemeColors.primaryColor,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        fillColor: ThemeColors.textFieldBgColor,
                        filled: true,
                        hintText: mainLocalization.localization.authEmail,
                        hintStyle: getFontStyle(FontSize.medium, ThemeColors.textFieldHintColor, FontWeight.w400, widget.model.general),
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
                      style: getFontStyle(14, ThemeColors.whiteTextColor, FontWeight.normal, widget.model.general),
                      keyboardType: TextInputType.visiblePassword,
                      cursorColor: ThemeColors.primaryColor,
                      decoration: InputDecoration(
                        fillColor: ThemeColors.textFieldBgColor,
                        filled: true,
                        hintText: mainLocalization.localization.authPass,
                        hintStyle: getFontStyle(FontSize.medium, ThemeColors.textFieldHintColor, FontWeight.w400, widget.model.general),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(18)),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.model.general.enableInvites,
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _invitationCodeController,
                            validator: (value) {
                              if (_invitationCodeController.text.isEmpty) {
                                return mainLocalization.localization.authThisFieldCantBeEmpty;
                              }
                              return null;
                            },
                            style: getFontStyle(14, ThemeColors.whiteTextColor, FontWeight.normal, widget.model.general),
                            cursorColor: ThemeColors.primaryColor,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              fillColor: ThemeColors.textFieldBgColor,
                              filled: true,
                              hintText: mainLocalization.localization.authInviteCode,
                              hintStyle: getFontStyle(FontSize.medium, ThemeColors.textFieldHintColor, FontWeight.w400, widget.model.general),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(18)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 70),
                    MainButton(
                      text: mainLocalization.localization.authSignUp,
                      onTap: () {
                        _formKey.currentState!.validate();
                        if (widget.model.wooConfig?.enableWooAuthorization ?? false) {
                          signUpWooCommerceAction();
                        } else {
                          signUpAction();
                        }
                      },
                      general: widget.model.general,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUpWooCommerceAction() async {
    WooUser user = WooUser();
    user.email = _emailController.text;
    user.password = _passwordController.text;
    user.firstName = _nameController.text;
    user.lastName = " ";
    bool success = await WooService().createCustomer(user);
    if (success) {
      Navigator.pop(context);
    }
  }

  void signUpAction() async {
    AuthService auth = AuthService();

    if (widget.model.general.enableInvites) {
      Invite? invite = await auth.checkInvitationCode(_invitationCodeController.text);
      if (invite != null) {
        setState(() {
          isLoading = true;
        });
        BeUser? user = await auth.registerWithEmail(_emailController.text, _passwordController.text, _nameController.text);

        setState(() {
          isLoading = false;
        });
        if (user != null) {
          invite.isUsed = true;
          await auth.activateInvitationCode(invite);
          Navigator.pop(context);
        } else {
          var snackBar = SnackBar(content: Text(auth.localize.authAccountExist));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        var snackBar = SnackBar(content: Text(auth.localize.authInvitationCodeInvalid));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      createUser();
    }
  }

  createUser() async {
    AuthService auth = AuthService();
    setState(() {
      isLoading = true;
    });
    BeUser? user = await auth.registerWithEmail(_emailController.text, _passwordController.text, _nameController.text);
    setState(() {
      isLoading = false;
    });
    if (user != null) {
      Navigator.pop(context);
    } else {
      var snackBar = SnackBar(content: Text(auth.localize.authAccountExist));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
