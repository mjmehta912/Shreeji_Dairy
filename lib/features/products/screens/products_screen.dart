import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/constants/image_constants.dart';
import 'package:shreeji_dairy/features/products/controllers/products_controller.dart';
import 'package:shreeji_dairy/features/products/screens/cart_screen.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_button.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';
import 'package:badges/badges.dart' as badges;

class ProductsScreen extends StatelessWidget {
  ProductsScreen({super.key});

  final ProductsController _controller = Get.put(ProductsController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: kColorWhite,
        appBar: AppAppbar(
          title: 'Products',
          actions: [
            Obx(
              () {
                // If there are items in the cart, show the badge; otherwise, show an empty icon button
                return Padding(
                  padding: AppPaddings.ph6,
                  child: GestureDetector(
                    onTap: () {
                      // Navigate to the cart screen when the badge or icon is clicked
                      Get.to(() => CartScreen());
                    },
                    child: _controller.cartItems.isEmpty
                        ? IconButton(
                            onPressed: () {
                              Get.to(() => CartScreen());
                            },
                            icon: SvgPicture.asset(
                              kIconShoppingCart,
                              height: 20,
                              colorFilter: ColorFilter.mode(
                                kColorTextPrimary,
                                BlendMode.srcIn,
                              ),
                            ),
                          )
                        : badges.Badge(
                            badgeContent: Text(
                              '${_controller.cartItems.length}',
                              style: TextStyles.kMediumFredoka(
                                fontSize: FontSizes.k12FontSize,
                                color: kColorWhite,
                              ),
                            ),
                            badgeStyle: badges.BadgeStyle(
                              badgeColor: kColorTextPrimary,
                              padding: AppPaddings.p6,
                            ),
                            position: badges.BadgePosition.topEnd(
                              top: 0,
                              end: 0,
                            ),
                            child: IconButton(
                              onPressed: () {
                                Get.to(() => CartScreen());
                              },
                              icon: SvgPicture.asset(
                                kIconShoppingCart,
                                height: 20,
                                colorFilter: ColorFilter.mode(
                                  kColorTextPrimary,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
        body: Padding(
          padding: AppPaddings.custom(
            top: 15.appHeight,
            left: 15.appWidth,
            right: 15.appWidth,
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                    height: 0.15.screenHeight,
                    autoPlay: true,
                    autoPlayCurve: Curves.easeInOut,
                    autoPlayAnimationDuration: Duration(
                      seconds: 1,
                    ),
                    enlargeCenterPage: true,
                    viewportFraction: 1.0,
                  ),
                  itemCount: _controller.imagePaths.length,
                  itemBuilder: (context, index, _) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        _controller.imagePaths[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 0.15.screenHeight,
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: AppSpaces.v10,
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SearchBarAndChipsDelegate(
                  child: Container(
                    color: kColorWhite,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextFormField(
                          controller: _controller.searchController,
                          hintText: 'Search',
                        ),
                        AppSpaces.v10,
                        Obx(
                          () => SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: _controller.reorderedFilterOptions.map(
                                (filter) {
                                  return Padding(
                                    padding: AppPaddings.custom(
                                      right: 8.appWidth,
                                    ),
                                    child: FilterChip(
                                      padding: EdgeInsets.all(0),
                                      label: Text(
                                        filter,
                                        style: TextStyles.kRegularFredoka(
                                          fontSize: FontSizes.k14FontSize,
                                          color: _controller.selectedFilters
                                                  .contains(filter)
                                              ? kColorWhite
                                              : kColorTextPrimary,
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      disabledColor: kColorWhite,
                                      backgroundColor: kColorWhite,
                                      showCheckmark: false,
                                      selectedColor: kColorSecondary,
                                      selected: _controller.selectedFilters
                                          .contains(filter),
                                      onSelected: (isSelected) {
                                        _controller.toggleFilter(filter);
                                      },
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Obx(
                      () => Column(
                        children: [
                          Card(
                            elevation: 2.5,
                            color: kColorWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: kColorBlack,
                              ),
                            ),
                            child: Padding(
                              padding: AppPaddings.combined(
                                horizontal: 10.appWidth,
                                vertical: 5.appHeight,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Card(
                                        color: kColorWhite,
                                        clipBehavior: Clip.antiAlias,
                                        child: Image.asset(
                                          _controller.products[index].image,
                                          height: 75.appHeight,
                                        ),
                                      ),
                                      AppSpaces.h10,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _controller.products[index].name,
                                              style: TextStyles.kMediumFredoka(
                                                fontSize: FontSizes.k18FontSize,
                                              ).copyWith(
                                                height: 1,
                                              ),
                                            ),
                                            AppSpaces.v10,
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: _controller
                                                    .products[index].skus
                                                    .map(
                                                  (sku) {
                                                    return Card(
                                                      color: kColorWhite,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        side: BorderSide(
                                                          color:
                                                              kColorTextPrimary,
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding: AppPaddings
                                                            .combined(
                                                          horizontal: 10,
                                                          vertical: 5,
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              sku.size,
                                                              style: TextStyles
                                                                  .kMediumFredoka(
                                                                fontSize: FontSizes
                                                                    .k14FontSize,
                                                              ).copyWith(
                                                                height: 1,
                                                              ),
                                                            ),
                                                            AppSpaces.v4,
                                                            Text(
                                                              '₹ ${sku.rate}',
                                                              style: TextStyles
                                                                  .kRegularFredoka(
                                                                fontSize: FontSizes
                                                                    .k14FontSize,
                                                              ).copyWith(
                                                                height: 1,
                                                              ),
                                                            ),
                                                            AppSpaces.v4,
                                                            Obx(
                                                              () => sku.counter
                                                                          .value ==
                                                                      0
                                                                  ? SizedBox(
                                                                      width: 0.2
                                                                          .screenWidth,
                                                                      height:
                                                                          30,
                                                                      child:
                                                                          AppButton(
                                                                        onPressed:
                                                                            () {
                                                                          _controller.incrementCounter(
                                                                              _controller.products[index],
                                                                              sku);
                                                                        },
                                                                        title:
                                                                            'Add +',
                                                                        titleSize:
                                                                            FontSizes.k14FontSize,
                                                                        buttonColor:
                                                                            kColorWhite,
                                                                        borderColor:
                                                                            kColorSecondary,
                                                                        titleColor:
                                                                            kColorSecondary,
                                                                      ),
                                                                    )
                                                                  : Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        InkWell(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          child:
                                                                              Icon(
                                                                            Icons.remove,
                                                                            color:
                                                                                kColorSecondary,
                                                                            size:
                                                                                20,
                                                                          ),
                                                                          onTap: () => _controller.decrementCounter(
                                                                              _controller.products[index],
                                                                              sku),
                                                                        ),
                                                                        AppSpaces
                                                                            .h10,
                                                                        Text(
                                                                          '${sku.counter.value}',
                                                                          style:
                                                                              TextStyles.kMediumFredoka(
                                                                            fontSize:
                                                                                FontSizes.k16FontSize,
                                                                            color:
                                                                                kColorTextPrimary,
                                                                          ),
                                                                        ),
                                                                        AppSpaces
                                                                            .h10,
                                                                        InkWell(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          child:
                                                                              Icon(
                                                                            Icons.add,
                                                                            color:
                                                                                kColorSecondary,
                                                                            size:
                                                                                20,
                                                                          ),
                                                                          onTap: () => _controller.incrementCounter(
                                                                              _controller.products[index],
                                                                              sku),
                                                                        ),
                                                                      ],
                                                                    ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AppSpaces.v6,
                        ],
                      ),
                    );
                  },
                  childCount: _controller.products.length,
                ),
              ),
              SliverToBoxAdapter(
                child: AppSpaces.v60,
              ),
              SliverToBoxAdapter(
                child: AppSpaces.v10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBarAndChipsDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SearchBarAndChipsDelegate({
    required this.child,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 100.appHeight;
  @override
  double get minExtent => 100.appHeight;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
