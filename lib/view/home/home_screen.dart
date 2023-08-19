import 'dart:developer';
import 'dart:ui';

import 'package:currency_converter/controller/home_controller.dart';
import 'package:currency_converter/utils/constants/colors.dart';
import 'package:currency_converter/utils/constants/images.dart';
import 'package:currency_converter/utils/constants/texts.dart';
import 'package:currency_converter/view/home/widgets/input_widget.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.sizeOf(context).height;
    final homeController = ref.watch(homeProvider);
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) async {
    //     await homeController.mock();
    //   },
    // );
    // homeController.mock();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(KImages.bg),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20.0,
                sigmaY: 20.0,
              ),
              child: Container(),
            ),
          ),
          SafeArea(
            child: homeController.isLoading
                ? Center(
                    child: LoadingAnimationWidget.inkDrop(
                      color: KColors.white,
                      size: height / 20,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 50),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Text(
                            "Currency Converter",
                            style: TextStyle(
                              fontSize: 25,
                              color: KColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              width: double.infinity, height: height / 100),
                          Text(
                            "Check live rates, set rate alerts, receive notifications and more.",
                            style: TextStyle(
                              fontSize: 16,
                              color: KColors.white60,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(width: double.infinity, height: height / 25),
                          // Container(
                          //   alignment: Alignment.center,
                          //   child: FrostedGlassBox(
                          //     theWidth: 320.0,
                          //     theHeight: 268.0,
                          //     theChild: Text("abc"),
                          //   ),
                          // )
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: double.infinity,
                              height: height / 2,
                              color: Colors.transparent,
                              child: Stack(
                                children: [
                                  BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 5.0,
                                      sigmaY: 5.0,
                                    ),
                                    child: Container(),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: KColors.white.withOpacity(0.13),
                                      ),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          KColors.white.withOpacity(0.15),
                                          KColors.white.withOpacity(0.05),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceBetween,
                                      children: [
                                        InputWidget(
                                          isReadOnly: false,
                                          heading: "Amount",
                                          symbol: homeController.fromSymbol,
                                          onPressed: () {
                                            homeController.showCurrency(
                                                context, true);
                                          },
                                          controller:
                                              homeController.fromController,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Divider(
                                                color: KColors.white,
                                              ),
                                            ),
                                            RawMaterialButton(
                                              onLongPress:
                                                  homeController.swapCurrency,
                                              onPressed: homeController.covert,
                                              elevation: 0.1,
                                              fillColor: Colors.transparent,
                                              child: Icon(
                                                Icons.cached_rounded,
                                                size: 35,
                                                color: KColors.white,
                                              ),
                                              padding: EdgeInsets.all(10),
                                              shape: CircleBorder(),
                                            ),
                                            Expanded(
                                                child: Divider(
                                              color: KColors.white,
                                            )),
                                          ],
                                        ),
                                        InputWidget(
                                          isReadOnly: true,
                                          heading: "Converted Amount",
                                          symbol: homeController.toSymbol,
                                          onPressed: () {
                                            homeController.showCurrency(
                                                context, false);
                                            // await homeController.mock();
                                          },
                                          controller:
                                              homeController.toController,
                                        ),
                                        // Expanded(
                                        //   child: Column(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.start,
                                        //     children: [
                                        //       Text(
                                        //         "Converted Amount",
                                        //         style: TextStyle(
                                        //           color: KColors.white60,
                                        //         ),
                                        //       ),
                                        //       SizedBox(
                                        //         width: double.infinity,
                                        //         height: height / 100,
                                        //       ),
                                        //       SizedBox(
                                        //         width: double.infinity,
                                        //         height: height / 100,
                                        //       ),
                                        //       SizedBox(
                                        //         width: double.infinity,
                                        //         height: height / 100,
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: double.infinity, height: height / 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Indicative Exchange Rate",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: KColors.white60,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                  width: double.infinity, height: height / 80),
                              Text(
                                homeController.fromSymbol != KTexts.defCurr &&
                                        homeController.toSymbol !=
                                            KTexts.defCurr
                                    ? "1 ${homeController.fromSymbol} = ${homeController.exchangRate} ${homeController.toSymbol}"
                                    : KTexts.select,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
