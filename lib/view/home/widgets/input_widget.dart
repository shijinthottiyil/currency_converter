import 'package:currency_converter/utils/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  const InputWidget({
    super.key,
    required this.heading,
    required this.symbol,
    required this.onPressed,
    required this.controller,
  });
  final String heading;
  final String symbol;
  final VoidCallback onPressed;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(
              color: KColors.white60,
            ),
          ),
          Row(
            children: [
              Text(symbol),
              Spacer(),
              OutlinedButton(
                onPressed: onPressed,
                style: OutlinedButton.styleFrom(shape: CircleBorder()),
                child: Icon(
                  Icons.mode_edit_rounded,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          // Row(
          //   children: [
          //     Text(HomeController.fromSymbol),
          //     ElevatedButton(
          //         onPressed: () {
          //           showCurrencyPicker(
          //             context: context,
          //             onSelect: (value) {
          //               log(value
          //                   .thousandsSeparator);
          //             },
          //           );
          //         },
          //         child: Text("Select Currency")),
          //   ],
          // ),
          // SizedBox(
          //   width: double.infinity,
          //   height: height / 100,
          // ),
          CupertinoTextField(
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: 10,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: KColors.white.withOpacity(0.13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}