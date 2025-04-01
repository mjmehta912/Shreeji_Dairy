class CartProductDm {
  final String icode;
  final String printName;
  final String oldICode;
  final List<CartSKUDm> skus;

  CartProductDm({
    required this.icode,
    required this.printName,
    required this.oldICode,
    required this.skus,
  });

  factory CartProductDm.fromJson(Map<String, dynamic> json) {
    return CartProductDm(
      icode: json['icode'] ?? '',
      printName: json['printname'] ?? '',
      oldICode: json['old_Icode'] ?? '',
      skus: (json['sku'] as List<dynamic>?)
              ?.map(
                (sku) => CartSKUDm.fromJson(sku),
              )
              .toList() ??
          [],
    );
  }
}

class CartSKUDm {
  final String skuIcode;
  final String oldSkuICode;
  final String skuName;
  final String pack;
  final double rate;
  final double cartQty;

  CartSKUDm({
    required this.skuIcode,
    required this.oldSkuICode,
    required this.skuName,
    required this.pack,
    required this.rate,
    required this.cartQty,
  });

  factory CartSKUDm.fromJson(Map<String, dynamic> json) {
    return CartSKUDm(
      skuIcode: json['skuicode'] ?? '',
      oldSkuICode: json['skuOld_Icode'] ?? '',
      skuName: json['skuiname'] ?? '',
      pack: json['pack'] ?? '',
      rate: (json['rate'] ?? 0).toDouble(),
      cartQty: json['cartQty'] ?? 0,
    );
  }
}
