import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';

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
    'Sub Category',
  ].obs;

  final selectedFilters = <String>[].obs;

  // Reactive variable for the selected sort option
  final RxString selectedSortBy = ''.obs;

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
    if (filter == 'Sort By') {
      Get.bottomSheet(
        SortOptionsBottomSheet(onSortSelected: sortProducts),
        isScrollControlled: true,
      );
      return;
    }
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }
  }

  void sortProducts(String criteria) {
    // Set the selected sort option
    selectedSortBy.value = criteria;

    if (criteria == 'Price: High to Low') {
      products.sort((a, b) => b.skus[0].rate.compareTo(a.skus[0].rate));
    } else if (criteria == 'Price: Low to High') {
      products.sort((a, b) => a.skus[0].rate.compareTo(b.skus[0].rate));
    } else if (criteria == 'Alphabetical: A to Z') {
      products.sort((a, b) => a.name.compareTo(b.name));
    } else if (criteria == 'Alphabetical: Z to A') {
      products.sort((a, b) => b.name.compareTo(a.name));
    }
    products.refresh(); // Notify listeners of the change
  }

  final RxList<Product> products = RxList<Product>(
    [
      Product(
        name: 'Angoori Basundi',
        image: kImageBasundi,
        skus: [
          Sku(size: '250 G', rate: 100.0),
          Sku(size: '500 G', rate: 180.0),
          Sku(size: '1 KG', rate: 350.0),
          Sku(size: '2 KG', rate: 650.0),
        ],
      ),
      Product(
        name: 'Badam Kali',
        image: kImageBadamKali,
        skus: [
          Sku(size: '250 G', rate: 150.0),
          Sku(size: '500 G', rate: 250.0),
          Sku(size: '1 KG', rate: 450.0),
          Sku(size: '2 KG', rate: 850.0),
        ],
      ),
      Product(
        name: 'Kamal',
        image: kImageKamal,
        skus: [
          Sku(size: '250G', rate: 120.0),
          Sku(size: '500G', rate: 210.0),
          Sku(size: '1KG', rate: 400.0),
          Sku(size: '2KG', rate: 780.0),
        ],
      ),
      Product(
        name: 'Afghan Dryfruit Shrikhand',
        image: kImageMAndM,
        skus: [
          Sku(size: '250 G', rate: 100.0),
          Sku(size: '500 G', rate: 180.0),
          Sku(size: '1 KG', rate: 350.0),
          Sku(size: '2 KG', rate: 650.0),
        ],
      ),
      Product(
        name: 'Mango Shrikhand',
        image: kImageMangoShrikhand,
        skus: [
          Sku(size: '250G', rate: 120.0),
          Sku(size: '500G', rate: 210.0),
          Sku(size: '1KG', rate: 400.0),
          Sku(size: '2KG', rate: 780.0),
        ],
      ),
      Product(
        name: 'Choco Moon Penda',
        image: kImageMAndM,
        skus: [
          Sku(size: '250 G', rate: 150.0),
          Sku(size: '500 G', rate: 250.0),
          Sku(size: '1 KG', rate: 450.0),
          Sku(size: '2 KG', rate: 850.0),
        ],
      ),
      Product(
        name: 'Cherry Almond',
        image: kImageCherryAlmond,
        skus: [
          Sku(size: '250G', rate: 120.0),
          Sku(size: '500G', rate: 210.0),
          Sku(size: '1KG', rate: 400.0),
          Sku(size: '2KG', rate: 780.0),
        ],
      ),
    ],
  );

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
  RxInt counter = RxInt(0);
  double rate;

  Sku({
    required this.size,
    required this.rate,
  });
}

class SortOptionsBottomSheet extends StatelessWidget {
  final Function(String) onSortSelected;

  const SortOptionsBottomSheet({
    super.key,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sort By',
            style: TextStyles.kMediumFredoka(),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text(
              'Price: High to Low',
              style: TextStyles.kRegularFredoka(
                fontSize: FontSizes.k16FontSize,
              ),
            ),
            onTap: () {
              onSortSelected('Price: High to Low');
              Get.back(); // Close the bottom sheet
            },
          ),
          ListTile(
            title: Text(
              'Price: Low to High',
              style: TextStyles.kRegularFredoka(
                fontSize: FontSizes.k16FontSize,
              ),
            ),
            onTap: () {
              onSortSelected('Price: Low to High');
              Get.back(); // Close the bottom sheet
            },
          ),
          ListTile(
            title: Text(
              'Alphabetical: A to Z',
              style: TextStyles.kRegularFredoka(
                fontSize: FontSizes.k16FontSize,
              ),
            ),
            onTap: () {
              onSortSelected('Alphabetical: A to Z');
              Get.back(); // Close the bottom sheet
            },
          ),
          ListTile(
            title: Text(
              'Alphabetical: Z to A',
              style: TextStyles.kRegularFredoka(
                fontSize: FontSizes.k16FontSize,
              ),
            ),
            onTap: () {
              onSortSelected('Alphabetical: Z to A');
              Get.back(); // Close the bottom sheet
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
