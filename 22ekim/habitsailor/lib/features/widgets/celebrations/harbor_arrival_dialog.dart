import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class HarborArrivalDialog extends StatefulWidget {
  final int bonusPoints;
  final VoidCallback onDismiss;

  const HarborArrivalDialog({
    super.key,
    this.bonusPoints = 50,
    required this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    int bonusPoints = 50,
    required VoidCallback onDismiss,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => HarborArrivalDialog(
        bonusPoints: bonusPoints,
        onDismiss: onDismiss,
      ),
    );
  }

  @override
  State<HarborArrivalDialog> createState() => _HarborArrivalDialogState();
}

class _HarborArrivalDialogState extends State<HarborArrivalDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
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
          side: BorderSide(color: ext.lightningYellow, width: 2.5),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grand Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: ext.urgentNavyBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: ext.lightningYellow, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.anchor_rounded, size: 20, color: ext.lightningYellow),
                    const SizedBox(width: 8),
                    Text(
                      'LİMANA VARDINIZ! 🏰⚓',
                      style: TextStyle(
                        color: ext.urgentNavyFg,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'Tebrikler Kaptan! Haftalık Zafer!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 8),

              Text(
                'Bir haftalık çetin seyrüseferi başarıyla tamamlayıp limana demirlediniz. Mürettebatınız sizinle gurur duyuyor!',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: cs.onSurface.withValues(alpha: 0.8),
                    ),
              ),
              const SizedBox(height: 16),

              // Animated Harbor & Dropping Anchor Canvas
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 155,
                  width: double.infinity,
                  color: cs.primaryContainer,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return CustomPaint(
                        painter: _HarborPainter(
                          progress: _controller.value,
                          primaryColor: cs.primary,
                          waveLightColor: cs.primary.withValues(alpha: 0.4),
                          goldColor: ext.lightningYellow,
                          navyColor: ext.urgentNavyBg,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Bonus Rewards Card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: ext.urgentNavyBg,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ext.lightningYellow,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.star_rounded, color: ext.onLightningBanner, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Haftalık Liman Bonusu',
                            style: TextStyle(
                              color: ext.urgentNavyFg,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '+${widget.bonusPoints} Ekstra Zincir Puanı Kazandınız! ⚡',
                            style: TextStyle(
                              color: ext.lightningYellow,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ],
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
                  icon: const Icon(Icons.check_circle_rounded),
                  label: const Text(
                    'Zaferi Kutla ve Devam Et 🧭',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ext.urgentNavyBg,
                    foregroundColor: ext.urgentNavyFg,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: ext.lightningYellow, width: 1.5),
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

class _HarborPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color waveLightColor;
  final Color goldColor;
  final Color navyColor;

  const _HarborPainter({
    required this.progress,
    required this.primaryColor,
    required this.waveLightColor,
    required this.goldColor,
    required this.navyColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Lighthouse on the left
    final lighthouseX = size.width * 0.18;
    final lighthouseBaseY = size.height * 0.72;

    // Lighthouse base & tower
    final towerPath = Path();
    towerPath.moveTo(lighthouseX - 14, lighthouseBaseY);
    towerPath.lineTo(lighthouseX + 14, lighthouseBaseY);
    towerPath.lineTo(lighthouseX + 8, lighthouseBaseY - 50);
    towerPath.lineTo(lighthouseX - 8, lighthouseBaseY - 50);
    towerPath.close();
    canvas.drawPath(towerPath, Paint()..color = navyColor);

    // Rotating Lighthouse Light Beam
    final beamAngle = (progress * 2 * math.pi);
    final beamPath = Path();
    beamPath.moveTo(lighthouseX, lighthouseBaseY - 48);
    final beamLength = size.width * 0.7;
    beamPath.lineTo(
      lighthouseX + math.cos(beamAngle) * beamLength,
      (lighthouseBaseY - 48) + math.sin(beamAngle * 0.5) * 30,
    );
    beamPath.lineTo(
      lighthouseX + math.cos(beamAngle + 0.3) * beamLength,
      (lighthouseBaseY - 48) + math.sin((beamAngle + 0.3) * 0.5) * 30,
    );
    beamPath.close();
    canvas.drawPath(
      beamPath,
      Paint()
        ..color = goldColor.withValues(alpha: 0.35)
        ..style = PaintingStyle.fill,
    );

    // Lighthouse cap
    canvas.drawCircle(
      Offset(lighthouseX, lighthouseBaseY - 50),
      6,
      Paint()..color = goldColor,
    );

    // 2. Pier / Harbor Dock on the right
    final pierRect = Rect.fromLTWH(
      size.width * 0.65,
      size.height * 0.68,
      size.width * 0.35,
      size.height * 0.32,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(pierRect, const Radius.circular(8)),
      Paint()..color = navyColor.withValues(alpha: 0.8),
    );

    // 3. Calm Harbor Waters
    final waterPath = Path();
    waterPath.moveTo(0, size.height);
    for (double x = 0; x <= size.width; x += 5) {
      final y = size.height * 0.75 +
          math.sin((x / 20) + (progress * 2 * math.pi)) * 3;
      waterPath.lineTo(x, y);
    }
    waterPath.lineTo(size.width, size.height);
    waterPath.close();
    canvas.drawPath(waterPath, Paint()..color = primaryColor);

    // 4. Moored Sailboat near the pier
    final boatX = size.width * 0.52;
    final boatY = size.height * 0.73;

    canvas.save();
    canvas.translate(boatX, boatY);
    // Hull
    final hull = Path();
    hull.moveTo(-18, 0);
    hull.lineTo(20, 0);
    hull.lineTo(14, 10);
    hull.lineTo(-12, 10);
    hull.close();
    canvas.drawPath(hull, Paint()..color = navyColor);

    // Mast
    canvas.drawLine(
      const Offset(0, 0),
      const Offset(0, -22),
      Paint()
        ..color = navyColor
        ..strokeWidth = 2,
    );

    // Folded/Resting Sails in Port
    final sail = Path();
    sail.moveTo(0, -20);
    sail.lineTo(12, -2);
    sail.lineTo(0, -2);
    sail.close();
    canvas.drawPath(sail, Paint()..color = primaryColor.withValues(alpha: 0.8));

    // Dropping Anchor Animation
    // Anchor descends downwards into the water
    final anchorDrop = (math.sin(progress * 2 * math.pi) * 0.5 + 0.5) * 14;
    final anchorY = 10.0 + anchorDrop;
    canvas.drawLine(
      const Offset(14, 6),
      Offset(14, anchorY),
      Paint()
        ..color = goldColor
        ..strokeWidth = 1.5,
    );
    // Anchor symbol
    canvas.drawCircle(Offset(14, anchorY + 4), 3, Paint()..color = goldColor);
    final anchorArc = Path();
    anchorArc.addArc(
      Rect.fromCircle(center: Offset(14, anchorY + 4), radius: 6),
      0,
      math.pi,
    );
    canvas.drawPath(
      anchorArc,
      Paint()
        ..color = goldColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HarborPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
