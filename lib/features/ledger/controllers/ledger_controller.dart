import 'package:get/get.dart';

class LedgerController extends GetxController {
  var isLoading = false.obs;

  var ledgerEntries = <LedgerEntry>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Load dummy data into the ledgerEntries list
    ledgerEntries.addAll(LedgerEntry.getDummyData());
  }

  // Refresh or fetch data
  void refreshLedgerData() {
    ledgerEntries.clear();
    ledgerEntries.addAll(LedgerEntry.getDummyData());
  }

  var selectedCustomer = ''.obs;
  var customers = <String>[
    'Customer 1',
    'Customer 2',
    'Customer 3',
    'Customer 4',
    'Customer 5',
    'Customer 6',
  ].obs;

  void onCustomerSelected(String customer) {
    selectedCustomer.value = customer;
  }
}

class LedgerEntry {
  final String date;
  final String invno;
  final String dbc;
  final String remarks;
  final String pname;
  final String pcode;
  final double debit;
  final double credit;
  final String balance;
  final String pnamec;
  final String pcodec;
  final String yearId;
  final String bookCode;
  final bool isParent;

  LedgerEntry({
    required this.date,
    required this.invno,
    required this.dbc,
    required this.remarks,
    required this.pname,
    required this.pcode,
    required this.debit,
    required this.credit,
    required this.balance,
    required this.pnamec,
    required this.pcodec,
    required this.yearId,
    required this.bookCode,
    required this.isParent,
  });

  factory LedgerEntry.fromJson(Map<String, dynamic> json) {
    return LedgerEntry(
      date: json['DATE'] ?? '',
      invno: json['INVNO'] ?? '',
      dbc: json['DBC'] ?? '',
      remarks: json['REMARKS'] ?? '',
      pname: json['pname'] ?? '',
      pcode: json['PCODE'] ?? '',
      debit: (json['Debit'] as num?)?.toDouble() ?? 0.0,
      credit: (json['Credit'] as num?)?.toDouble() ?? 0.0,
      balance: json['BALANCE'] ?? '',
      pnamec: json['PNAMEC'] ?? '',
      pcodec: json['PCODEC'] ?? '',
      yearId: json['YEARID'] ?? '',
      bookCode: json['BOOKCODE'] ?? '',
      isParent: json['isParent'] ?? false,
    );
  }

  static List<LedgerEntry> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => LedgerEntry.fromJson(json)).toList();
  }

  static List<LedgerEntry> getDummyData() {
    return [
      LedgerEntry(
        date: "3/31/2022 12:00:00 AM",
        invno: "HO22/00000763",
        dbc: "",
        remarks: "OPENING",
        pname: "Honest Group",
        pcode: "",
        debit: 838.00,
        credit: 0.00,
        balance: "838.00",
        pnamec: "HDFC BANK-6165 ( R.K.)",
        pcodec: "H00001",
        yearId: "0",
        bookCode: "",
        isParent: true,
      ),
      LedgerEntry(
        date: "8/10/2022 12:00:00 AM",
        invno: "CH22GST/01400",
        dbc: "PAYMENT",
        remarks: "FULL PAYMENT",
        pname: "Honest Group",
        pcode: "A00217",
        debit: 5000.00,
        credit: 0.00,
        balance: "10,147.00",
        pnamec: "SBI BANK-7777 ( R.L.)",
        pcodec: "S00777",
        yearId: "11",
        bookCode: "3000",
        isParent: true,
      ),
      LedgerEntry(
        date: "9/30/2022 12:00:00 AM",
        invno: "CH22GST/01500",
        dbc: "SALE",
        remarks: "LATE PAYMENT",
        pname: "Elite Group",
        pcode: "A00321",
        debit: 8000.00,
        credit: 0.00,
        balance: "18,147.00",
        pnamec: "AXIS BANK-3333 ( T.M.)",
        pcodec: "A00333",
        yearId: "12",
        bookCode: "4000",
        isParent: true,
      ),
      LedgerEntry(
        date: "6/24/2022 12:00:00 AM",
        invno: "HO22/00000763",
        dbc: "BNKR",
        remarks: "VIKRAM",
        pname: "Honest Group",
        pcode: "A00217",
        debit: 0.00,
        credit: 5000.00,
        balance: "8,147.00",
        pnamec: "HDFC BANK-6165 ( R.K.)",
        pcodec: "H00087",
        yearId: "9",
        bookCode: "1044",
        isParent: true,
      ),
      LedgerEntry(
        date: "1/1/1900 12:00:00 AM",
        invno: "HO22/00000763",
        dbc: "",
        remarks: "",
        pname: "",
        pcode: "",
        debit: 10000.00,
        credit: 0.00,
        balance: "1,50,000.00",
        pnamec: "SALE | CH21GST/03137 | Oct 20, 21 | 838.00",
        pcodec: "",
        yearId: "0",
        bookCode: "",
        isParent: false,
      ),
      LedgerEntry(
        date: "6/24/2022 12:00:00 AM",
        invno: "CH22GST/01300",
        dbc: "SALE",
        remarks: "OK / P",
        pname: "Honest Group",
        pcode: "A00217",
        debit: 12309.00,
        credit: 0.00,
        balance: "13,147.00",
        pnamec: "HDFC BANK-1234 ( S.D.)",
        pcodec: "H00123",
        yearId: "9",
        bookCode: "1000",
        isParent: true,
      ),
      LedgerEntry(
        date: "7/15/2022 12:00:00 AM",
        invno: "CH22GST/01310",
        dbc: "REFUND",
        remarks: "PARTIAL REFUND",
        pname: "Trust Group",
        pcode: "A00512",
        debit: 0.00,
        credit: 8000.00,
        balance: "5,147.00",
        pnamec: "ICICI BANK-8888 ( K.K.)",
        pcodec: "I00245",
        yearId: "10",
        bookCode: "2000",
        isParent: true,
      ),
    ];
  }
}
