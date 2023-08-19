import 'dart:developer';

import 'package:currency_converter/model/response_model.dart';
import 'package:currency_converter/utils/constants/api.dart';
import 'package:currency_converter/utils/constants/texts.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:dio/dio.dart';
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
  var fromSymbol = KTexts.defCurr;
  var fromController = TextEditingController();
  var toSymbol = KTexts.defCurr;
  var toController = TextEditingController(text: "");
  var isLoading = false;
  var exchangRate = 0.0;
  //METHODS
  void showCurrency(BuildContext context, bool isFromSymbol) {
    showCurrencyPicker(
      context: context,
      onSelect: (Currency currency) async {
        if (isFromSymbol) {
          fromSymbol = currency.code;
          notifyListeners();
        } else {
          if (fromSymbol == KTexts.defCurr) {
            await Fluttertoast.showToast(
              msg: "First select base currency",
              gravity: ToastGravity.TOP,
              backgroundColor: Colors.redAccent,
              toastLength: Toast.LENGTH_LONG,
            );
            isLoading = false;
            notifyListeners();
            return;
          }
          toSymbol = currency.code;
          notifyListeners();
          await fetchExchangeRate(baseCode: fromSymbol, targetCode: toSymbol);
        }
      },
    );
  }

  void swapCurrency() async {
    if (fromSymbol == KTexts.defCurr ||
        toSymbol == KTexts.defCurr ||
        fromSymbol == toSymbol) {
      await Fluttertoast.showToast(
        msg: "Uh oh",
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
      );
      return;
    } else {
      var temp = fromSymbol;
      fromSymbol = toSymbol;
      toSymbol = temp;
      notifyListeners();
      await fetchExchangeRate(baseCode: fromSymbol, targetCode: toSymbol);
      await Fluttertoast.showToast(
        msg: "Success",
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.greenAccent,
      );
    }
  }

  //<==================METHOD FOR FETCHING EXCHANGE RATES=======================>
  Future<void> fetchExchangeRate(
      {required String baseCode, required String targetCode}) async {
    isLoading = true;
    notifyListeners();
    final dio = Dio();
    final ResponseModel responseModel;
    try {
      var response = await dio.get("${KApi.endPoint}/$baseCode/$targetCode");
      if (response.statusCode == 200) {
        log("response from api $response");
        responseModel = ResponseModel.fromJson(response.data);
        exchangRate = responseModel.conversionRate;
      } else {
        throw Exception();
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      log("api error occured ${e.toString()}");
      await Fluttertoast.showToast(
        msg: "Uh oh",
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.redAccent,
      );
      isLoading = false;
      notifyListeners();
    }
  }

  // mock() async {
  //   isLoading = true;
  //   notifyListeners();
  //   Future.delayed(Duration(seconds: 5)).then((value) {
  //     isLoading = false;
  //     notifyListeners();
  //   });
  // }
  // METHOD FOR CONVERTING
  void covert() {
    num userInput = num.parse(fromController.text);
    num result = userInput * exchangRate;
    toController.text = result.toString();
  }
}
