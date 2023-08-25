// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../models/money.dart';

class Calculate {
  Box<Money> hiveBox = Hive.box<Money>('moneyBox');
  String currentYear = Jalali.now().year.toString();
  String currentMonth = Jalali.now().month.toString();
  String today =
      "${Jalali.now().year.toString()}/${Jalali.now().month.toString().padLeft(2, '0')}/${Jalali.now().day.toString().padLeft(2, '0')}";

  double payedToday() {
    double payToday = 0;
    for (var value in hiveBox.values) {
      if (value.date == today && !value.isReceived) {
        payToday += double.tryParse(value.price) ?? 0;
      }
    }
    return payToday;
  }

  double receivedToday() {
    double receiveToday = 0;
    for (var value in hiveBox.values) {
      if (value.date == today && value.isReceived) {
        receiveToday += double.tryParse(value.price) ?? 0;
      }
    }
    return receiveToday;
  }

  double payedThisMonth() {
    double payThisMonth = 0;
    for (var value in hiveBox.values) {
      var monthOfDate = value.date.substring(5, 7);
      if (monthOfDate == currentMonth && !value.isReceived) {
        payThisMonth += double.tryParse(value.price) ?? 0;
      }
    }
    return payThisMonth;
  }

  double receivedThisMonth() {
    double receiveThisMonth = 0;
    for (var value in hiveBox.values) {
      var monthOfDate = value.date.substring(5, 7);
      if (monthOfDate == currentMonth && value.isReceived) {
        receiveThisMonth += double.tryParse(value.price) ?? 0;
      }
    }
    return receiveThisMonth;
  }

  double payedThisYear() {
    double payThisYear = 0;
    for (var value in hiveBox.values) {
      var yearOfDate = value.date.substring(0, 4);
      if (yearOfDate == currentYear && !value.isReceived) {
        payThisYear += double.tryParse(value.price) ?? 0;
      }
    }
    return payThisYear;
  }

  double receivedThisYear() {
    double receiveThisYear = 0;
    for (var value in hiveBox.values) {
      var yearOfDate = value.date.substring(0, 4);
      if (yearOfDate == currentYear && value.isReceived) {
        receiveThisYear += double.tryParse(value.price) ?? 0;
      }
    }
    return receiveThisYear;
  }
}
