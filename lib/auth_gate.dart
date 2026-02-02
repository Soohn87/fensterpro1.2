import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;

        if (session == null) {
          return const LoginScreen();
        }

        return const CompanyGateScreen();
      },
    );
  }
}

/// ===============================
/// LOGIN / REGISTER
/// ===============================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pw = TextEditingController();
  bool _loading = false;

  final _client = Supabase.instance.client;

  Future<void> _login() async {
    if (_email.text.isEmpty || _pw.text.isEmpty) {
      _toast("Bitte E-Mail und Passwort eingeben");
      return;
    }

    setState(() => _loading = true);

    try {
      await _client.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _pw.text.trim(),
      );
    } catch (e) {
      _toast("Login fehlgeschlagen");
    }

    setState(() => _loading = false);
  }

  Future<void> _register() async {
    if (_email.text.isEmpty || _pw.text.isEmpty) {
      _toast("Bitte E-Mail und Passwort eingeben");
      return;
    }

    setState(() => _loading = true);

    try {
      await _client.auth.signUp(
        email: _email.text.trim(),
        password: _pw.text.trim(),
      );
      _toast("Registriert ✅ Jetzt einloggen");
    } catch (e) {
      _toast("Registrierung fehlgeschlagen");
    }

    setState(() => _loading = false);
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  Widget _tf(
    TextEditingController c,
    String label, {
    bool pw = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        obscureText: pw,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FensterPro Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _tf(_email, "E-Mail"),
            _tf(_pw, "Passwort", pw: true),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loading ? null : _login,
              child: _loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Einloggen"),
            ),
            TextButton(
              onPressed: _loading ? null : _register,
              child: const Text("Registrieren"),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================
/// COMPANY GATE (Stub)
/// ===============================
class CompanyGateScreen extends StatelessWidget {
  const CompanyGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "✅ Eingeloggt\nCompany Gate OK",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

