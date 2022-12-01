import 'package:be_app_mobile/models/be_app.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/detail/product_details_wrapper.dart';
import 'package:be_app_mobile/screens/items/woo_commerce/woo_globals.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../models/product.dart';

class BeProduct extends StatefulWidget {
  const BeProduct({Key? key, required this.product, required this.appModel, required this.onProductBack}) : super(key: key);
  final Product product;
  final BeAppModel appModel;
  final Function onProductBack;
  @override
  State<BeProduct> createState() => _BeProductState();
}

class _BeProductState extends State<BeProduct> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsWrapper(
                      product: widget.product,
                      appModel: widget.appModel,
                    )));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xffE65829).withAlpha(40),
                        ),
                        Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Image.network(
                              widget.product.images.isNotEmpty ? widget.product.images[0].src : "https://i.ibb.co/z6TxCPc/images.png",
                              height: 180,
                              fit: BoxFit.fitWidth,
                            )),
                      ],
                    ),
                    // Visibility(
                    //   visible: this.widget.data.shouldOnSaleBeVisisble(),
                    //   child: Container(
                    //     padding: EdgeInsets.only(top: 10),
                    //     child: Align(
                    //       alignment: Alignment.center,
                    //       child: Container(
                    //         padding: EdgeInsets.only(
                    //             left: 8, right: 8, top: 4, bottom: 4),
                    //         decoration: BoxDecoration(
                    //           color: Colors.green,
                    //           borderRadius: BorderRadius.circular(50),
                    //         ),
                    //         child: Text(
                    //           this.widget.data.isVariable()
                    //               ? "On sale"
                    //               : '${this.widget.data.calculateDiscount()}% ${Translations.currentLocalizations['discount_field_text']}',
                    //           style: GoogleFonts.oswald(
                    //               fontSize: 15, color: Colors.white),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
                const SizedBox(height: 10),
                Text(widget.product.name, textAlign: TextAlign.center, maxLines: 2, style: Theme.of(context).textTheme.subtitle1),
                const SizedBox(height: 3),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: widget.product.regularPrice != "" && widget.product.salePrice != "",
                        child: Text(
                          NumberFormat.simpleCurrency(name: storeCurrency)
                              .format(double.parse(widget.product.regularPrice == "" ? "0" : widget.product.regularPrice)),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Visibility(visible: widget.product.salePrice != "", child: const SizedBox(width: 10)),
                      Visibility(
                        visible: true,
                        child: Text(
                          NumberFormat.simpleCurrency(name: storeCurrency).format(double.parse(widget.product.loadPrice())),
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void openProductDetails() async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductDetailsWrapper(
                  product: widget.product,
                  appModel: widget.appModel,
                )));
    widget.onProductBack();
  }
}
