import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class VoyageCelebrationDialog extends StatefulWidget {
  final int earnedPoints;
  final VoidCallback onDismiss;

  const VoyageCelebrationDialog({
    super.key,
    required this.earnedPoints,
    required this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    required int earnedPoints,
    required VoidCallback onDismiss,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => VoyageCelebrationDialog(
        earnedPoints: earnedPoints,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  State<VoyageCelebrationDialog> createState() => _VoyageCelebrationDialogState();
}

class _VoyageCelebrationDialogState extends State<VoyageCelebrationDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final ext = Theme.of(context).extension<HabitSailorThemeExtension>()!;

    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: cs.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: cs.outlineVariant, width: 2),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: ext.lightningYellow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt_rounded, size: 18, color: ext.onLightningBanner),
                    const SizedBox(width: 6),
                    Text(
                      'ZİNCİR KIRILMADI! ⚡',
                      style: TextStyle(
                        color: ext.onLightningBanner,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Title
              Text(
                'Hurray! Rüzgarın Kolayına Olsun! ⛵',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 8),

              Text(
                'Bugünün rotasındaki görevleri başarıyla tamamladın. Gemi tam yol ileri devam ediyor!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.8),
                    ),
              ),
              const SizedBox(height: 16),

              // Animated Ocean & Boat Canvas
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 150,
                  width: double.infinity,
                  color: cs.primaryContainer,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _VoyagePainter(
                          progress: _controller.value,
                          primaryColor: cs.primary,
                          waveLightColor: cs.primary.withValues(alpha: 0.35),
                          sunColor: ext.lightningYellow,
                          boatColor: cs.onPrimary,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Earned Points Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: cs.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cs.outlineVariant),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.military_tech_rounded, color: ext.lightningYellow, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Kazanılan Güç: +${widget.earnedPoints} Zincir Puanı',
                      style: TextStyle(
                        color: cs.onSurface,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Action button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onDismiss();
                  },
                  icon: const Icon(Icons.explore_rounded),
                  label: const Text(
                    'Seyir Defterine Geç 🧭',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cs.primary,
                    foregroundColor: cs.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VoyagePainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color waveLightColor;
  final Color sunColor;
  final Color boatColor;

  const _VoyagePainter({
    required this.progress,
    required this.primaryColor,
    required this.waveLightColor,
    required this.sunColor,
    required this.boatColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Sky & Sun / Sparkles
    final sunPaint = Paint()..color = sunColor.withValues(alpha: 0.7);
    canvas.drawCircle(Offset(size.width * 0.85, 30), 16, sunPaint);

    // Stars / Sparkles
    final starPaint = Paint()..color = sunColor;
    for (var i = 0; i < 4; i++) {
      final sx = size.width * (0.15 + i * 0.22);
      final sy = 20.0 + (i % 2) * 15.0;
      final sparkleScale = (math.sin((progress * 2 * math.pi) + i) + 1) / 2;
      canvas.drawCircle(Offset(sx, sy), 2.5 * sparkleScale, starPaint);
    }

    // 2. Background Waves
    final bgWavePath = Path();
    bgWavePath.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x += 5) {
      final y = size.height * 0.68 +
          math.sin((x / 30) + (progress * 2 * math.pi)) * 6;
      bgWavePath.lineTo(x, y);
    }
    bgWavePath.lineTo(size.width, size.height);
    bgWavePath.close();
    canvas.drawPath(bgWavePath, Paint()..color = waveLightColor);

    // 3. Animated Sailboat
    // Sailboat moves gently horizontally and bobs up and down with rotation
    final boatX = size.width * (0.2 + (progress * 0.6) % 0.6);
    final waveYAtBoat = size.height * 0.68 +
        math.sin((boatX / 30) + (progress * 2 * math.pi)) * 6;
    final boatTilt = math.cos((boatX / 30) + (progress * 2 * math.pi)) * 0.08;

    canvas.save();
    canvas.translate(boatX, waveYAtBoat - 2);
    canvas.rotate(boatTilt);

    // Hull (Gövde)
    final hullPath = Path();
    hullPath.moveTo(-22, 0);
    hullPath.lineTo(24, 0);
    hullPath.lineTo(16, 12);
    hullPath.lineTo(-14, 12);
    hullPath.close();
    canvas.drawPath(hullPath, Paint()..color = boatColor);

    // Mast (Direk)
    final mastPaint = Paint()
      ..color = boatColor
      ..strokeWidth = 2.5;
    canvas.drawLine(const Offset(2, 0), const Offset(2, -26), mastPaint);

    // Main Sail (Büyük Yelken)
    final mainSail = Path();
    mainSail.moveTo(2, -24);
    mainSail.lineTo(19, -4);
    mainSail.lineTo(2, -4);
    mainSail.close();
    canvas.drawPath(mainSail, Paint()..color = primaryColor);

    // Jib Sail (Ön Flok Yelkeni)
    final jibSail = Path();
    jibSail.moveTo(0, -20);
    jibSail.lineTo(-14, -4);
    jibSail.lineTo(0, -4);
    jibSail.close();
    canvas.drawPath(
      jibSail,
      Paint()..color = primaryColor.withValues(alpha: 0.8),
    );

    canvas.restore();

    // 4. Foreground Waves
    final fgWavePath = Path();
    fgWavePath.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x += 5) {
      final y = size.height * 0.74 +
          math.sin((x / 25) - (progress * 2 * math.pi)) * 7;
      fgWavePath.lineTo(x, y);
    }
    fgWavePath.lineTo(size.width, size.height);
    fgWavePath.close();
    canvas.drawPath(fgWavePath, Paint()..color = primaryColor);
  }

  @override
  bool shouldRepaint(covariant _VoyagePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
