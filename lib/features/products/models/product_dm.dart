class ProductDm {
  final String icode;
  final String printName;
  final List<SKUDm> skus;

  ProductDm({
    required this.icode,
    required this.printName,
    required this.skus,
  });

  factory ProductDm.fromJson(Map<String, dynamic> json) {
    return ProductDm(
      icode: json['icode'] ?? '',
      printName: json['printname'] ?? '',
      skus: (json['sku'] as List<dynamic>?)
              ?.map(
                (sku) => SKUDm.fromJson(sku),
              )
              .toList() ??
          [],
    );
  }
}

class SKUDm {
  final String skuIcode;
  final String skuName;
  final String pack;
  final double rate;
  final int cartQty;

  SKUDm({
    required this.skuIcode,
    required this.skuName,
    required this.pack,
    required this.rate,
    required this.cartQty,
  });

  factory SKUDm.fromJson(Map<String, dynamic> json) {
    return SKUDm(
      skuIcode: json['skuicode'] ?? '',
      skuName: json['skuiname'] ?? '',
      pack: json['pack'] ?? '',
      rate: (json['rate'] ?? 0).toDouble(),
      cartQty: json['cartQty'] ?? 0,
    );
  }
}
