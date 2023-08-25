import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:currency_converter/controller/home_controller.dart';
import 'package:currency_converter/utils/constants/colors.dart';
import 'package:currency_converter/utils/constants/images.dart';
import 'package:currency_converter/utils/constants/texts.dart';
import 'package:currency_converter/view/home/widgets/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(homeProvider).checkConnectivity(context);
    getLocalData();
  }

  @override
  void dispose() {
    ref.read(homeProvider).subscription.cancel();
    super.dispose();
  }

  Future<void> getLocalData() async {
    await ref.read(homeProvider).readLocalData();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final homeController = ref.watch(homeProvider);

    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) async {
    //     // final prefs = await SharedPreferences.getInstance();
    //     // final data = prefs.getString(KTexts.key1);
    //     // final data2 = prefs.getString(KTexts.key2);
    //     // log("data in shared preferences = $data");
    //     // log("data stored secondly = $data2");
    //     if (!homeController.isComplete) {
    //       await homeController.readLocalData();
    //     }
    //   },
    // );
    // homeController.mock();

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
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
                          const Text(
                            "Currency Converter",
                            style: TextStyle(
                              fontSize: 25,
                              color: KColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                              width: double.infinity, height: height / 100),
                          const Text(
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
                                            const Expanded(
                                              child: Divider(
                                                color: KColors.white,
                                              ),
                                            ),
                                            RawMaterialButton(
                                              onLongPress:
                                                  homeController.swapCurrency,
                                              onPressed: homeController.covert,
                                              elevation: 0.1,
                                              fillColor: const Color.fromRGBO(
                                                  0, 0, 0, 0),
                                              padding: const EdgeInsets.all(10),
                                              shape: const CircleBorder(),
                                              child: const Icon(
                                                Icons.cached_rounded,
                                                size: 35,
                                                color: KColors.white,
                                              ),
                                            ),
                                            const Expanded(
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
                              const Text(
                                "Indicative Exchange Rate",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: KColors.white60,
                                ),
                                textAlign: TextAlign.start,
                              ),
                              SizedBox(
                                  width: double.infinity, height: height / 80),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    homeController.fromSymbol !=
                                                KTexts.defCurr &&
                                            homeController.toSymbol !=
                                                KTexts.defCurr
                                        ? "1 ${homeController.fromSymbol} = ${homeController.exchangRate} ${homeController.toSymbol}"
                                        : KTexts.select,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Visibility(
                                    visible: homeController.exchangRate == 0.0,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        homeController.fetchExchangeRate(
                                          baseCode: homeController.fromSymbol,
                                          targetCode: homeController.toSymbol,
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                          shape: const CircleBorder()),
                                      child: const Icon(
                                        Icons.refresh,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(width: double.infinity, height: height / 35),
                          GestureDetector(
                            // onVerticalDragUpdate: (details) {
                            //   int sensitivity = 20;
                            //   if (details.delta.dy > sensitivity) {
                            //     log("mock swipe");
                            //   } else if (details.delta.dy < -sensitivity) {
                            //     log("mock swipe");
                            //   }
                            // },
                            onTap: () {
                              homeController.showModelSheet(context);
                            },
                            child: Lottie.asset(
                              "assets/images/up_lottie.json",
                              height: 50,
                              width: 50,
                            ),
                          ),
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





// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});o

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {

//   }
// }
