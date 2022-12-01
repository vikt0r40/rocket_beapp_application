import 'package:be_app_mobile/helpers/font_helper.dart';
import 'package:be_app_mobile/models/general.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:flutter/material.dart';

import '../../models/feedback.dart';
import '../../models/side_item.dart';
import '../../service/api_service.dart';
import '../../widgets/be_button.dart';

class FeedbackComponent extends StatefulWidget {
  const FeedbackComponent({Key? key, required this.item, required this.general}) : super(key: key);
  final SideItem item;
  final General general;

  @override
  State<FeedbackComponent> createState() => _FeedbackComponentState();
}

class _FeedbackComponentState extends State<FeedbackComponent> {
  APIService service = APIService();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: SingleChildScrollView(
            child: mainArea(),
          ),
        ),
      ),
    );
  }

  Widget mainArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          mainLocalization.localization.feedbackTitle,
          style: getFontStyle(25, Colors.black, FontWeight.bold, widget.general),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "Tell us what's in your mind. Your opinion is very important for us! We will try to respond as fast as we can!",
          style: getFontStyle(15, Colors.black38, FontWeight.normal, widget.general),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 10,
            child: TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(5.5),
                ),
                prefixIcon: const Icon(Icons.person, color: Colors.blue),
                hintText: mainLocalization.localization.feedbackName,
                hintStyle: const TextStyle(color: Colors.blue),
                filled: true,
                fillColor: Colors.blue[50],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 10,
          child: TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(5.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(5.5),
              ),
              prefixIcon: const Icon(Icons.email, color: Colors.blue),
              hintText: mainLocalization.localization.feedbackEmail,
              hintStyle: const TextStyle(color: Colors.blue),
              filled: true,
              fillColor: Colors.blue[50],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 10,
          child: TextFormField(
            controller: titleController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(5.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(5.5),
              ),
              prefixIcon: const Icon(Icons.title, color: Colors.green),
              hintText: mainLocalization.localization.feedbackSubject,
              hintStyle: const TextStyle(color: Colors.green),
              filled: true,
              fillColor: Colors.green[50],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width - 10,
          child: TextFormField(
            maxLines: 10,
            controller: descriptionController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(5.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(5.5),
              ),
              hintText: mainLocalization.localization.feedbackMessage,
              hintStyle: const TextStyle(color: Colors.green),
              filled: true,
              fillColor: Colors.green[50],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 60,
            child: BeButton(
              name: mainLocalization.localization.feedbackButton,
              callback: () {
                sendFeedback();
              },
              general: widget.general,
            ),
          ),
        )
      ],
    );
  }

  sendFeedback() async {
    if (nameController.text.isEmpty) {
      showAlertDialog(context, mainLocalization.localization.oops, mainLocalization.localization.feedbackNameError);
      return;
    }
    if (emailController.text.isEmpty) {
      showAlertDialog(context, mainLocalization.localization.oops, mainLocalization.localization.feedbackEmailError);
      return;
    }
    if (titleController.text.isEmpty) {
      showAlertDialog(context, mainLocalization.localization.oops, mainLocalization.localization.feedbackTitleError);
      return;
    }
    if (descriptionController.text.isEmpty) {
      showAlertDialog(context, mainLocalization.localization.oops, mainLocalization.localization.feedbackDescriptionError);
      return;
    }

    BeFeedback feedback =
        BeFeedback(name: nameController.text, email: emailController.text, title: titleController.text, description: descriptionController.text);
    await service.sendFeedback(feedback);
    clearControllers();
    showAlertDialog(context, mainLocalization.localization.feedbackSuccessTitle, mainLocalization.localization.feedbackSuccessMessage);
    if (widget.general.enabledAnalytics) {
      APIService().logEvent(AnalyticsType.feedbacks);
    }
  }

  clearControllers() {
    nameController.text = "";
    emailController.text = "";
    titleController.text = "";
    descriptionController.text = "";
  }

  showAlertDialog(BuildContext context, title, description) {
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        description,
        textAlign: TextAlign.center,
        style: getFontStyle(16, Colors.white, FontWeight.bold, widget.general),
      ),
    ));
  }
}
