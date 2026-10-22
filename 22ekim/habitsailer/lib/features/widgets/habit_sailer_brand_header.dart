import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class HabitSailerBrandHeader extends StatelessWidget {
  final bool compact;

  const HabitSailerBrandHeader({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<HabitSailerThemeExtension>()!;

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
