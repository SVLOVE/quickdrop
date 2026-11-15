import 'package:flutter/material.dart';
import 'package:localsend_app/pages/receive_history_page.dart';
import 'package:localsend_app/provider/local_ip_provider.dart';
import 'package:localsend_app/provider/network/server/server_provider.dart';
import 'package:localsend_app/provider/receive_history_provider.dart';
import 'package:localsend_app/provider/settings_provider.dart';
import 'package:localsend_app/theme/beam_theme.dart';
import 'package:localsend_app/widget/responsive_list_view.dart';
import 'package:localsend_isolates/util/file_size_helper.dart';
import 'package:refena_flutter/refena_flutter.dart';
import 'package:routerino/routerino.dart';

class ReceiveTab extends StatelessWidget {
  const ReceiveTab({super.key});

  @override
  Widget build(BuildContext context) {
    final alias = context.watch(settingsProvider.select((s) => s.alias));
    final quickSave = context.watch(settingsProvider.select((s) => s.quickSave));
    final quickSaveFromFavorites = context.watch(settingsProvider.select((s) => s.quickSaveFromFavorites));
    final serverState = context.watch(serverProvider);
    final localIps = context.watch(localIpProvider.select((s) => s.localIps));
    final receiveHistory = context.watch(receiveHistoryProvider);

    final displayAlias = serverState?.alias ?? alias;
    final displayIp = localIps.isNotEmpty ? localIps.first : '127.0.0.1';

    return ResponsiveListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        const SizedBox(height: 12),
        const Text(
          'Ready to receive',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Visible as $displayAlias · $displayIp',
          style: const TextStyle(
            fontSize: 15,
            color: BeamColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: 28),

        // Center Radar Animation
        Center(
          child: BeamRadarWidget(
            size: 260,
            centerChild: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? BeamColors.darkIconBadge
                    : const Color(0xFF181A1F),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: BeamColors.lime.withValues(alpha: 0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.wifi_rounded,
                  size: 38,
                  color: BeamColors.lime,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Quick Save Toggle Card
        BeamCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const BeamSquircleIcon(
                icon: Icons.bolt_rounded,
                size: 42,
                iconSize: 22,
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick save',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Accept files without asking',
                      style: TextStyle(
                        fontSize: 13,
                        color: BeamColors.darkTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: quickSave,
                onChanged: (val) async {
                  await context.ref.notifier(settingsProvider).setQuickSave(val);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Favorites Only Toggle Card
        BeamCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const BeamSquircleIcon(
                icon: Icons.star_outline_rounded,
                size: 42,
                iconSize: 22,
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Favorites only',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Ignore unknown devices',
                      style: TextStyle(
                        fontSize: 13,
                        color: BeamColors.darkTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: quickSaveFromFavorites,
                onChanged: (val) async {
                  await context.ref.notifier(settingsProvider).setQuickSaveFromFavorites(val);
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Last Received Section
        const Text(
          'Last received',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: BeamColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: 10),

        if (receiveHistory.isNotEmpty) ...[
          _RecentHistoryCard(entry: receiveHistory.first),
        ] else ...[
          BeamCard(
            onTap: () async {
              await context.push(() => const ReceiveHistoryPage());
            },
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: const Row(
              children: [
                BeamSquircleIcon(
                  icon: Icons.history_rounded,
                  size: 42,
                  iconSize: 22,
                ),
                SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No files received yet',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Received files will show up here',
                      style: TextStyle(
                        fontSize: 13,
                        color: BeamColors.darkTextSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 80),
      ],
    );
  }
}

class _RecentHistoryCard extends StatelessWidget {
  final dynamic entry;

  const _RecentHistoryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return BeamCard(
      onTap: () async {
        await context.push(() => const ReceiveHistoryPage());
      },
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          const BeamSquircleIcon(
            icon: Icons.archive_outlined,
            size: 42,
            iconSize: 22,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.fileName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${entry.senderAlias} · ${(entry.fileSize as int).asReadableFileSize}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: BeamColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: BeamColors.darkTextSecondary,
          ),
        ],
      ),
    );
  }
}
