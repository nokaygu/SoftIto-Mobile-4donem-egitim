import 'package:flutter/material.dart';

/// %100 Responsive ve Sıfır Sıkışma (Zero Overflow) Yardımcı Bileşenleri
class ResponsiveScrollBody extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool fillRemaining;

  const ResponsiveScrollBody({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16.0),
    this.fillRemaining = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: padding,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - padding.vertical,
                minWidth: constraints.maxWidth - padding.horizontal,
              ),
              child: fillRemaining
                  ? IntrinsicHeight(child: child)
                  : child,
            ),
          );
        },
      ),
    );
  }
}

/// Metinlerin dar alanlarda taşmasını veya sıkışmasını engelleyen ölçeklenebilir metin bileşeni
class AutoFitText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int maxLines;
  final TextOverflow overflow;

  const AutoFitText(
    this.text, {
    super.key,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: textAlign == TextAlign.center
          ? Alignment.center
          : (textAlign == TextAlign.right ? Alignment.centerRight : Alignment.centerLeft),
      child: Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: style,
      ),
    );
  }
}

/// Dikey ve Yatay ekran durumuna göre farklı arayüz sağlayan adaptif widget
class OrientationAdaptiveLayout extends StatelessWidget {
  final Widget Function(BuildContext context) portrait;
  final Widget Function(BuildContext context) landscape;

  const OrientationAdaptiveLayout({
    super.key,
    required this.portrait,
    required this.landscape,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.landscape) {
          return landscape(context);
        }
        return portrait(context);
      },
    );
  }
}
