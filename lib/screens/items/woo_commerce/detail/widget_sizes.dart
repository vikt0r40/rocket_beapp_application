import 'package:flutter/material.dart';

import '../../../../models/variable_product.dart';

class SizesWidget extends StatelessWidget {
  final List<VariableProduct> sizes;
  final VariableProduct variableProduct;
  final void Function(VariableProduct) onSizeSelected;

  const SizesWidget(
      {Key? key,
      required this.sizes,
      required this.variableProduct,
      required this.onSizeSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (sizes.isEmpty) {
      return const Text("Empty");
    }
    final buttons = List.generate(
        sizes.length,
        (index) => Padding(
              padding: const EdgeInsets.all(5.0),
              child: Material(
                child: InkWell(
                  borderRadius: BorderRadius.circular(3),
                  onTap: () => onSizeSelected(sizes[index]),
                  child: FittedBox(
                    child: Ink(
                      height: 30,
                      decoration: BoxDecoration(
                          color: identical(variableProduct, sizes[index])
                              ? Colors.orange[100]
                              : Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(3),
                          border:
                              Border.all(color: Colors.black.withOpacity(0.1))),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            sizes[index].attributes.length > 1
                                ? "  ${sizes[index].attributes[0].option} - ${sizes[index].attributes[1].option}  "
                                : "  ${sizes[index].attributes[0].option}  ",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                ?.copyWith(
                                    color:
                                        identical(variableProduct, sizes[index])
                                            ? Colors.black
                                            : Theme.of(context)
                                                .textTheme
                                                .headline2
                                                ?.color),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.topLeft,
            child: Wrap(alignment: WrapAlignment.start, children: buttons))
      ],
    );
  }
}
