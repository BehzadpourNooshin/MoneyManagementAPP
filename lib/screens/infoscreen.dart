import 'package:flutter/material.dart';
import 'package:moneymgtapp/utils/calculate.dart';
import 'package:moneymgtapp/utils/extension.dart';
import 'package:moneymgtapp/widgets/chartwidget.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SizedBox(
                width: double.infinity,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 15, top: 15, left: 5),
                        child: Text(
                          'مدیریت تراکنش‌ها به تومان',
                          style: TextStyle(
                              fontSize: (ScreenSize(context).screenWidth < 1004)
                                  ? 12
                                  : ScreenSize(context).screenWidth * 0.012),
                        ),
                      ),
                      MoneyInfoWidget(
                        firstText: 'دریافتی امروز',
                        firstPrice: Calculate().receivedToday().toString(),
                        secondText: 'پرداختی امروز',
                        secondPrice: Calculate().payedToday().toString(),
                      ),
                      MoneyInfoWidget(
                        firstText: 'دریافتی این ماه',
                        firstPrice: Calculate().receivedThisMonth().toString(),
                        secondText: 'پرداختی این ماه',
                        secondPrice: Calculate().payedThisMonth().toString(),
                      ),
                      MoneyInfoWidget(
                        firstText: 'دریافتی امسال',
                        firstPrice: Calculate().receivedThisYear().toString(),
                        secondText: 'پرداختی امسال',
                        secondPrice: Calculate().payedThisYear().toString(),
                      ),
                      const SizedBox(height: 30),
                      (Calculate().payedThisYear() != 0 &&
                              Calculate().receivedThisYear() != 0)
                          ? Container(
                              padding: const EdgeInsets.all(20),
                              height: 200,
                              child: const BarChartWidget())
                          : Container(),
                    ]))));
  }
}

class MoneyInfoWidget extends StatelessWidget {
  final String firstText;
  final String secondText;
  final String firstPrice;
  final String secondPrice;
  const MoneyInfoWidget({
    Key? key,
    required this.firstText,
    required this.secondText,
    required this.firstPrice,
    required this.secondPrice,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              child: Text(
            secondPrice,
            textAlign: TextAlign.right,
            style: TextStyle(
                fontSize: (ScreenSize(context).screenWidth < 1004)
                    ? 12
                    : ScreenSize(context).screenWidth * 0.012),
          )),
          Expanded(
            child: Text(
              secondText,
              style: TextStyle(
                  fontSize: (ScreenSize(context).screenWidth < 1004)
                      ? 12
                      : ScreenSize(context).screenWidth * 0.012),
            ),
          ),
          Expanded(
            child: Text(
              firstPrice,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: (ScreenSize(context).screenWidth < 1004)
                      ? 12
                      : ScreenSize(context).screenWidth * 0.012),
            ),
          ),
          Expanded(
            child: Text(
              firstText,
              style: TextStyle(
                  fontSize: (ScreenSize(context).screenWidth < 1004)
                      ? 12
                      : ScreenSize(context).screenWidth * 0.012),
            ),
          ),
        ],
      ),
    );
  }
}
