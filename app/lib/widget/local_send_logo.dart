import 'package:flutter/material.dart';
import 'package:localsend_app/theme/beam_theme.dart';

class LocalSendLogo extends StatelessWidget {
  final bool withText;
  final double size;

  const LocalSendLogo({
    super.key,
    required this.withText,
    this.size = 80,
  });

  @override
  Widget build(BuildContext context) {
    final logoBadge = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: BeamColors.lime,
        borderRadius: BorderRadius.circular(size * 0.32),
        boxShadow: [
          BoxShadow(
            color: BeamColors.lime.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.wifi_rounded,
          size: size * 0.52,
          color: BeamColors.onLime,
        ),
      ),
    );

    if (withText) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          logoBadge,
          const SizedBox(height: 24),
          const Text(
            'Quick Drop',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          const Text(
            'Share anything, nearby.',
            style: TextStyle(
              fontSize: 15,
              color: BeamColors.darkTextSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      return logoBadge;
    }
  }
}
