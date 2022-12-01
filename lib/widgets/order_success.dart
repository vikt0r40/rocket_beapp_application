import 'package:be_app_mobile/models/app_options.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:flutter/material.dart';

class OrderSuccess extends StatelessWidget {
  const OrderSuccess({Key? key, required this.options}) : super(key: key);
  final AppOptions options;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color: Theme.of(context).primaryColor,
          margin: const EdgeInsets.only(top: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Colors.black.withOpacity(1),
                            Colors.black.withOpacity(0.7),
                          ],
                        )),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 90,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Opacity(
                opacity: 0.6,
                child: Text(
                  mainLocalization.localization.wooOrderSuccess,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                padding: const EdgeInsets.all(15),
                color: Colors.black,
                child: Text(
                  mainLocalization.localization.gotItThankYou,
                  style: Theme.of(context).textTheme.button,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
