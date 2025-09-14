import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

/// A reusable function to show a platform-aware date picker
Future<DateTime?> showPlatformDatePicker({
  required BuildContext context,
  DateTime? initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  final now = DateTime.now();
  final initDate = initialDate ?? now;
  final startDate = firstDate ?? DateTime(2000);
  final endDate = lastDate ?? DateTime(2100);

  if (isMaterial(context)) {
    // Android / Material
    return showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: startDate,
      lastDate: endDate,
    );
  } else {
    // iOS / Cupertino
    DateTime selectedDate = initDate;

    return await showCupertinoModalPopup<DateTime>(
      context: context,
      useRootNavigator: true,
      builder: (popupContext) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                child: const Text('Done'),
                onPressed: () => Navigator.of(popupContext).pop(selectedDate),
              ),
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: initDate,
                minimumDate: startDate,
                maximumDate: endDate,
                onDateTimeChanged: (DateTime newDate) {
                  selectedDate = newDate;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
