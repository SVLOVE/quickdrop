import 'package:flutter/material.dart';
import 'package:localsend_app/theme/beam_theme.dart';
import 'package:localsend_app/util/device_type_ext.dart';
import 'package:localsend_app/widget/custom_progress_bar.dart';
import 'package:localsend_isolates/model/device.dart';

class DeviceListTile extends StatelessWidget {
  final Device device;
  final bool isFavorite;

  /// If not null, this name is used instead of [Device.alias].
  /// This is the case when the device is marked as favorite.
  final String? nameOverride;

  final String? info;
  final double? progress;
  final VoidCallback? onTap;
  final VoidCallback? onDetailsTap;

  const DeviceListTile({
    super.key,
    required this.device,
    this.isFavorite = false,
    this.nameOverride,
    this.info,
    this.progress,
    this.onTap,
    this.onDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BeamCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      onTap: onTap,
      child: Row(
        children: [
          BeamSquircleIcon(
            icon: device.deviceType.icon,
            size: 46,
            iconSize: 22,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        nameOverride ?? device.alias,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isFavorite) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.star_rounded, size: 16, color: BeamColors.lime),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                if (progress != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: CustomProgressBar(progress: progress!),
                  )
                else
                  Text(
                    info ?? (device.deviceModel != null ? '${device.deviceModel} · ${device.ip ?? ''}' : (device.ip ?? 'Online')),
                    style: const TextStyle(
                      fontSize: 13,
                      color: BeamColors.darkTextSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF22252C) : const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Send',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          if (onDetailsTap != null) ...[
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.info_outline, size: 18, color: BeamColors.darkTextSecondary),
              onPressed: onDetailsTap,
            ),
          ],
        ],
      ),
    );
  }
}
