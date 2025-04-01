class AllItemDm {
  final String icode;
  final String oldIcode;
  final String printName;
  final List<ItemSkuDm> skus;

  AllItemDm({
    required this.icode,
    required this.oldIcode,
    required this.printName,
    required this.skus,
  });

  factory AllItemDm.fromJson(Map<String, dynamic> json) {
    return AllItemDm(
      icode: json['icode'] ?? '',
      oldIcode: json['old_Icode'] ?? '',
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
  final String oldSkuIcode;
  final String skuName;
  final String pack;

  ItemSkuDm({
    required this.skuIcode,
    required this.oldSkuIcode,
    required this.skuName,
    required this.pack,
  });

  factory ItemSkuDm.fromJson(Map<String, dynamic> json) {
    return ItemSkuDm(
      skuIcode: json['skuicode'] ?? '',
      oldSkuIcode: json['skuOld_Icode'] ?? '',
      skuName: json['skuiname'] ?? '',
      pack: json['pack'] ?? '',
    );
  }
}
