class AllItemDm {
  final String icode;
  final String printName;
  final List<ItemSkuDm> skus;

  AllItemDm({
    required this.icode,
    required this.printName,
    required this.skus,
  });

  factory AllItemDm.fromJson(Map<String, dynamic> json) {
    return AllItemDm(
      icode: json['icode'] ?? '',
      printName: json['printname'] ?? '',
      skus: (json['sku'] as List<dynamic>?)
              ?.map(
                (sku) => ItemSkuDm.fromJson(sku),
              )
              .toList() ??
          [],
    );
  }
}

class ItemSkuDm {
  final String skuIcode;
  final String skuName;
  final String pack;

  ItemSkuDm({
    required this.skuIcode,
    required this.skuName,
    required this.pack,
  });

  factory ItemSkuDm.fromJson(Map<String, dynamic> json) {
    return ItemSkuDm(
      skuIcode: json['skuicode'] ?? '',
      skuName: json['skuiname'] ?? '',
      pack: json['pack'] ?? '',
    );
  }
}
