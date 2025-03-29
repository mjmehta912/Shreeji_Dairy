class UserAccessDm {
  final List<MenuAccessDm> menuAccess;
  final LedgerDateDm ledgerDate;

  UserAccessDm({
    required this.menuAccess,
    required this.ledgerDate,
  });

  factory UserAccessDm.fromJson(Map<String, dynamic> json) {
    return UserAccessDm(
      menuAccess: (json['menuAceess'] as List)
          .map((item) => MenuAccessDm.fromJson(item))
          .toList(),
      ledgerDate: LedgerDateDm.fromJson(json['data']),
    );
  }
}

class MenuAccessDm {
  final int menuId;
  final String menuName;
  bool access;
  final List<SubMenuAccessDm> subMenu;

  MenuAccessDm({
    required this.menuId,
    required this.menuName,
    required this.access,
    required this.subMenu,
  });

  factory MenuAccessDm.fromJson(Map<String, dynamic> json) {
    return MenuAccessDm(
      menuId: json['menuid'],
      menuName: json['menuname'],
      access: json['access'],
      subMenu: json['subMenu'] != null
          ? (json['subMenu'] as List)
              .map((item) => SubMenuAccessDm.fromJson(item))
              .toList()
          : [], // Handle null subMenu case
    );
  }
}

class SubMenuAccessDm {
  final int subMenuId;
  final String subMenuName;
  bool subMenuAccess;

  SubMenuAccessDm({
    required this.subMenuId,
    required this.subMenuName,
    required this.subMenuAccess,
  });

  factory SubMenuAccessDm.fromJson(Map<String, dynamic> json) {
    return SubMenuAccessDm(
      subMenuId: json['submenuid'],
      subMenuName: json['submenuname'],
      subMenuAccess: json['subMenuAccess'],
    );
  }
}

class LedgerDateDm {
  final String ledgerStart;
  final String ledgerEnd;
  bool product;
  bool invoice;
  bool ledger;

  LedgerDateDm({
    required this.ledgerStart,
    required this.ledgerEnd,
    required this.product,
    required this.invoice,
    required this.ledger,
  });

  factory LedgerDateDm.fromJson(Map<String, dynamic> json) {
    return LedgerDateDm(
      ledgerStart: json['ledgerStart'] ?? '',
      ledgerEnd: json['ledgerEnd'] ?? '',
      product: json['Product'],
      invoice: json['Invoice'],
      ledger: json['Ledger'],
    );
  }
}
