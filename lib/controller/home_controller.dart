import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

final homeProvider = ChangeNotifierProvider<HomeController>(
  (ref) {
    return HomeController();
  },
);

class HomeController with ChangeNotifier {
  //VARIABLES
  var fromSymbol = "Select currency";
  var fromController = TextEditingController();
  var toSymbol = "Select currency";
  var toController = TextEditingController();
  //METHODS
  void showCurrency(BuildContext context, bool isFromSymbol) {
    showCurrencyPicker(
      context: context,
      onSelect: (Currency currency) {
        if (isFromSymbol) {
          fromSymbol = currency.code;
          notifyListeners();
        } else {
          toSymbol = currency.code;
          notifyListeners();
        }
      },
    );
  }

  void swapCurrency() async {
    if (fromSymbol == "Select currency" && toSymbol == "Select currency" ||
        fromSymbol == toSymbol) {
      await Fluttertoast.showToast(
        msg: "Uh oh",
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
      );
    } else {
      var temp = fromSymbol;
      fromSymbol = toSymbol;
      toSymbol = temp;
      notifyListeners();
      await Fluttertoast.showToast(
        msg: "Success",
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.greenAccent,
      );
    }
  }
}
