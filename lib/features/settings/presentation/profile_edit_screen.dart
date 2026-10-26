import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/iban.dart';
import '../../../core/widgets/feedback.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';

const _avatars = [
  '🙂', '😎', '🤓', '🥳', '😺', '🐶', '🦊', '🐼', '🐸', '🦄', //
  '🌻', '🌵', '🍕', '☕', '🎧', '🎮', '⚽', '🎸', '📚', '🚲',
];

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _iban = TextEditingController();
  String _avatar = '🙂';
  AppUser? _user;
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _iban.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final iban = Iban.normalize(_iban.text);
      await ref.read(userRepositoryProvider).updateProfile(
            _user!,
            displayName: _name.text.trim(),
            avatarEmoji: _avatar,
            iban: iban.isEmpty ? null : iban,
          );
      if (mounted) context.pop();
    } catch (e, s) {
      if (mounted) showError(context, e, s);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final profile = ref.watch(userProfileProvider).value;
    if (profile == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_user == null) {
      _user = profile;
      _name.text = profile.displayName;
      _iban.text = profile.iban == null ? '' : Iban.format(profile.iban!);
      _avatar = profile.avatarEmoji;
    }
    return Scaffold(
      appBar: AppBar(title: Text(l.editProfile)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(l.avatar, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final a in _avatars)
                  ChoiceChip(
                    label: Text(a, style: const TextStyle(fontSize: 22)),
                    selected: _avatar == a,
                    onSelected: (_) => setState(() => _avatar = a),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _name,
              maxLength: 40,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l.yourName),
              validator: (v) => (v ?? '').trim().isEmpty ? l.requiredField : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _iban,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: l.ibanOptional,
                hintText: 'TR00 0000 0000 0000 0000 0000 00',
                helperText: l.ibanHelp,
                helperMaxLines: 3,
              ),
              validator: (v) {
                final value = (v ?? '').trim();
                if (value.isEmpty) return null;
                return Iban.isValid(value) ? null : l.ibanInvalid;
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(onPressed: _saving ? null : _save, child: Text(l.save)),
        ),
      ),
    );
  }
}
