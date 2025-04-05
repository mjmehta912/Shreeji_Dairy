class UserTypeAccessDm {
  final List<UserTypeMenuAccessDm> menuAccess;
  final UserTypeLedgerDateDm ledgerDate;

  UserTypeAccessDm({
    required this.menuAccess,
    required this.ledgerDate,
  });

  factory UserTypeAccessDm.fromJson(Map<String, dynamic> json) {
    return UserTypeAccessDm(
      menuAccess: (json['menuAceess'] as List)
          .map(
            (item) => UserTypeMenuAccessDm.fromJson(item),
          )
          .toList(),
      ledgerDate: UserTypeLedgerDateDm.fromJson(json['data']),
    );
  }
}

class UserTypeMenuAccessDm {
  final int menuId;
  final String menuName;
  final String menuDtl;
  bool access;
  final List<UserTypeSubMenuAccessDm> subMenu;

  UserTypeMenuAccessDm({
    required this.menuId,
    required this.menuName,
    required this.menuDtl,
    required this.access,
    required this.subMenu,
  });

  factory UserTypeMenuAccessDm.fromJson(Map<String, dynamic> json) {
    return UserTypeMenuAccessDm(
      menuId: json['menuid'],
      menuName: json['menuname'],
      menuDtl: json['menuDtl'],
      access: json['access'],
      subMenu: json['subMenu'] != null
          ? (json['subMenu'] as List)
              .map(
                (item) => UserTypeSubMenuAccessDm.fromJson(item),
              )
              .toList()
          : [],
    );
  }
}

class UserTypeSubMenuAccessDm {
  final int subMenuId;
  final String subMenuName;
  final String subMenuDtl;
  bool subMenuAccess;

  UserTypeSubMenuAccessDm({
    required this.subMenuId,
    required this.subMenuName,
    required this.subMenuDtl,
    required this.subMenuAccess,
  });

  factory UserTypeSubMenuAccessDm.fromJson(Map<String, dynamic> json) {
    return UserTypeSubMenuAccessDm(
      subMenuId: json['submenuid'],
      subMenuName: json['submenuname'],
      subMenuDtl: json['subMenuDtl'],
      subMenuAccess: json['subMenuAccess'],
    );
  }
}

class UserTypeLedgerDateDm {
  final String ledgerStart;
  final String ledgerEnd;
  bool product;
  bool invoice;
  bool ledger;
  final String productDtl;
  final String invoiceDtl;
  final String ledgerDtl;

  UserTypeLedgerDateDm({
    required this.ledgerStart,
    required this.ledgerEnd,
    required this.product,
    required this.invoice,
    required this.ledger,
    required this.productDtl,
    required this.invoiceDtl,
    required this.ledgerDtl,
  });

  factory UserTypeLedgerDateDm.fromJson(Map<String, dynamic> json) {
    return UserTypeLedgerDateDm(
      ledgerStart: json['LedgerStart'] ?? '',
      ledgerEnd: json['LedgerEnd'] ?? '',
      product: json['Product'] ?? false,
      invoice: json['Invoice'] ?? false,
      ledger: json['Ledger'] ?? false,
      productDtl: json['ProductDtl'] ?? '',
      invoiceDtl: json['InvoiceDtl'] ?? '',
      ledgerDtl: json['LedgerDtl'] ?? '',
    );
  }
}
