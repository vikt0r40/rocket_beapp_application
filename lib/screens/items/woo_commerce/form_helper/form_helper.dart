import 'package:flutter/material.dart';

class FormHelper {
  static Widget textInput(
    BuildContext context,
    Object initialValue,
    Function onChanged, {
    bool isTextArea = false,
    bool isNumberInput = false,
    obscureText = false,
    required Function onValidate,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool readOnly = false,
    required String hintText,
    Icon? icon,
  }) {
    return TextFormField(
      initialValue: initialValue.toString(),
      style: Theme.of(context).textTheme.subtitle1,
      decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
            color: Colors.black,
          )),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black)),
          prefixIcon: icon),
      readOnly: readOnly,
      obscureText: obscureText,
      maxLines: !isTextArea ? 1 : 3,
      keyboardType: isNumberInput ? TextInputType.number : TextInputType.text,
      onChanged: (String value) {
        onChanged(value);
      },
      validator: (value) {
        return onValidate(value);
      },
    );
  }

  static InputDecoration fieldDecoration(
    BuildContext context,
    String hintText,
    String helperText, {
    required Widget prefixIcon,
    required Widget suffixIcon,
  }) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(5),
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      ),
    );
  }

  static Widget fieldLabel(String labelName) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
      child: Text(
        labelName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13.0,
        ),
      ),
    );
  }

  static Widget fieldLabelValue(
      BuildContext context, String labelName, String hintText) {
    return FormHelper.textInput(
        context,
        labelName,
        (value) => () {
              return null;
            }, onValidate: (value) {
      return null;
    }, readOnly: false, hintText: hintText);
  }

  static Widget saveButton(
      String buttonText, BuildContext context, Function onTap,
      {required String color,
      required String textColor,
      required bool fullWidth}) {
    return SizedBox(
      height: 50.0,
      //width: 250,
      child: GestureDetector(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                style: BorderStyle.solid,
                width: 1.0,
              ),
              color: Colors.black),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child:
                    Text(buttonText, style: Theme.of(context).textTheme.button),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showMessage(
    BuildContext context,
    String title,
    String message,
    String buttonText,
    Function onPressed,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            ElevatedButton(
              onPressed: () {
                onPressed();
              },
              child: Text(buttonText),
            )
          ],
        );
      },
    );
  }
}
