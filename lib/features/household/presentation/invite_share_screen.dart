import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../app/router.dart';
import '../../../core/widgets/feedback.dart';

/// Shown right after creating a household: the invite code and a share button.
class InviteShareScreen extends StatelessWidget {
  const InviteShareScreen({super.key, required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ExcludeSemantics(
                    child: Text('🎉', style: TextStyle(fontSize: 64), textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 16),
                  Text(l.inviteTitle,
                      style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(l.inviteBody, textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  InviteCodeCard(code: code),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: () => context.go(Routes.home),
                    child: Text(l.continueToHome),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The 6-character code with copy and share actions.
class InviteCodeCard extends StatelessWidget {
  const InviteCodeCard({super.key, required this.code, this.onRegenerate});

  final String code;
  final VoidCallback? onRegenerate;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(l.inviteCode, style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),
            Semantics(
              label: l.inviteCodeSemantics(code.split('').join(' ')),
              excludeSemantics: true,
              child: SelectableText(
                code,
                style: theme.textTheme.displaySmall
                    ?.copyWith(letterSpacing: 8, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    if (context.mounted) showMessage(context, l.copied);
                  },
                  icon: const Icon(Icons.copy),
                  label: Text(l.copy),
                ),
                FilledButton.icon(
                  onPressed: () => SharePlus.instance.share(ShareParams(text: l.inviteShareText(code))),
                  icon: const Icon(Icons.share),
                  label: Text(l.share),
                ),
                if (onRegenerate != null)
                  TextButton.icon(
                    onPressed: onRegenerate,
                    icon: const Icon(Icons.refresh),
                    label: Text(l.regenerateCode),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
