import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/bottom_nav/controllers/bottom_nav_controller.dart';
import 'package:shreeji_dairy/features/invoice/invoices/screens/invoices_screen.dart';
import 'package:shreeji_dairy/features/ledger/screens/ledger_screen.dart';
import 'package:shreeji_dairy/features/products/screens/products_screen.dart';
import 'package:shreeji_dairy/features/profile/screens/profile_screen.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({
    super.key,
    required this.pCode,
    required this.pName,
    required this.cCode,
    required this.deliDateOption,
    this.branchCode,
    this.branchName,
  });

  final String pCode;
  final String pName;
  final String cCode;
  final String deliDateOption;
  final String? branchCode;
  final String? branchName;

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  final BottomNavController _controller = Get.put(BottomNavController());

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await _controller.getUserAccess();

    // Set initial index: If product access is available, start with Products, otherwise start with Services.
    _controller.selectedIndex.value =
        _controller.ledgerDate.value.product ? 0 : 3;
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys =
      List.generate(4, (_) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _getPage(_controller.selectedIndex.value)),
      extendBody: true,
      bottomNavigationBar: Obx(() => _buildBottomNavigationBar()),
    );
  }

  /// Returns the appropriate page based on index
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return ProductsScreen(
          pCode: widget.pCode,
          pName: widget.pName,
          cCode: widget.cCode,
          branchCode: widget.branchCode!,
          deliDateOption: widget.deliDateOption,
        );
      case 1:
        return InvoicesScreen(
          pCode: widget.pCode,
          pName: widget.pName,
        );
      case 2:
        return LedgerScreen(
          pCode: widget.pCode,
          pName: widget.pName,
        );
      default:
        return ProfileScreen(
          pCode: widget.pCode,
          pName: widget.pName,
          cCode: widget.cCode,
          branchCode: widget.branchCode!,
          deliDateOption: widget.deliDateOption,
        );
    }
  }

  /// Builds the bottom navigation bar
  Widget _buildBottomNavigationBar() {
    return Container(
      margin: AppPaddings.p16,
      padding: AppPaddings.p8,
      decoration: BoxDecoration(
        color: kColorWhite,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: kColorBlackWithOpacity,
            blurRadius: 8,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: kIconHome,
            iconFilled: kIconHomeFilled,
            label: 'Products',
            index: 0,
            hasAccess: _controller.ledgerDate.value.product,
          ),
          _buildNavItem(
            icon: kIconBill,
            iconFilled: kIconBillFilled,
            label: 'Invoices',
            index: 1,
            hasAccess: _controller.ledgerDate.value.invoice,
          ),
          _buildNavItem(
            icon: kIconLedger,
            iconFilled: kIconLedgerFilled,
            label: 'Ledger',
            index: 2,
            hasAccess: _controller.ledgerDate.value.ledger,
          ),
          _buildNavItem(
            icon: kIconSettings,
            iconFilled: kIconSettingsFilled,
            label: 'Services',
            index: 3,
            hasAccess: true, // Always available
          ),
        ],
      ),
    );
  }

  /// Builds individual navigation items with access control
  Widget _buildNavItem({
    required String icon,
    required String iconFilled,
    required String label,
    required int index,
    required bool hasAccess,
  }) {
    return InkWell(
      onTap: () {
        if (hasAccess) {
          _controller.changeIndex(index);
          _navigatorKeys[index].currentState?.pushReplacementNamed('/');
        } else {
          _showAccessDeniedDialog(label);
        }
      },
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        padding: AppPaddings.p4,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              _controller.selectedIndex.value == index ? iconFilled : icon,
              height: _controller.selectedIndex.value == index ? 22 : 18,
              colorFilter: ColorFilter.mode(
                _controller.selectedIndex.value == index
                    ? kColorSecondary
                    : kColorGrey,
                BlendMode.srcIn,
              ),
            ),
            AppSpaces.v4,
            Text(
              label,
              style: _controller.selectedIndex.value == index
                  ? TextStyles.kRegularFredoka(
                      color: kColorSecondary,
                      fontSize: FontSizes.k12FontSize,
                    )
                  : TextStyles.kLightFredoka(
                      color: kColorGrey,
                      fontSize: FontSizes.k12FontSize,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows an error dialog when access is denied
  void _showAccessDeniedDialog(String label) {
    Get.defaultDialog(
      contentPadding: AppPaddings.p20,
      title: "Access Denied",
      titleStyle: TextStyles.kMediumFredoka(
        fontSize: FontSizes.k22FontSize,
        color: kColorTextPrimary,
      ),
      content: Text(
        "You don’t have access to $label.",
        style: TextStyles.kRegularFredoka(
          fontSize: FontSizes.k16FontSize,
          color: kColorTextPrimary,
        ),
      ),
      confirm: AppButton(
        buttonWidth: 0.2.screenWidth,
        buttonHeight: 40,
        title: 'OK',
        onPressed: () {
          Get.back();
        },
      ),
    );
  }
}
