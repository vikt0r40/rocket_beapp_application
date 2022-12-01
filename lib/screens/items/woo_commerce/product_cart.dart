// class CartProduct extends StatelessWidget {
//   CartProduct({this.data});
//
//   final CartItem data;
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         elevation: 0,
//         color: Theme.of(context).primaryColor,
//         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//         child: Wrap(
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Container(
//                     width: 100,
//                     height: 100,
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                             fit: BoxFit.fitWidth,
//                             image: NetworkImage(data.thumbnail))),
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Container(
//                         child: Text(
//                           data.productName,
//                           maxLines: 3,
//                           style: Theme.of(context).textTheme.headline4,
//                         ),
//                         width: 150,
//                       ),
//                       Text(
//                         NumberFormat.simpleCurrency(name: "us").format(double.parse(data.productFinalPrice())),
//                         style: Theme.of(context).textTheme.subtitle1,
//                       ),
//                       Visibility(
//                         visible: data.variationId != 0 ? true : false,
//                         child: Text(
//                           "${data.attributeValue != null ? data.attributeValue.toUpperCase() : ""}",
//                           style: Theme.of(context).textTheme.subtitle1,
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       CustomStepper(
//                           lowerLimit: 1,
//                           upperLimit: 20,
//                           stepValue: 1,
//                           iconSize: 22.0,
//                           value: data.qty,
//                           onChange: (value) {
//                             Provider.of<CartProvider>(context, listen: false)
//                                 .updateQty(data.productId, value,
//                                 variationId: data.variationId);
//
//                             Provider.of<LoaderProvider>(context, listen: false)
//                                 .setLoadingStatus(true);
//                             Provider.of<CartProvider>(context, listen: false)
//                                 .updateCart((val) {
//                               Provider.of<LoaderProvider>(context,
//                                   listen: false)
//                                   .setLoadingStatus(false);
//                             });
//                           }),
//                     ],
//                   ),
//                   Container(
//                     width: 40,
//                     alignment: Alignment.topRight,
//                     child: FlatButton(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           Icon(
//                             Icons.close,
//                             color: Colors.black,
//                             size: 20.0,
//                           )
//                         ],
//                       ),
//                       onPressed: () {
//                         Utils.showMessage(
//                             context,
//                             Translations
//                                 .currentLocalizations['app_bar_title_text'],
//                             Translations.currentLocalizations['popup_remove'],
//                             Translations.currentLocalizations['popup_yes'],
//                                 () {
//                               CartProducts cartProducts = new CartProducts();
//                               cartProducts.productId = data.productId;
//                               cartProducts.quantity = data.qty;
//                               cartProducts.variationID = data.variationId;
//
//                               Provider.of<CartProvider>(context, listen: false)
//                                   .removeFromCart(cartProducts);
//
//                               Navigator.of(context).pop();
//                             },
//                             buttonText2:
//                             Translations.currentLocalizations['popup_no'],
//                             isConfirmationDialog: true,
//                             onPressed2: () {
//                               Navigator.of(context).pop();
//                             });
//                       },
//                       padding: EdgeInsets.all(8),
//                       color: Colors.white,
//                       shape: StadiumBorder(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const Divider(
//               color: Colors.grey,
//             )
//           ],
//         ));
//   }
// }
