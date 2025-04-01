class ProductDm {
  final String icode;
  final String oldICode;
  final String printName;
  final List<SKUDm> skus;

  ProductDm({
    required this.icode,
    required this.oldICode,
    required this.printName,
    required this.skus,
  });

  factory ProductDm.fromJson(Map<String, dynamic> json) {
    return ProductDm(
      icode: json['icode'] ?? '',
      oldICode: json['old_Icode'] ?? '',
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
  final String skuOldICode;
  final String skuName;
  final String pack;
  final double rate;
  final double cartQty;

  SKUDm({
    required this.skuIcode,
    required this.skuOldICode,
    required this.skuName,
    required this.pack,
    required this.rate,
    required this.cartQty,
  });

  factory SKUDm.fromJson(Map<String, dynamic> json) {
    return SKUDm(
      skuIcode: json['skuicode'] ?? '',
      skuOldICode: json['skuOld_Icode'] ?? '',
      skuName: json['skuiname'] ?? '',
      pack: json['pack'] ?? '',
      rate: (json['rate'] ?? 0).toDouble(),
      cartQty: json['cartQty'],
    );
  }
}
