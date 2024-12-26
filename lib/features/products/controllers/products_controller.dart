import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';

class ProductsController extends GetxController {
  var isLoading = false.obs;

  final List<String> imagePaths = [
    kImageAd1,
    kImageAd2,
    kImageAd3,
  ];

  var searchController = TextEditingController();
  final filterOptions = [
    'Sort By',
    'Category',
    'Group',
    'Sub Group',
  ].obs;

  final selectedFilters = <String>[].obs;

  List<String> get reorderedFilterOptions {
    final selected = selectedFilters.toList();
    final unselected = filterOptions
        .where(
          (filter) => !selected.contains(filter),
        )
        .toList();
    return [...selected, ...unselected];
  }

  void toggleFilter(String filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }
  }

  // Product list
  final RxList<Product> products = RxList<Product>([
    Product(
      name: 'Angoori Basundi',
      image: kImageBasundi,
      skus: [
        Sku(size: '250 G', rate: 100.0),
        Sku(size: '500 G', rate: 180.0),
        Sku(size: '1 KG', rate: 350.0),
      ],
    ),
    Product(
      name: 'Badam Kali',
      image: kImageBadamKali,
      skus: [
        Sku(size: '250 G', rate: 150.0),
        Sku(size: '500 G', rate: 250.0),
        Sku(size: '1 KG', rate: 450.0),
      ],
    ),
    Product(
      name: 'Kamal',
      image: kImageKamal,
      skus: [
        Sku(size: '250G', rate: 120.0),
        Sku(size: '500G', rate: 210.0),
        Sku(size: '1KG', rate: 400.0),
      ],
    ),
    Product(
      name: 'Mango Shrikhand',
      image: kImageMangoShrikhand,
      skus: [
        Sku(size: '250G', rate: 120.0),
        Sku(size: '500G', rate: 210.0),
        Sku(size: '1KG', rate: 400.0),
      ],
    ),
    Product(
      name: 'Cherry Almond',
      image: kImageCherryAlmond,
      skus: [
        Sku(size: '250G', rate: 120.0),
        Sku(size: '500G', rate: 210.0),
        Sku(size: '1KG', rate: 400.0),
      ],
    ),
  ]);

  // Increment and decrement logic
  void incrementCounter(Product product, Sku sku) {
    int index = products.indexOf(product);
    int skuIndex = product.skus.indexOf(sku);
    if (index != -1 && skuIndex != -1) {
      sku.counter++;
    }
  }

  void decrementCounter(Product product, Sku sku) {
    int index = products.indexOf(product);
    int skuIndex = product.skus.indexOf(sku);
    if (index != -1 && skuIndex != -1 && sku.counter > 0) {
      sku.counter--;
    }
  }
}

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
  RxInt counter = RxInt(0); // Using RxInt to make it reactive
  double rate;

  Sku({
    required this.size,
    required this.rate,
  });
}
