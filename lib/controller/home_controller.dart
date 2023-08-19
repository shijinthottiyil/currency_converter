import 'dart:developer';

import 'package:currency_converter/model/response_model.dart';
import 'package:currency_converter/utils/constants/api.dart';
import 'package:currency_converter/utils/constants/texts.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  var isComplete = false;
  //METHODS

// METHOD TO READ DATA FROM SHARED PREFERENCES
  Future<void> readLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    final _fromSymbol = prefs.getString(KTexts.key1);
    final _toSymbol = prefs.getString(KTexts.key2);
    fromSymbol = _fromSymbol ?? KTexts.defCurr;
    toSymbol = _toSymbol ?? KTexts.defCurr;
    isComplete = true;
    notifyListeners();
  }

  void showCurrency(BuildContext context, bool isFromSymbol) {
    showCurrencyPicker(
      context: context,
      onSelect: (Currency currency) async {
        final prefs = await SharedPreferences.getInstance();
        if (isFromSymbol) {
          fromSymbol = currency.code;
          if (fromSymbol != KTexts.defCurr) {
            prefs.setString(KTexts.key1, fromSymbol);
          }
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
          prefs.setString(KTexts.key2, toSymbol);
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
  void covert() async {
    num userInput = num.parse(fromController.text);

    num result = userInput * exchangRate;
    toController.text = result.toString();
  }
}
