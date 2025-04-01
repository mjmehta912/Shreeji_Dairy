import 'package:get/get.dart';
import 'package:shreeji_dairy/features/cart/models/cart_product_dm.dart';
import 'package:shreeji_dairy/features/cart/repositories/cart_repo.dart';
import 'package:shreeji_dairy/features/products/controllers/products_controller.dart';
import 'package:shreeji_dairy/utils/dialogs/app_dialogs.dart';

class CartController extends GetxController {
  var isLoading = false.obs;

  var cartProducts = <CartProductDm>[].obs;

  double get totalAmount {
    return cartProducts.fold(
      0,
      (sum, product) {
        return sum +
            product.skus.fold(
              0,
              (skuSum, sku) {
                return skuSum + (sku.rate * sku.cartQty);
              },
            );
      },
    );
  }

  Future<void> getCartProducts({
    required String pCode,
    String deviceID = '',
    String version = '',
  }) async {
    try {
      isLoading.value = true;

      final fetchedProducts = await CartRepo.getCartProducts(
        pCode: pCode,
        deviceId: deviceID,
        version: version,
      );

      cartProducts.assignAll(fetchedProducts);
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
    required String oldICode,
    required double qty,
    required double rate,
  }) async {
    isLoading.value = true;

    try {
      var response = await CartRepo.addOrUpdateCart(
        pCode: pCode,
        iCode: iCode,
        oldICode: oldICode,
        qty: qty,
        rate: rate,
      );

      if (response != null && response.containsKey('message')) {
        // String message = response['message'];
        // print(message);
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

  final ProductsController productsController = Get.find<ProductsController>();

  Future<void> removeProduct({
    required String pCode,
    required String iCode,
    required String oldICode,
  }) async {
    isLoading.value = true;

    try {
      var response = await CartRepo.removeProduct(
        pCode: pCode,
        iCode: iCode,
        oldICode: oldICode,
      );

      if (response != null && response.containsKey('message')) {
        // String message = response['message'];
        // print(message);

        await getCartProducts(
          pCode: pCode,
        );
        await productsController.searchProduct(
          pCode: pCode,
        );
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
}
