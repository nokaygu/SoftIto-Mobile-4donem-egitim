---
name: habit-sailer-single-widget-scaffold
description: Habit Sailer projesi için Tek İş = Tek Widget (DRY) prensibini, Tema dosyası dışında sıfır renk kuralını, en sert flutter analyze kurallarını, flutter_secure_storage ve Hive entegrasyonunu uygular.
---

# Habit Sailer - DRY & Theme-Strict Scaffold

Bu yetenek, projede kod üretilirken **aynı işi yapan ikinci bir widget yazılmamasını**, **`app_theme.dart` dışında hiçbir dosyada renk kodu kullanılmamasını** ve **`flutter analyze` sıfır uyarı** kuralını garanti altına alır.

## Temel Kurallar

1. **Tema Dışında Renk Yasağı:**
   - Herhangi bir view, widget veya controller dosyasında `Colors.` veya `Color(` yazmak **KESİNLİKLE YASAKTIR**.
   - Renkler yalnızca `final cs = Theme.of(context).colorScheme;` ve `final ext = Theme.of(context).extension<HabitSailorThemeExtension>()!;` üzerinden alınır.
2. **Tek Görev Kartı (`HabitTaskCard`):**
   - Görev listelenen her yerde yalnızca `lib/features/widgets/habit_task_card.dart` kullanılır.
3. **Samsung Alarm Tarzı Haftalık Gün Seçici (`WeekdaySelectorBar`):**
   - Tekrarlayan görevlerde haftanın 7 günü `['P', 'S', 'Ç', 'P', 'C', 'C', 'P']` (1..7) şeklinde dairesel butonlarla seçilir.

## Uygulama Şablonları

### 1. Marka Logo ve "Zinciri Kırma ⚡" Slogan Widget'ı (`lib/features/widgets/habit_sailer_brand_header.dart`)

_(Hiçbir renk kodu içermez, tüm renklerini temadan alır!)_

```dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HabitSailorBrandHeader extends StatelessWidget {
  final bool compact;

  const HabitSailorBrandHeader({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<HabitSailorThemeExtension>()!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 64 : 92,
          height: compact ? 64 : 92,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: cs.primaryContainer,
            border: Border.all(color: cs.primary, width: 3),
            boxShadow: [
              BoxShadow(
                color: ext.deepNavyShadow,
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.sailing_rounded,
                size: compact ? 36 : 52,
                color: cs.primary,
              ),
              Positioned(
                top: compact ? 8 : 12,
                right: compact ? 10 : 14,
                child: Icon(
                  Icons.bolt_rounded,
                  size: compact ? 20 : 28,
                  color: ext.lightningYellow,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'HABIT SAILER',
          style: (compact
                  ? Theme.of(context).textTheme.titleMedium
                  : Theme.of(context).textTheme.headlineSmall)
              ?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: ext.lightningBannerBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: ext.lightningYellow, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bolt_rounded, color: ext.lightningYellow, size: 18),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'ZİNCİRİ KIRMA',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: ext.onLightningBanner,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.link_rounded, color: ext.lightningYellow, size: 16),
            ],
          ),
        ),
      ],
    );
  }
}
```

### 2. Evrensel Görev Kartı Şablonu (`lib/features/widgets/habit_task_card.dart`)

```dart
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../models/habit_task_model.dart';

class HabitTaskCard extends StatelessWidget {
  final HabitTaskModel task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;
  final VoidCallback? onDeleteTap;
  final bool isCompletedToday;

  const HabitTaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleComplete,
    this.onDeleteTap,
    this.isCompletedToday = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<HabitSailorThemeExtension>()!;

    final bgColor = ext.difficultyBackground(task.difficulty);
    final fgColor = ext.difficultyForeground(task.difficulty);
    final borderColor = ext.difficultyBorder(task.difficulty);
    final isUrgentNavy = task.difficulty == 2;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: isUrgentNavy ? 2.2 : 1.5),
        boxShadow: [
          BoxShadow(
            color: isUrgentNavy ? ext.deepNavyShadow : cs.outlineVariant,
            blurRadius: isUrgentNavy ? 16 : 8,
            offset: Offset(0, isUrgentNavy ? 7 : 3),
          ),
        ],
      ),
      child: Material(
        color: cs.surface.withValues(alpha: 0),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (task.isRecurring) _buildStreakRow(context, ext, fgColor),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (onToggleComplete != null) ...[
                      IconButton(
                        onPressed: onToggleComplete,
                        icon: Icon(
                          isCompletedToday
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: fgColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Expanded(
                      child: Text(
                        task.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: fgColor,
                          fontWeight: FontWeight.w800,
                          decoration: isCompletedToday ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    if (task.isRecurring)
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Icon(Icons.loop_rounded, color: fgColor, size: 22),
                      ),
                    if (onDeleteTap != null)
                      IconButton(
                        onPressed: onDeleteTap,
                        icon: Icon(Icons.close_rounded, color: fgColor),
                      ),
                  ],
                ),
                if (task.timeString != null && task.timeString!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _buildTimeAndDaysRow(context, fgColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStreakRow(
    BuildContext context,
    HabitSailorThemeExtension ext,
    Color fgColor,
  ) {
    final streakColor = ext.streakNeonColor(task.streakCount);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: streakColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.bolt_rounded, size: 16, color: ext.onStreakNeon),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                '${task.streakCount} Zincir Puanı',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: ext.onStreakNeon,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeAndDaysRow(BuildContext context, Color fgColor) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(Icons.access_time_filled_rounded, size: 16, color: fgColor),
        Text(
          task.timeString!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: fgColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
```
