import 'package:get/get.dart';
import 'package:shreeji_dairy/features/products/models/product.dart';

class CartItem {
  final Product product;
  final Sku sku;
  RxInt quantity;

  CartItem({
    required this.product,
    required this.sku,
    required this.quantity,
  });
}
