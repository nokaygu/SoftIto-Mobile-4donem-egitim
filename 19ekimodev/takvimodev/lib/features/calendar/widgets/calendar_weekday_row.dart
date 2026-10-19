import 'package:flutter/material.dart';

import '../../../core/utils/calendar_date_utils.dart';

/// Haftanın günlerini (`Pzt` - `Paz`) 7 sütunlu şık ve hafif soluk başlık satırı olarak çizer.
class CalendarWeekdayRow extends StatelessWidget {
  const CalendarWeekdayRow({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: CalendarDateUtils.shortWeekdayNames
            .map(
              (dayLabel) => Expanded(
                child: Center(
                  child: Text(dayLabel, style: theme.textTheme.titleSmall),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}
