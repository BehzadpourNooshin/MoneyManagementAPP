import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneymgtapp/constant.dart';
import 'package:moneymgtapp/controllers/moneyeditingcontroller.dart';
import 'package:moneymgtapp/main.dart';
import 'package:moneymgtapp/models/money.dart';
import 'package:moneymgtapp/screens/newtransactionscreen.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneymgtapp/utils/extension.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static bool isEditing = false;
  static int selectedIdx = -1;
  static List<Money> moneys = [];
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    MyApp.getData();
    super.initState();
  }

  Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            floatingActionButton: myFBTN(),
            body: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    myHeaderWiget(),
                    Expanded(
                        child: HomeScreen.moneys.isEmpty
                            ? const EmptyWidget()
                            : ListView.builder(
                                itemCount: HomeScreen.moneys.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onTap: () {
                                        HomeScreen.isEditing = true;
                                        HomeScreen.selectedIdx =
                                            HomeScreen.moneys[index].id;
                                        MoneyController
                                                .descriptionController.text =
                                            HomeScreen.moneys[index].title;
                                        MoneyController.priceController.text =
                                            HomeScreen.moneys[index].price;
                                        NewTransactionScreen.date =
                                            HomeScreen.moneys[index].date;
                                        NewTransactionScreen.groupId =
                                            (HomeScreen
                                                    .moneys[index].isReceived)
                                                ? 1
                                                : 2;

                                        Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const NewTransactionScreen()))
                                            .then((value) {
                                          MyApp.getData();
                                          setState(() {});
                                        });
                                      },
                                      onLongPress: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  title: const Text(
                                                      'آیا از حذف این تراکنش مطمئن هستید؟',
                                                      style: TextStyle(
                                                          fontSize: 12)),
                                                  actionsAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          'خیر',
                                                          style: TextStyle(
                                                              color:
                                                                  kGreenColor),
                                                        )),
                                                    TextButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            hiveBox.deleteAt(
                                                                index);
                                                            // HomeScreen.moneys
                                                            //     .removeAt(
                                                            //         index);
                                                          });
                                                          MyApp.getData();
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          'بله',
                                                          style: TextStyle(
                                                              color: kRedColor),
                                                        )),
                                                  ],
                                                ));
                                      },
                                      child: MyTileWidget(idx: index));
                                },
                              ))
                    //  const Expanded(child: EmptyWidget()),
                  ],
                ))));
  }

  Widget myFBTN() {
    return FloatingActionButton(
        backgroundColor: kPurpleColor,
        onPressed: () {
          HomeScreen.isEditing = false;
          MoneyController.descriptionController.text = '';
          MoneyController.priceController.text = '';
          NewTransactionScreen.date = 'تاریخ';
          NewTransactionScreen.groupId = 0;
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NewTransactionScreen()))
              .then((value) {
            MyApp.getData();
            setState(() {});
          });
        },
        elevation: 0,
        child: const Icon(Icons.add));
  }

  Widget myHeaderWiget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: SearchBarAnimation(
              textEditingController: searchController,
              isOriginalAnimation: false,
              hintText: 'جستجو کنید...',
              buttonElevation: 0,
              onCollapseComplete: () {
                MyApp.getData();
                searchController.text = '';
                setState(() {});
              },
              buttonShadowColour: kBlackColorSearchBarBTN,
              buttonBorderColour: kBlackColorSearchBarBTN,
              onChanged: (String text) {
                List<Money> result = hiveBox.values
                    .where((value) =>
                        value.title.contains(text) ||
                        value.price.contains(text) ||
                        value.date.contains(text))
                    .toList();
                HomeScreen.moneys.clear();
                setState(() {
                  for (var value in result) {
                    HomeScreen.moneys.add(value);
                  }
                });
              },
              trailingWidget: const Icon(
                Icons.search,
                size: 20,
                color: kBlackColorSearchBarBTN,
              ),
              secondaryButtonWidget: const Icon(
                Icons.close,
                size: 20,
                color: kBlackColorSearchBarBTN,
              ),
              buttonWidget: const Icon(
                Icons.search,
                size: 20,
                color: kBlackColorSearchBarBTN,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            'تراکنش‌ها',
            style: TextStyle(
                fontSize: (ScreenSize(context).screenWidth < 1004)
                    ? 15
                    : ScreenSize(context).screenWidth * 0.015),
          ),
        ],
      ),
    );
  }
}

class MyTileWidget extends StatelessWidget {
  final int idx;
  const MyTileWidget({
    required this.idx,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: (HomeScreen.moneys[idx].isReceived)
                        ? kGreenColor
                        : kRedColor,
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                    child: Icon(
                        (HomeScreen.moneys[idx].isReceived)
                            ? Icons.add
                            : Icons.remove,
                        color: Colors.white,
                        size: 30))),
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  HomeScreen.moneys[idx].title,
                  style: TextStyle(
                    fontSize: (ScreenSize(context).screenWidth < 1004)
                        ? 14
                        : ScreenSize(context).screenWidth * 0.014,
                  ),
                )),
            const Spacer(),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Row(
                children: [
                  Text('تومان',
                      style: TextStyle(
                        fontSize: (ScreenSize(context).screenWidth < 1004)
                            ? 14
                            : ScreenSize(context).screenWidth * 0.014,
                        color: (HomeScreen.moneys[idx].isReceived)
                            ? kGreenColor
                            : kRedColor,
                      )),
                  Text(HomeScreen.moneys[idx].price,
                      style: TextStyle(
                        fontSize: (ScreenSize(context).screenWidth < 1004)
                            ? 14
                            : ScreenSize(context).screenWidth * 0.014,
                        color: (HomeScreen.moneys[idx].isReceived)
                            ? kGreenColor
                            : kRedColor,
                      )),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  HomeScreen.moneys[idx].date,
                  style: TextStyle(
                    fontSize: (ScreenSize(context).screenWidth < 1004)
                        ? 12
                        : ScreenSize(context).screenWidth * 0.01,
                  ),
                ),
              )
            ]),
          ],
        ));
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        SvgPicture.asset('assets/images/empty.svg', height: 150, width: 150),
        const SizedBox(height: 10),
        const Text('!تراکنشی موجود نیست'),
        const Spacer(),
      ],
    );
  }
}
