import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shreeji_dairy/constants/color_constants.dart';
import 'package:shreeji_dairy/styles/font_sizes.dart';
import 'package:shreeji_dairy/styles/text_styles.dart';
import 'package:shreeji_dairy/utils/extensions/app_size_extensions.dart';
import 'package:shreeji_dairy/utils/screen_utils/app_paddings.dart';

class AppTimePickerTextFormField extends StatefulWidget {
  const AppTimePickerTextFormField({
    super.key,
    required this.timeController,
    required this.hintText,
    this.fillColor,
    this.enabled = true,
    this.validator,
    this.onChanged,
  });

  final TextEditingController timeController;
  final String hintText;
  final Color? fillColor;
  final bool enabled;
  final String? Function(String? value)? validator;
  final void Function(String value)? onChanged;

  @override
  State<AppTimePickerTextFormField> createState() =>
      _AppTimePickerTextFormFieldState();
}

class _AppTimePickerTextFormFieldState
    extends State<AppTimePickerTextFormField> {
  void _showCupertinoTimePicker() {
    TimeOfDay currentTime =
        _parseTime(widget.timeController.text) ?? TimeOfDay.now();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        DateTime selectedTime = DateTime(
          2000,
          1,
          1,
          currentTime.hour,
          currentTime.minute,
        );

        return SizedBox(
          height: 0.33.screenHeight,
          child: Column(
            children: [
              // Done Button
              Container(
                color: kColorWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      widget.timeController.text =
                          DateFormat.jm().format(selectedTime);
                    });

                    if (widget.onChanged != null) {
                      widget.onChanged!(widget.timeController.text);
                    }

                    Navigator.pop(context);
                  },
                  child: Text(
                    "Done",
                    style: TextStyles.kRegularFredoka(
                      fontSize: FontSizes.k16FontSize,
                      color: kColorSecondary,
                    ),
                  ),
                ),
              ),

              // Time Picker
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  initialDateTime: selectedTime,
                  use24hFormat: false,
                  onDateTimeChanged: (DateTime newTime) {
                    selectedTime = newTime;
                  },
                  backgroundColor: kColorWhite,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  TimeOfDay? _parseTime(String timeString) {
    try {
      final format = DateFormat.jm();
      final DateTime dateTime = format.parse(timeString);
      return TimeOfDay.fromDateTime(dateTime);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.timeController,
      cursorColor: kColorTextPrimary,
      cursorHeight: 20,
      enabled: widget.enabled,
      validator: widget.validator,
      style: TextStyles.kRegularFredoka(
        fontSize: FontSizes.k16FontSize,
        color: kColorTextPrimary,
      ),
      readOnly: true,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyles.kLightFredoka(
          fontSize: FontSizes.k16FontSize,
          color: kColorGrey,
        ),
        labelText: widget.hintText,
        labelStyle: TextStyles.kLightFredoka(
          fontSize: FontSizes.k16FontSize,
          color: kColorGrey,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        floatingLabelStyle: TextStyles.kMediumFredoka(
          fontSize: FontSizes.k18FontSize,
          color: kColorSecondary,
        ),
        errorStyle: TextStyles.kRegularFredoka(
          fontSize: FontSizes.k16FontSize,
          color: kColorRed,
        ),
        border: outlineInputBorder(
          borderColor: kColorLightGrey,
          borderWidth: 1,
        ),
        focusedBorder: outlineInputBorder(
          borderColor: kColorTextPrimary,
          borderWidth: 1,
        ),
        enabledBorder: outlineInputBorder(
          borderColor: kColorLightGrey,
          borderWidth: 1,
        ),
        errorBorder: outlineInputBorder(
          borderColor: kColorRed,
          borderWidth: 1,
        ),
        contentPadding: AppPaddings.combined(
          horizontal: 16.appWidth,
          vertical: 8.appHeight,
        ),
        filled: true,
        fillColor: widget.fillColor ?? kColorLightGrey,
        suffixIcon: IconButton(
          icon: const Icon(
            Icons.access_time_filled,
            size: 20,
            color: kColorTextPrimary,
          ),
          onPressed: widget.enabled ? _showCupertinoTimePicker : null,
        ),
        suffixIconColor: kColorTextPrimary,
      ),
    );
  }

  OutlineInputBorder outlineInputBorder({
    required Color borderColor,
    required double borderWidth,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: borderColor,
        width: borderWidth,
      ),
    );
  }
}
