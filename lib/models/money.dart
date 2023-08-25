import 'package:hive/hive.dart';
part 'money.g.dart';

@HiveType(typeId: 0)
class Money {
  @HiveField(1)
  int id;

  @HiveField(2)
  String title;

  @HiveField(3)
  String date;

  @HiveField(4)
  String price;

  @HiveField(5)
  bool isReceived;
  Money(
      {required this.id,
      required this.title,
      required this.date,
      required this.price,
      required this.isReceived});
}
