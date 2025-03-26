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
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';

class BottomNavScreen extends StatelessWidget {
  BottomNavScreen({
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
  final BottomNavController _controller = Get.put(
    BottomNavController(),
  );

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  List<Widget> get pages => [
        ProductsScreen(
          pCode: pCode,
          pName: pName,
          cCode: cCode,
          branchCode: branchCode!,
          deliDateOption: deliDateOption,
        ),
        InvoicesScreen(
          pCode: pCode,
          pName: pName,
        ),
        LedgerScreen(
          pCode: pCode,
          pName: pName,
        ),
        ProfileScreen(
          pCode: pCode,
          pName: pName,
          branchCode: branchCode!,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => pages[_controller.selectedIndex.value],
      ),
      extendBody: true,
      bottomNavigationBar: Obx(
        () => Container(
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
                isSelected: _controller.selectedIndex.value == 0,
                onTap: () {
                  _controller.changeIndex(0);
                  _navigatorKeys[0].currentState?.pushReplacementNamed('/');
                },
              ),
              _buildNavItem(
                icon: kIconBill,
                iconFilled: kIconBillFilled,
                label: 'Invoices',
                index: 1,
                isSelected: _controller.selectedIndex.value == 1,
                onTap: () {
                  _controller.changeIndex(1);
                  _navigatorKeys[1].currentState?.pushReplacementNamed('/');
                },
              ),
              _buildNavItem(
                icon: kIconLedger,
                iconFilled: kIconLedgerFilled,
                label: 'Ledger',
                index: 2,
                isSelected: _controller.selectedIndex.value == 2,
                onTap: () {
                  _controller.changeIndex(2);
                  _navigatorKeys[2].currentState?.pushReplacementNamed('/');
                },
              ),
              _buildNavItem(
                icon: kIconSettings,
                iconFilled: kIconSettingsFilled,
                label: 'Services',
                index: 3,
                isSelected: _controller.selectedIndex.value == 3,
                onTap: () {
                  _controller.changeIndex(3);
                  _navigatorKeys[3].currentState?.pushReplacementNamed('/');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String iconFilled,
    required String label,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
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
              isSelected ? iconFilled : icon,
              height: isSelected ? 22 : 18,
              colorFilter: ColorFilter.mode(
                isSelected ? kColorSecondary : kColorGrey,
                BlendMode.srcIn,
              ),
            ),
            AppSpaces.v4,
            Text(
              label,
              style: isSelected
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
}
