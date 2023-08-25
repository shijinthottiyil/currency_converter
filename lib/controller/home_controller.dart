import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:currency_converter/model/exchange_model.dart';
import 'package:currency_converter/model/response_model.dart';
import 'package:currency_converter/utils/constants/api.dart';
import 'package:currency_converter/utils/constants/texts.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
  var isBottomSheetOpen = false;
  // <========INTERNET CONNECTIVITY CHECK ====================================>
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
//METHODS
//<========================== METHOD FOR CONNECTIVITY CHECK ========================>
  void checkConnectivity(BuildContext context) {
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && isAlertSet == false) {
          if (context.mounted) {
            showDialogBox(context);
            isAlertSet = true;
            notifyListeners();
          }
        }
      },
    );
  }

  //<========================= METHOD FOR SHOWING DIALOG ==========================>
  Future<void> showDialogBox(BuildContext context) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Connection lost'),
          content: const Text('Check connection and retry'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');

                isAlertSet = false;
                notifyListeners();
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  if (context.mounted) {
                    showDialogBox(context);
                  }

                  isAlertSet = true;
                  notifyListeners();
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

// <=================METHOD TO READ DATA FROM SHARED PREFERENCES=====================>
  Future<void> readLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    final frmSymbol = prefs.getString(KTexts.key1);
    final toSymbl = prefs.getString(KTexts.key2);
    fromSymbol = frmSymbol ?? KTexts.defCurr;
    toSymbol = toSymbl ?? KTexts.defCurr;
    isComplete = true;
    notifyListeners();
  }

//<===============  METHOD FOR SELECTING CURRENCY==========================>
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

// <==================METHOD FOR SWAPING CURRENCY=======================>
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

  //<========================== METHOD FOR CONVERTING ============================>
  void covert() async {
    num userInput = num.parse(fromController.text);

    num result = userInput * exchangRate;
    toController.text = result.toString();
  }

// <================ MEHTOD FOR SHOWING SHOW MODEL BOTTOM SHEET =====================>
  void showModelSheet(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    ExchangeModel exchangeModel;
    exchangeModel = await getExchangeData();
    isLoading = false;
    notifyListeners();
    if (context.mounted) {
      isBottomSheetOpen = true;
      notifyListeners();
      await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        elevation: 0,
        showDragHandle: true,
        isScrollControlled: true,
        useSafeArea: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25),
          ),
        ),
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                DataTable(
                  // decoration: BoxDecoration(
                  //   border: Border.all(
                  //     color: Colors.red,
                  //     width: 2.0,
                  //   ),
                  // ),
                  columns: const [
                    DataColumn(label: Text("Country Code")),
                    DataColumn(label: Text("Exchange Rate")),
                  ],
                  rows: List.generate(exchangeModel.conversionRates.length,
                      (index) {
                    return DataRow(
                      cells: [
                        DataCell(Text(exchangeModel.conversionRates.keys
                            .elementAt(index))),
                        DataCell(Text(exchangeModel.conversionRates.values
                            .elementAt(index)
                            .toString())),
                      ],
                    );
                  }),
                  // rows: [
                  //   DataRow(
                  //     cells: [
                  //       DataCell(Text("USD")),
                  //       DataCell(Text("80")),
                  //     ],
                  //   ),
                  //   DataRow(
                  //     cells: [
                  //       DataCell(Text("AED")),
                  //       DataCell(Text("20")),
                  //     ],
                  //   ),
                  // ],
                ),
                Text("NB:Country code & Exchange Rates based on INR"),
              ],
            ),
          );
        },
      );
      isBottomSheetOpen = false;
      notifyListeners();
    }
  }

  // <=========== METHOD TO FETCH EXCHANGE RATES LIST ========================>
  Future<ExchangeModel> getExchangeData() async {
    try {
      final response = await Dio().get(KApi.exchangeEndPoint);
      final exchangeModel = ExchangeModel.fromJson(response.data);
      // log(exchangeModel.toString());
      return exchangeModel;
    } catch (e) {
      log(e.toString());
      return ExchangeModel(conversionRates: {});
    }
  }
}
