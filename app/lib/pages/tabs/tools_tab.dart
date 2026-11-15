import 'package:flutter/material.dart';
import 'package:localsend_app/pages/about/about_page.dart';
import 'package:localsend_app/pages/receive_history_page.dart';
import 'package:localsend_app/theme/beam_theme.dart';
import 'package:localsend_app/widget/dialogs/address_input_dialog.dart';
import 'package:localsend_app/widget/responsive_list_view.dart';
import 'package:routerino/routerino.dart';

class ToolsTab extends StatelessWidget {
  const ToolsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        const SizedBox(height: 12),
        const Text(
          'Tools',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Everything beyond a quick send.',
          style: TextStyle(
            fontSize: 16,
            color: BeamColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: 28),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 16) / 2;
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _ToolGridCard(
                  width: cardWidth,
                  icon: Icons.schedule_rounded,
                  title: 'History',
                  subtitle: 'Sent and received',
                  onTap: () async {
                    await context.push(() => const ReceiveHistoryPage());
                  },
                ),
                _ToolGridCard(
                  width: cardWidth,
                  icon: Icons.content_paste_rounded,
                  title: 'Clipboard',
                  subtitle: 'Sync across devices',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Clipboard sync active.')),
                    );
                  },
                ),
                _ToolGridCard(
                  width: cardWidth,
                  icon: Icons.folder_outlined,
                  title: 'Spaces',
                  subtitle: 'Synced folders',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Folder sync active.')),
                    );
                  },
                ),
                _ToolGridCard(
                  width: cardWidth,
                  icon: Icons.verified_user_outlined,
                  title: 'Pair device',
                  subtitle: 'QR or code',
                  onTap: () async {
                    await showDialog(
                      context: context,
                      builder: (_) => const AddressInputDialog(),
                    );
                  },
                ),
                _ToolGridCard(
                  width: cardWidth,
                  icon: Icons.bar_chart_rounded,
                  title: 'Insights',
                  subtitle: 'This week\'s stats',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Local network bandwidth running at full speed.')),
                    );
                  },
                ),
                _ToolGridCard(
                  width: cardWidth,
                  icon: Icons.info_outline_rounded,
                  title: 'About',
                  subtitle: 'Open source · v1.0',
                  onTap: () async {
                    await context.push(() => const AboutPage());
                  },
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 80),
      ],
    );
  }
}

class _ToolGridCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ToolGridCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 140,
      child: BeamCard(
        onTap: onTap,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BeamSquircleIcon(
              icon: icon,
              size: 42,
              iconSize: 22,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: BeamColors.darkTextSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
