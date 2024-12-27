import 'package:get/get.dart';

class InvoicesController extends GetxController {
  var invoices = <Invoice>[].obs;

  @override
  void onInit() {
    super.onInit();

    invoices.addAll(Invoice.getDummyInvoices());
  }

  void refreshInvoices() {
    invoices.addAll(Invoice.getDummyInvoices());
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

class Invoice {
  final String pname;
  final String invno;
  final String date;
  final double amount;
  final double outstanding;
  final String status;
  final String transport;
  final int yearId;
  final String bookCode;
  final String dbc;
  final int days;
  final String seCode;

  Invoice({
    required this.pname,
    required this.invno,
    required this.date,
    required this.amount,
    required this.outstanding,
    required this.status,
    required this.transport,
    required this.yearId,
    required this.bookCode,
    required this.dbc,
    required this.days,
    required this.seCode,
  });

  static List<Invoice> getDummyInvoices() {
    return [
      Invoice(
        pname: "Honest Group",
        invno: "TX/12345",
        date: "15-Oct-2024",
        amount: 20000,
        outstanding: 0,
        status: "PAID",
        transport: "",
        yearId: 14,
        bookCode: "2000",
        dbc: "SALE",
        days: 100,
        seCode: "S002",
      ),
      Invoice(
        pname: "Saffron Restaurant",
        invno: "TX/09876",
        date: "01-Jan-2024",
        amount: 15000,
        outstanding: 0,
        status: "PAID",
        transport: "Speed Logistics",
        yearId: 14,
        bookCode: "2000",
        dbc: "SALE",
        days: 300,
        seCode: "S003",
      ),
      Invoice(
        pname: "Hillock Ahmedabad",
        invno: "TX/56789",
        date: "10-Nov-2024",
        amount: 42000,
        outstanding: 0,
        status: "PAID",
        transport: "",
        yearId: 14,
        bookCode: "2000",
        dbc: "SALE",
        days: 80,
        seCode: "S004",
      ),
      Invoice(
        pname: "Saffron by Ramada",
        invno: "TX/11223",
        date: "22-Aug-2024",
        amount: 18000,
        outstanding: 0,
        status: "PAID",
        transport: "XYZ Transport Services",
        yearId: 14,
        bookCode: "2000",
        dbc: "SALE",
        days: 150,
        seCode: "H002",
      ),
      Invoice(
        pname: "ITC Maratha",
        invno: "TX/11223",
        date: "22-Aug-2024",
        amount: 18000,
        outstanding: 0,
        status: "PAID",
        transport: "XYZ Transport Services",
        yearId: 14,
        bookCode: "2000",
        dbc: "SALE",
        days: 150,
        seCode: "H002",
      ),
      Invoice(
        pname: "Courtyard Marriot",
        invno: "TX/11223",
        date: "22-Aug-2024",
        amount: 18000,
        outstanding: 0,
        status: "PAID",
        transport: "XYZ Transport Services",
        yearId: 14,
        bookCode: "2000",
        dbc: "SALE",
        days: 150,
        seCode: "H002",
      ),
    ];
  }
}
