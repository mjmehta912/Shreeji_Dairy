import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/products/models/cart.dart';
import 'package:shreeji_dairy/features/products/models/product.dart';
import 'package:shreeji_dairy/features/products/widgets/sort_by_bottom_sheet.dart';

class FilterConstants {
  static const sortBy = 'Sort By';
  static const category = 'Category';
  static const group = 'Group';
  static const subCategory = 'Sub Category';
}

enum SortCriteria {
  priceHighToLow,
  priceLowToHigh,
  alphabeticalAToZ,
  alphabeticalZToA,
}

class ProductsController extends GetxController {
  var isLoading = false.obs;

  final RxDouble totalPrice = 0.0.obs; // Track total price reactively

  final List<String> imagePaths = [
    kImageAd1,
    kImageAd2,
    kImageAd3,
  ];

  var searchController = TextEditingController();
  final filterOptions = [
    FilterConstants.sortBy,
    FilterConstants.category,
    FilterConstants.group,
    FilterConstants.subCategory,
  ].obs;

  final selectedFilters = <String>[].obs;
  final RxString selectedSortBy = ''.obs;

  List<String> get reorderedFilterOptions {
    final selected = selectedFilters.toList();
    final unselected = filterOptions
        .where(
          (filter) => !selected.contains(filter),
        )
        .toList();
    return [
      ...selected,
      ...unselected,
    ];
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
      Product(
        name: 'Akhrot Barfi',
        image: kImageAkhrotBarfi,
        skus: [
          Sku(size: '250 G', rate: 100.0),
          Sku(size: '500 G', rate: 180.0),
          Sku(size: '1 KG', rate: 350.0),
          Sku(size: '2 KG', rate: 650.0),
        ],
      ),
      Product(
        name: 'Kala Jam',
        image: kImageKalajam,
        skus: [
          Sku(size: '250G', rate: 120.0),
          Sku(size: '500G', rate: 210.0),
          Sku(size: '1KG', rate: 400.0),
          Sku(size: '2KG', rate: 780.0),
        ],
      ),
    ],
  );

  // Recalculate total price
  void updateTotalPrice() {
    totalPrice.value = cartItems.fold(
      0.0,
      (sum, item) => sum + (item.sku.rate * item.quantity.value),
    );
  }

  void toggleFilter(String filter) {
    if (filter == FilterConstants.sortBy) {
      Get.bottomSheet(
        SortOptionsBottomSheet(
          onSortSelected: sortProducts,
        ),
        isScrollControlled: true,
      );
      return;
    }
    selectedFilters.contains(filter)
        ? selectedFilters.remove(filter)
        : selectedFilters.add(filter);
  }

  void sortProducts(SortCriteria criteria) {
    switch (criteria) {
      case SortCriteria.priceHighToLow:
        products.sort(
          (a, b) => b.skus[0].rate.compareTo(a.skus[0].rate),
        );
        break;
      case SortCriteria.priceLowToHigh:
        products.sort(
          (a, b) => a.skus[0].rate.compareTo(b.skus[0].rate),
        );
        break;
      case SortCriteria.alphabeticalAToZ:
        products.sort(
          (a, b) => a.name.compareTo(b.name),
        );
        break;
      case SortCriteria.alphabeticalZToA:
        products.sort(
          (a, b) => b.name.compareTo(a.name),
        );
        break;
    }
    products.refresh();
  }

  void incrementCounter(Product product, Sku sku) {
    int index = products.indexOf(product);
    int skuIndex = product.skus.indexOf(sku);

    if (index != -1 && skuIndex != -1) {
      sku.counter++;
      addToCart(product, sku); // Ensure cart is updated
      products.refresh();
    }
  }

  void decrementCounter(Product product, Sku sku) {
    int index = products.indexOf(product);
    int skuIndex = product.skus.indexOf(sku);

    if (index != -1 && skuIndex != -1 && sku.counter > 0) {
      sku.counter--;
      removeFromCart(product, sku); // Ensure cart is updated
      products.refresh();
    }
  }

  //! //! //! //! //! SHOPPING CART //! //! //! //! !//

  final RxList<CartItem> cartItems = <CartItem>[].obs;

  void addToCart(Product product, Sku sku) {
    var existingItem = cartItems.firstWhereOrNull(
      (item) => item.product == product && item.sku == sku,
    );

    if (existingItem != null) {
      existingItem.quantity++;
    } else {
      cartItems.add(
        CartItem(
          product: product,
          sku: sku,
          quantity: RxInt(1),
        ),
      );
    }

    updateTotalPrice(); // Update total price after adding to cart
    products.refresh();
  }

  void removeFromCart(Product product, Sku sku) {
    var existingItem = cartItems.firstWhereOrNull(
      (item) => item.product == product && item.sku == sku,
    );

    if (existingItem != null) {
      if (existingItem.quantity > 1) {
        existingItem.quantity--;
      } else {
        cartItems.remove(existingItem);
      }
    }

    updateTotalPrice(); // Update total price after removing from cart
    products.refresh();
  }

  void clearCart() {
    cartItems.clear();
    totalPrice.value = 0.0; // Reset total price when cart is cleared
  }
}
