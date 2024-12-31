import 'package:get/get.dart';

class Product {
  String name;
  String image;
  List<Sku> skus;

  Product({
    required this.name,
    required this.image,
    required this.skus,
  });
}

class Sku {
  String size;
  RxInt counter = RxInt(0);
  double rate;

  Sku({
    required this.size,
    required this.rate,
  });
}
