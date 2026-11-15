import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Beam Design System Colors and Tokens
/// Extracted directly from the Beam Figma Redesign mockups.
class BeamColors {
  // Brand Neon Lime
  static const lime = Color(0xFFCEF22A);
  static const limeHover = Color(0xFFBBE01E);
  static const onLime = Color(0xFF0F1013);

  // Dark Mode Tokens
  static const darkBackground = Color(0xFF0E1013);
  static const darkCard = Color(0xFF181A1F);
  static const darkCardHover = Color(0xFF1F2228);
  static const darkIconBadge = Color(0xFF22252C);
  static const darkBorder = Color(0xFF262932);
  static const darkTextPrimary = Colors.white;
  static const darkTextSecondary = Color(0xFF8C92A4);

  // Light Mode Tokens
  static const lightBackground = Color(0xFFF4F4F6);
  static const lightCard = Colors.white;
  static const lightCardHover = Color(0xFFEDEDF0);
  static const lightIconBadge = Color(0xFF181A1F);
  static const lightBorder = Color(0xFFE5E7EB);
  static const lightTextPrimary = Color(0xFF111827);
  static const lightTextSecondary = Color(0xFF6B7280);

  // Status colors
  static const success = Color(0xFF22C55E);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
}

/// A squircle container with a centered icon, standard in Beam designs.
class BeamSquircleIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final double iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final double borderRadius;

  const BeamSquircleIcon({
    super.key,
    required this.icon,
    this.size = 46,
    this.iconSize = 22,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? (isDark ? BeamColors.darkIconBadge : const Color(0xFF181A1F)),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor ?? BeamColors.lime,
        ),
      ),
    );
  }
}

/// A standard Beam card with subtle border and elevation matching the mockups.
class BeamCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double borderRadius;

  const BeamCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.backgroundColor,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = backgroundColor ?? (isDark ? BeamColors.darkCard : BeamColors.lightCard);

    final card = Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isDark ? BeamColors.darkBorder : BeamColors.lightBorder,
          width: 0.8,
        ),
      ),
      padding: padding,
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: card,
        ),
      );
    }
    return card;
  }
}

/// Concentric radar pulse animation for the Receive screen
class BeamRadarWidget extends StatefulWidget {
  final Widget centerChild;
  final double size;

  const BeamRadarWidget({
    super.key,
    required this.centerChild,
    this.size = 280,
  });

  @override
  State<BeamRadarWidget> createState() => _BeamRadarWidgetState();
}

class _BeamRadarWidgetState extends State<BeamRadarWidget> with SingleTickerProviderStateMixin {
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
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _RadarPainter(
              animationValue: _controller.value,
              isDark: Theme.of(context).brightness == Brightness.dark,
            ),
            child: Center(child: widget.centerChild),
          );
        },
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  final double animationValue;
  final bool isDark;

  _RadarPainter({required this.animationValue, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Draw 3 static subtle concentric circles
    final radii = [maxRadius * 0.45, maxRadius * 0.72, maxRadius * 0.95];
    for (int i = 0; i < radii.length; i++) {
      final r = radii[i];
      circlePaint.color = isDark
          ? BeamColors.lime.withValues(alpha: 0.08 + (i * 0.04))
          : const Color(0xFF181A1F).withValues(alpha: 0.06 + (i * 0.03));
      canvas.drawCircle(center, r, circlePaint);
    }

    // Draw orbiting dots
    final dotPaint = Paint()..style = PaintingStyle.fill;
    final dotAngle1 = animationValue * 2 * math.pi;
    final dotAngle2 = -animationValue * 2 * math.pi + 1.5;

    dotPaint.color = (isDark ? BeamColors.lime : const Color(0xFF181A1F)).withValues(alpha: 0.45);
    final dotOffset1 = Offset(
      center.dx + radii[1] * math.cos(dotAngle1),
      center.dy + radii[1] * math.sin(dotAngle1),
    );
    canvas.drawCircle(dotOffset1, 5, dotPaint);

    dotPaint.color = (isDark ? BeamColors.lime : const Color(0xFF181A1F)).withValues(alpha: 0.3);
    final dotOffset2 = Offset(
      center.dx + radii[2] * math.cos(dotAngle2),
      center.dy + radii[2] * math.sin(dotAngle2),
    );
    canvas.drawCircle(dotOffset2, 4, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
