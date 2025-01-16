class StoreCategoryDm {
  final String icname;
  final List<StoreProductDm> products;

  StoreCategoryDm({
    required this.icname,
    required this.products,
  });

  factory StoreCategoryDm.fromJson(Map<String, dynamic> json) {
    return StoreCategoryDm(
      icname: json['icname'] as String,
      products: (json['products'] as List<dynamic>)
          .map(
            (e) => StoreProductDm.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class StoreProductDm {
  final String printname;
  final String? pack;
  int cartQty;
  final String icode;
  final double rate;

  StoreProductDm({
    required this.printname,
    this.pack,
    required this.cartQty,
    required this.icode,
    required this.rate,
  });

  factory StoreProductDm.fromJson(Map<String, dynamic> json) {
    return StoreProductDm(
      printname: json['printname'] as String,
      pack: json['pack'] as String?,
      cartQty: json['cartQty'] as int,
      icode: json['icode'] as String,
      rate: (json['rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'printname': printname,
      'pack': pack,
      'cartQty': cartQty,
      'icode': icode,
      'rate': rate,
    };
  }
}
