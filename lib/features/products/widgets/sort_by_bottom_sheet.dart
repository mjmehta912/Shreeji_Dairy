import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shreeji_dairy/features/products/controllers/products_controller.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';

class SortOptionsBottomSheet extends StatelessWidget {
  final Function(SortCriteria) onSortSelected;

  const SortOptionsBottomSheet({
    super.key,
    required this.onSortSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Sort By',
            style: TextStyles.kMediumFredoka(),
          ),
          const SizedBox(height: 16),
          ...SortCriteria.values.map(
            (criteria) {
              return ListTile(
                title: Text(
                  criteria.toString().split('.').last.replaceAll('_', ' '),
                  style: TextStyles.kRegularFredoka(
                    fontSize: FontSizes.k16FontSize,
                  ),
                ),
                onTap: () {
                  onSortSelected(criteria);
                  Get.back();
                },
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}
