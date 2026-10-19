import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'core/utils/calendar_date_utils.dart';
import 'features/calendar/controllers/calendar_controller.dart';
import 'features/calendar/views/calendar_view.dart';
import 'features/diary/controllers/diary_controller.dart';
import 'features/diary/models/diary_model.dart';
import 'features/diary/views/diary_day_summary_view.dart';
import 'features/diary/views/diary_editor_sheet.dart';

void main() {
  runApp(
    GunceApp(
      themeController: ThemeController(),
      calendarController: CalendarController(),
      diaryController: DiaryController(),
    ),
  );
}

/// Günce dijital günlük ve anı takvimi kök uygulama widget'ı.
class GunceApp extends StatelessWidget {
  final ThemeController themeController;
  final CalendarController calendarController;
  final DiaryController diaryController;

  const GunceApp({
    super.key,
    required this.themeController,
    required this.calendarController,
    required this.diaryController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController.themeMode,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Günce',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          home: GunceHomeScreen(
            themeController: themeController,
            calendarController: calendarController,
            diaryController: diaryController,
          ),
        );
      },
    );
  }
}

/// Takvim ve Günlük modüllerini mobil ve geniş ekranlara (Web/Masaüstü)
/// duyarlı ve taşma (overflow) yapmayan bir düzende birleştiren ana ekran.
class GunceHomeScreen extends StatelessWidget {
  final ThemeController themeController;
  final CalendarController calendarController;
  final DiaryController diaryController;

  const GunceHomeScreen({
    super.key,
    required this.themeController,
    required this.calendarController,
    required this.diaryController,
  });

  void _onDaySelected(BuildContext context, DateTime tappedDate) {
    final alreadySelected = CalendarDateUtils.isSameDay(
      calendarController.selectedDate.value,
      tappedDate,
    );
    calendarController.selectDate(tappedDate);
    if (alreadySelected) {
      DiaryEditorSheet.show(
        context,
        date: tappedDate,
        diaryController: diaryController,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 820;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: isWide
                    ? _WideHomeBody(
                        themeController: themeController,
                        calendarController: calendarController,
                        diaryController: diaryController,
                        onDaySelected: (d) => _onDaySelected(context, d),
                      )
                    : _CompactHomeBody(
                        themeController: themeController,
                        calendarController: calendarController,
                        diaryController: diaryController,
                        onDaySelected: (d) => _onDaySelected(context, d),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CompactHomeBody extends StatelessWidget {
  final ThemeController themeController;
  final CalendarController calendarController;
  final DiaryController diaryController;
  final ValueChanged<DateTime> onDaySelected;

  const _CompactHomeBody({
    required this.themeController,
    required this.calendarController,
    required this.diaryController,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _AppBrandTitle(),
          const SizedBox(height: 16),
          _ReactiveCalendarSection(
            calendarController: calendarController,
            themeController: themeController,
            diaryController: diaryController,
            onDaySelected: onDaySelected,
          ),
          const SizedBox(height: 22),
          _ReactiveDiarySummarySection(
            calendarController: calendarController,
            diaryController: diaryController,
          ),
        ],
      ),
    );
  }
}

class _WideHomeBody extends StatelessWidget {
  final ThemeController themeController;
  final CalendarController calendarController;
  final DiaryController diaryController;
  final ValueChanged<DateTime> onDaySelected;

  const _WideHomeBody({
    required this.themeController,
    required this.calendarController,
    required this.diaryController,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _AppBrandTitle(),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: _ReactiveCalendarSection(
                  calendarController: calendarController,
                  themeController: themeController,
                  diaryController: diaryController,
                  onDaySelected: onDaySelected,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 5,
                child: _ReactiveDiarySummarySection(
                  calendarController: calendarController,
                  diaryController: diaryController,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppBrandTitle extends StatelessWidget {
  const _AppBrandTitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          Icons.auto_stories_rounded,
          color: theme.colorScheme.primary,
          size: 26,
        ),
        const SizedBox(width: 10),
        Text('Günce', style: theme.textTheme.headlineMedium),
        const SizedBox(width: 10),
        Text('• Dijital Anı Defteri', style: theme.textTheme.bodyMedium),
      ],
    );
  }
}

class _ReactiveCalendarSection extends StatelessWidget {
  final CalendarController calendarController;
  final ThemeController themeController;
  final DiaryController diaryController;
  final ValueChanged<DateTime> onDaySelected;

  const _ReactiveCalendarSection({
    required this.calendarController,
    required this.themeController,
    required this.diaryController,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, DiaryEntryModel>>(
      valueListenable: diaryController.entries,
      builder: (context, _, _) {
        return CalendarView(
          calendarController: calendarController,
          themeController: themeController,
          moodByDateKey: diaryController.moodMap,
          onDaySelected: onDaySelected,
        );
      },
    );
  }
}

class _ReactiveDiarySummarySection extends StatelessWidget {
  final CalendarController calendarController;
  final DiaryController diaryController;

  const _ReactiveDiarySummarySection({
    required this.calendarController,
    required this.diaryController,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime>(
      valueListenable: calendarController.selectedDate,
      builder: (context, selectedDate, _) {
        return DiaryDaySummaryView(
          selectedDate: selectedDate,
          diaryController: diaryController,
        );
      },
    );
  }
}
