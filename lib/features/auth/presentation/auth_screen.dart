import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/feedback.dart';
import '../data/auth_repository.dart';
import '../data/user_repository.dart';

/// Sign in / register with e-mail, Google and (on iOS) Apple.
class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _register = false;
  bool _busy = false;
  bool _obscure = true;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } catch (e, s) {
      if (mounted) showError(context, e, s);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _submitEmail() async {
    if (!_formKey.currentState!.validate()) return;
    final repo = ref.read(authRepositoryProvider);
    await _run(() async {
      if (!_register) return repo.signInWithEmail(_email.text, _password.text);
      await repo.registerWithEmail(name: _name.text, email: _email.text, password: _password.text);
      final uid = repo.currentUser?.uid;
      if (uid != null) await ref.read(userRepositoryProvider).setDisplayName(uid, _name.text);
    });
  }

  Future<void> _resetPassword() async {
    final l = context.l10n;
    if (!_email.text.contains('@')) {
      showMessage(context, l.enterEmailFirst);
      return;
    }
    await _run(() async {
      await ref.read(authRepositoryProvider).sendPasswordReset(_email.text);
      if (mounted) showMessage(context, l.passwordResetSent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final repo = ref.watch(authRepositoryProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: AutofillGroup(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const ExcludeSemantics(
                        child: Text('🏠', style: TextStyle(fontSize: 64), textAlign: TextAlign.center),
                      ),
                      const SizedBox(height: 8),
                      Text(l.appName,
                          style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
                      const SizedBox(height: 4),
                      Text(
                        l.authSubtitle,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      SegmentedButton<bool>(
                        segments: [
                          ButtonSegment(value: false, label: Text(l.signIn)),
                          ButtonSegment(value: true, label: Text(l.register)),
                        ],
                        selected: {_register},
                        onSelectionChanged: (s) => setState(() => _register = s.first),
                      ),
                      const SizedBox(height: 16),
                      if (_register) ...[
                        TextFormField(
                          controller: _name,
                          textCapitalization: TextCapitalization.words,
                          autofillHints: const [AutofillHints.name],
                          decoration: InputDecoration(labelText: l.yourName),
                          validator: (v) => (v ?? '').trim().isEmpty ? l.requiredField : null,
                        ),
                        const SizedBox(height: 12),
                      ],
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        decoration: InputDecoration(labelText: l.email),
                        validator: (v) => (v ?? '').contains('@') ? null : l.errorInvalidEmail,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _password,
                        obscureText: _obscure,
                        autofillHints: [
                          _register ? AutofillHints.newPassword : AutofillHints.password,
                        ],
                        decoration: InputDecoration(
                          labelText: l.password,
                          suffixIcon: IconButton(
                            tooltip: _obscure ? l.showPassword : l.hidePassword,
                            icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) => (v ?? '').length < 6 ? l.errorWeakPassword : null,
                        onFieldSubmitted: (_) => _submitEmail(),
                      ),
                      if (!_register)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _busy ? null : _resetPassword,
                            child: Text(l.forgotPassword),
                          ),
                        ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _busy ? null : _submitEmail,
                        child: _busy
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(_register ? l.register : l.signIn),
                      ),
                      if (repo.googleAvailable || repo.appleAvailable) ...[
                        const SizedBox(height: 24),
                        Row(children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(l.or),
                          ),
                          const Expanded(child: Divider()),
                        ]),
                        const SizedBox(height: 24),
                      ],
                      if (repo.googleAvailable)
                        OutlinedButton.icon(
                          onPressed: _busy ? null : () => _run(repo.signInWithGoogle),
                          icon: const Text('G', style: TextStyle(fontWeight: FontWeight.bold)),
                          label: Text(l.continueWithGoogle),
                        ),
                      if (repo.appleAvailable) ...[
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _busy ? null : () => _run(repo.signInWithApple),
                          icon: const Icon(Icons.apple),
                          label: Text(l.continueWithApple),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
