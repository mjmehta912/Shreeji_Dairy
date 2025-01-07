import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/products/models/product_dm.dart';
import 'package:shreeji_dairy/features/products/repositories/products_repo.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class ProductsController extends GetxController {
  var isLoading = false.obs;

  var products = <ProductDm>[].obs;
  var searchController = TextEditingController();
  var cartCount = 0.obs;

  Future<void> searchProduct({
    String icCodes = '',
    String igCodes = '',
    String ipackgCodes = '',
    String searchText = '',
    String pCode = '',
  }) async {
    try {
      isLoading.value = true;

      final fetchedProducts = await ProductsRepo.searchProduct(
        icCodes: icCodes,
        igCodes: igCodes,
        ipackgCodes: ipackgCodes,
        searchText: searchText,
        pCode: pCode,
      );

      products.assignAll(fetchedProducts);
      calculateCartCount();
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addOrUpdateCart({
    required String pCode,
    required String iCode,
    required int qty,
    required double rate,
  }) async {
    isLoading.value = true;

    try {
      var response = await ProductsRepo.addOrUpdateCart(
        pCode: pCode,
        iCode: iCode,
        qty: qty,
        rate: rate,
      );

      if (response != null && response.containsKey('message')) {
        String message = response['message'];
        print(message);
      }
    } catch (e) {
      showErrorSnackbar(
        'Error',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void calculateCartCount() {
    cartCount.value = products.fold<int>(
      0,
      (sum, product) =>
          sum + product.skus.where((sku) => sku.cartQty > 0).length,
    );
  }
}
