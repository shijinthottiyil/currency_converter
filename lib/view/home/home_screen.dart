import 'dart:ui';

import 'package:currency_converter/utils/constants/colors.dart';
import 'package:currency_converter/utils/constants/images.dart';
import 'package:currency_converter/utils/frosted_glass.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(KImages.bg),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 3.0,
            sigmaY: 3.0,
          ),
          child: Container(
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
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
                    SizedBox(width: double.infinity, height: height / 100),
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
                                children: [
                                  Text(
                                    "Amount",
                                    style: TextStyle(
                                      color: KColors.white60,
                                    ),
                                  ),
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
                        SizedBox(width: double.infinity, height: height / 80),
                        Text(
                          "1 SGD = 0.7367 USD",
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
        ),
      ),
    );
  }
}
