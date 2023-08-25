import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:moneymgtapp/constant.dart';
import 'package:moneymgtapp/controllers/moneyeditingcontroller.dart';
import 'package:moneymgtapp/screens/homescreen.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:moneymgtapp/utils/extension.dart';
import '../main.dart';
import '../models/money.dart';

class NewTransactionScreen extends StatefulWidget {
  const NewTransactionScreen({super.key});
  static int groupId = 0;
  static String date = 'تاریخ';
  @override
  State<NewTransactionScreen> createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(HomeScreen.isEditing ? 'ویرایش تراکنش' : 'تراکنش جدید',
              style: TextStyle(
                  fontSize: (ScreenSize(context).screenWidth < 1004)
                      ? 14
                      : ScreenSize(context).screenWidth * 0.014)),
          MyTXTField(
            myTitle: (HomeScreen.isEditing)
                ? MoneyController.descriptionController.text
                : 'توضیحات',
            controller: MoneyController.descriptionController,
          ),
          MyTXTField(
            myTitle: (HomeScreen.isEditing)
                ? MoneyController.priceController.text
                : 'مبلغ',
            type: TextInputType.number,
            controller: MoneyController.priceController,
          ),
          const TypeAndDatewiget(),
          const SizedBox(height: 20),
          MyBTN(
            title: HomeScreen.isEditing ? 'ویرایش کردن' : 'اضافه کردن',
            onPressed: () {
              Money item = Money(
                id: Random().nextInt(999999),
                title: MoneyController.descriptionController.text,
                price: MoneyController.priceController.text,
                date: NewTransactionScreen.date,
                isReceived: (NewTransactionScreen.groupId == 1) ? true : false,
              );
              if (HomeScreen.isEditing) {
                int index = 0;
                MyApp.getData();
                for (int i = 0; i < hiveBox.values.length; i++) {
                  var item = hiveBox.getAt(i);
                  if (item?.id == HomeScreen.selectedIdx) {
                    index = i;
                    break;
                  }
                }
                hiveBox.putAt(index, item);
                //HomeScreen.moneys[HomeScreen.selectedIdx] = item;
              } else {
                hiveBox.add(item);
                // HomeScreen.moneys.add(item);
              }

              Navigator.pop(context);
            },
          )
        ]),
      ),
    ));
  }
}

class MyBTN extends StatelessWidget {
  final String title;

  final Function() onPressed;
  const MyBTN({
    required this.title,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
            style: TextButton.styleFrom(
                backgroundColor: kPurpleColor, elevation: 0),
            onPressed: onPressed,
            child: Text(title)));
  }
}

class TypeAndDatewiget extends StatefulWidget {
  const TypeAndDatewiget({
    super.key,
  });

  @override
  State<TypeAndDatewiget> createState() => _TypeAndDatewigetState();
}

class _TypeAndDatewigetState extends State<TypeAndDatewiget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: MyRadioBTN(
          value: 1,
          groupValue: NewTransactionScreen.groupId,
          onChanged: (value) {
            setState(() {
              NewTransactionScreen.groupId = value!;
            });
          },
          title: 'دریافتی',
        )),
        const SizedBox(width: 10),
        Expanded(
            child: MyRadioBTN(
          value: 2,
          groupValue: NewTransactionScreen.groupId,
          onChanged: (value) {
            setState(() {
              NewTransactionScreen.groupId = value!;
            });
          },
          title: 'پرداختی',
        )),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
              height: 50,
              child: OutlinedButton(
                // onPressed: () {},
                onPressed: () async {
                  // ignore: unused_local_variable
                  Jalali? pickedData = await showPersianDatePicker(
                    context: context,
                    initialDate: Jalali.now(),
                    firstDate: Jalali(1400),
                    lastDate: Jalali(1499),
                  );
                  setState(() {
                    NewTransactionScreen.date =
                        "${pickedData!.year}/${(pickedData.month.toString()).padLeft(2, '0')}/${(pickedData.day.toString()).padLeft(2, '0')}";
                  });
                },
                child: Text(
                  NewTransactionScreen.date,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: (ScreenSize(context).screenWidth < 1004)
                          ? 13
                          : ScreenSize(context).screenWidth * 0.013),
                ),
              )),
        ),
      ],
    );
  }
}

class MyRadioBTN extends StatelessWidget {
  final String title;
  final int value;
  final int groupValue;
  final Function(int?) onChanged;
  const MyRadioBTN({
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Radio(
              value: value,
              groupValue: groupValue,
              onChanged: onChanged,
              activeColor: kPurpleColor,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: (ScreenSize(context).screenWidth < 1004)
                  ? 13
                  : ScreenSize(context).screenWidth * 0.013,
            ),
          ),
        ],
      ),
    );
  }
}

class MyTXTField extends StatelessWidget {
  final String myTitle;
  final TextInputType type;
  final TextEditingController controller;
  const MyTXTField(
      {super.key,
      required this.controller,
      required this.myTitle,
      this.type = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      cursorColor: Colors.grey.shade300,
      decoration: InputDecoration(
        hintText: myTitle,
        hintStyle: TextStyle(
          fontSize: (ScreenSize(context).screenWidth < 1004)
              ? 13
              : ScreenSize(context).screenWidth * 0.013,
        ),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300)),
      ),
    );
  }
}
