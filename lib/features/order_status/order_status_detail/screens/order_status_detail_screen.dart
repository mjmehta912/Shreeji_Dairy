import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/features/order_status/order_status_detail/controllers/order_status_detail_controller.dart';
import 'package:shreeji_dairy/features/order_status/order_status_detail/widgets/order_status_detail_card.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_spacings.dart';
import 'package:shreeji_dairy/widgets/app_appbar.dart';
import 'package:shreeji_dairy/widgets/app_loading_overlay.dart';
import 'package:shreeji_dairy/widgets/app_text_form_field.dart';

class OrderStatusDetailScreen extends StatefulWidget {
  const OrderStatusDetailScreen({
    super.key,
    required this.invNo,
  });

  final String invNo;

  @override
  State<OrderStatusDetailScreen> createState() =>
      _OrderStatusDetailScreenState();
}

class _OrderStatusDetailScreenState extends State<OrderStatusDetailScreen> {
  final OrderStatusDetailController _controller = Get.put(
    OrderStatusDetailController(),
  );

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    await _controller.getOrderDetails(
      invNo: widget.invNo,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            backgroundColor: kColorWhite,
            appBar: AppAppbar(
              title: widget.invNo,
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 25,
                  color: kColorTextPrimary,
                ),
              ),
            ),
            body: Padding(
              padding: AppPaddings.p10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextFormField(
                    controller: _controller.searchController,
                    hintText: 'Search',
                    onChanged: _controller.searchOrderDetails,
                  ),
                  AppSpaces.v10,
                  _buildFilterChips(),
                  AppSpaces.v10,
                  Obx(
                    () {
                      if (_controller.filteredOrderDetails.isEmpty &&
                          !_controller.isLoading.value) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'No order details found.',
                              style: TextStyles.kRegularFredoka(),
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: _controller.filteredOrderDetails.length,
                          itemBuilder: (context, index) {
                            final orderDetail =
                                _controller.filteredOrderDetails[index];

                            return OrderStatusDetailCard(
                              orderDetail: orderDetail,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Obx(
          () => AppLoadingOverlay(
            isLoading: _controller.isLoading.value,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Obx(
      () {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: OrderFilterType.values.map(
              (filter) {
                final isSelected = _controller.selectedFilter.value == filter;
                final label = _getFilterLabel(filter);

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(
                      label,
                      style: TextStyles.kRegularFredoka(
                        fontSize: FontSizes.k14FontSize,
                        color: isSelected ? kColorWhite : kColorTextPrimary,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => _controller.changeFilter(filter),
                    showCheckmark: false,
                    backgroundColor: kColorWhite,
                    selectedColor: kColorSecondary,
                    side: BorderSide(
                      color: kColorSecondary,
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }

  String _getFilterLabel(OrderFilterType filter) {
    switch (filter) {
      case OrderFilterType.pending:
        return "Pending";
      case OrderFilterType.delivered:
        return "Delivered";
      default:
        return "All";
    }
  }
}
