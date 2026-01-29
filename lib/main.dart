import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';


/// =======================================================
/// FENSTERPRO – CLEAN CLOUD APP (SUPABASE ONLY)
/// =======================================================

const String SUPABASE_URL = "https://womnpscrxhmrajcrrkmd.supabase.co";
const String SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndvbW5wc2NyeGhtcmFqY3Jya21kIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg0MDczMTIsImV4cCI6MjA4Mzk4MzMxMn0.e21WwbdjEOMnfQOA-xqxvgEcJ-WCDtYDRTid3qMr_lw";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );

  runApp(const FensterProApp());
}

class FensterProApp extends StatelessWidget {
  const FensterProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FensterPro",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0B6EF3),
      ),
      home: const SupabaseAuthGate(),
    );
  }
}

/// =======================================================
/// AUTH GATE
/// =======================================================

class SupabaseAuthGate extends StatelessWidget {
  const SupabaseAuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;

    return StreamBuilder<AuthState>(
      stream: client.auth.onAuthStateChange,
      builder: (context, snap) {
        final session = client.auth.currentSession;

        if (session == null) {
          return const LoginScreen();
        }

        return const CompanyGateScreen();
      },
    );
  }
}

/// =======================================================
/// LOGIN SCREEN
/// =======================================================

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pw = TextEditingController();
  bool _loading = false;

  Future<void> login() async {
    final email = _email.text.trim();
    final pass = _pw.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      _toast(context, "Bitte E-Mail und Passwort eingeben");
      return;
    }

    setState(() => _loading = true);
    try {
      await Supabase.instance.client.auth
          .signInWithPassword(email: email, password: pass);
    } catch (e) {
      _toast(context, "Login Fehler: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> register() async {
    final email = _email.text.trim();
    final pass = _pw.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      _toast(context, "Bitte E-Mail und Passwort eingeben");
      return;
    }

    setState(() => _loading = true);
    try {
      await Supabase.instance.client.auth
          .signUp(email: email, password: pass);
      _toast(context, "Registriert ✅ Bitte Email bestätigen.");
    } catch (e) {
      _toast(context, "Register Fehler: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FensterPro Login")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _tf(_email, "E-Mail", kb: TextInputType.emailAddress),
            _tf(_pw, "Passwort", pw: true),
            const SizedBox(height: 12),

            FilledButton(
              onPressed: _loading ? null : login,
              child: _loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Einloggen"),
            ),

            TextButton(
              onPressed: _loading ? null : register,
              child: const Text("Registrieren"),
            ),
          ],
        ),
      ),
    );
  }
}

/// =======================================================
/// COMPANY GATE: user muss firma haben (members table)
/// =======================================================

class CompanyGateScreen extends StatefulWidget {
  const CompanyGateScreen({super.key});

  @override
  State<CompanyGateScreen> createState() => _CompanyGateScreenState();
}

class _CompanyGateScreenState extends State<CompanyGateScreen> {
  final _client = Supabase.instance.client;

  bool _loading = true;
  String? _companyId;

  @override
  void initState() {
    super.initState();
    _loadMembership();
  }

  Future<void> _loadMembership() async {
    setState(() => _loading = true);

    final uid = _client.auth.currentUser!.id;

    try {
      final rows = await _client
          .from('members')
          .select('company_id')
          .eq('user_id', uid);

      if (rows is List && rows.isNotEmpty) {
        _companyId = rows.first['company_id'] as String;
      } else {
        _companyId = null;
      }
    } catch (_) {
      _companyId = null;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_companyId == null) {
      return CompanyJoinCreateScreen(onDone: _loadMembership);
    }

    return ProjectsCloudScreen(companyId: _companyId!);
  }
}

class CompanyJoinCreateScreen extends StatefulWidget {
  final Future<void> Function() onDone;
  const CompanyJoinCreateScreen({super.key, required this.onDone});

  @override
  State<CompanyJoinCreateScreen> createState() => _CompanyJoinCreateScreenState();
}

class _CompanyJoinCreateScreenState extends State<CompanyJoinCreateScreen> {
  final _client = Supabase.instance.client;

  final _code = TextEditingController();
  final _name = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    final code = _code.text.trim().toUpperCase();
    if (code.isEmpty) {
      _toast(context, "Bitte Firmencode eingeben");
      return;
    }

    setState(() => _loading = true);
    try {
      final comp = await _client
          .from('companies')
          .select('id')
          .eq('code', code)
          .maybeSingle();

      if (comp == null) {
        _toast(context, "Code nicht gefunden");
        return;
      }

      final uid = _client.auth.currentUser!.id;
      await _client.from('members').insert({
        'user_id': uid,
        'company_id': comp['id'],
      });

      await widget.onDone();
    } catch (e) {
      _toast(context, "Join Fehler: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  String _generateCode() {
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    return "FP${now.substring(now.length - 6)}";
  }

  Future<void> _createCompany() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      _toast(context, "Bitte Firmenname eingeben");
      return;
    }

    setState(() => _loading = true);

    try {
      final code = _generateCode();

      final inserted = await _client.from('companies').insert({
        'name': name,
        'code': code,
      }).select('id, code').single();

      final uid = _client.auth.currentUser!.id;
      await _client.from('members').insert({
        'user_id': uid,
        'company_id': inserted['id'],
      });

      _toast(context, "Firma erstellt ✅ Code: ${inserted['code']}");
      await widget.onDone();
    } catch (e) {
      _toast(context, "Create Fehler: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _tf(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Firma auswählen"),
        actions: [
          IconButton(
            onPressed: () async {
              await _client.auth.signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: ListView(
          children: [
            Text("Angemeldet als: ${user?.email ?? '-'}",
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 14),

            const Text("Beitreten", style: TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            _tf(_code, "Firmencode"),
            FilledButton(
              onPressed: _loading ? null : _join,
              child: const Text("Firma beitreten"),
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),

            const Text("Neue Firma erstellen",
                style: TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            _tf(_name, "Firmenname"),
            FilledButton(
              onPressed: _loading ? null : _createCompany,
              child: const Text("Firma erstellen"),
            ),
          ],
        ),
      ),
    );
  }
}

/// =======================================================
/// PROJECTS (CLOUD)
/// =======================================================

class ProjectsCloudScreen extends StatefulWidget {
  final String companyId;
  const ProjectsCloudScreen({super.key, required this.companyId});

  @override
  State<ProjectsCloudScreen> createState() => _ProjectsCloudScreenState();
}

class _ProjectsCloudScreenState extends State<ProjectsCloudScreen> {
  final _client = Supabase.instance.client;

  bool _loading = true;
  String? _err;
  List<Map<String, dynamic>> _projects = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _err = null;
    });

    try {
      final res = await _client
          .from('projects')
          .select('id, name, customer, address, created_at')
          .eq('company_id', widget.companyId)
          .order('created_at', ascending: false);

      _projects = List<Map<String, dynamic>>.from(res);
    } catch (e) {
      _err = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _newProject() async {
    final created = await Navigator.push<Map<String, String>?>(
      context,
      MaterialPageRoute(builder: (_) => const ProjectFormScreen()),
    );
    if (created == null) return;

    try {
      await _client.from('projects').insert({
        'company_id': widget.companyId,
        'name': created['name'],
        'customer': created['customer'],
        'address': created['address'],
      });
      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  Future<void> _deleteProject(String id) async {
    try {
      await _client.from('projects').delete().eq('id', id);
      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Projekte (Cloud)"),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
          IconButton(
            onPressed: () async {
              await _client.auth.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newProject,
        icon: const Icon(Icons.add),
        label: const Text("Neues Projekt"),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _err != null
              ? Center(child: Text(_err!))
              : _projects.isEmpty
                  ? const _EmptyState(text: "Noch keine Projekte.\nTippe auf „Neues Projekt“. ")
                  : ListView.separated(
                      padding: const EdgeInsets.all(14),
                      itemCount: _projects.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final p = _projects[i];
                        final id = p['id'] as String;
                        final name = (p['name'] ?? '') as String;
                        final customer = (p['customer'] ?? '') as String;

                        return _ListCard(
                          title: name,
                          subtitle: customer.isEmpty ? "—" : customer,
                          trailing: IconButton(
                            onPressed: () => _deleteProject(id),
                            icon: const Icon(Icons.delete),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RoomsCloudScreen(
                                projectId: id,
                                projectName: name,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}

class ProjectFormScreen extends StatefulWidget {
  const ProjectFormScreen({super.key});

  @override
  State<ProjectFormScreen> createState() => _ProjectFormScreenState();
}

class _ProjectFormScreenState extends State<ProjectFormScreen> {
  final _name = TextEditingController();
  final _customer = TextEditingController();
  final _address = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _customer.dispose();
    _address.dispose();
    super.dispose();
  }

  Widget _tf(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Neues Projekt")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: ListView(
          children: [
            _tf(_name, "Projektname *"),
            _tf(_customer, "Kunde (optional)"),
            _tf(_address, "Adresse (optional)"),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () {
                final name = _name.text.trim();
                if (name.isEmpty) {
                  _toast(context, "Projektname fehlt");
                  return;
                }
                Navigator.pop(context, {
                  "name": name,
                  "customer": _customer.text.trim(),
                  "address": _address.text.trim(),
                });
              },
              icon: const Icon(Icons.check),
              label: const Text("Speichern"),
            )
          ],
        ),
      ),
    );
  }
}

/// =======================================================
/// ROOMS (CLOUD)
/// =======================================================

class RoomsCloudScreen extends StatefulWidget {
  final String projectId;
  final String projectName;

  const RoomsCloudScreen({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  @override
  State<RoomsCloudScreen> createState() => _RoomsCloudScreenState();
}

class _RoomsCloudScreenState extends State<RoomsCloudScreen> {
  final _client = Supabase.instance.client;

  bool _loading = true;
  String? _err;
  List<Map<String, dynamic>> _rooms = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _err = null;
    });

    try {
      final res = await _client
          .from('rooms')
          .select('id, name, created_at')
          .eq('project_id', widget.projectId)
          .order('created_at', ascending: false);

      _rooms = List<Map<String, dynamic>>.from(res);
    } catch (e) {
      _err = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _newRoom() async {
    final name = await _askText(context,
        title: "Neuer Raum", hint: "z.B. Wohnzimmer");
    if (name == null) return;

    try {
      await _client.from('rooms').insert({
        'project_id': widget.projectId,
        'name': name,
      });
      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  Future<void> _deleteRoom(String id) async {
    try {
      await _client.from('rooms').delete().eq('id', id);
      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Räume • ${widget.projectName}"),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _newRoom,
        icon: const Icon(Icons.add),
        label: const Text("Neuer Raum"),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _err != null
              ? Center(child: Text(_err!))
              : _rooms.isEmpty
                  ? const _EmptyState(text: "Noch keine Räume.\nTippe auf „Neuer Raum“. ")
                  : ListView.separated(
                      padding: const EdgeInsets.all(14),
                      itemCount: _rooms.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final r = _rooms[i];
                        final id = r['id'] as String;
                        final name = (r['name'] ?? '') as String;

                        return _ListCard(
                          title: name,
                          subtitle: "Aufmaß erfassen",
                          trailing: IconButton(
                            onPressed: () => _deleteRoom(id),
                            icon: const Icon(Icons.delete),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RoomMenuScreen(
                                projectId: widget.projectId,
                                projectName: widget.projectName,
                                roomId: id,
                                roomName: name,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}

/// =======================================================
/// ROOM MENU (KATEGORIEN + PDF)
/// =======================================================

class RoomMenuScreen extends StatelessWidget {
  final String projectId;
  final String projectName;
  final String roomId;
  final String roomName;

  const RoomMenuScreen({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.roomId,
    required this.roomName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(roomName)),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.25,
              children: [
                _BigButton(
                  icon: Icons.window,
                  title: "Fenster",
                  subtitle: "Profi Aufmaß",
                  onTap: () async {
                    final ok = await Navigator.push<bool?>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FensterFormProScreen(roomId: roomId),
                      ),
                    );
                    if (ok == true) {
                      _toast(context, "Fenster gespeichert ✅");
                    }
                  },
                ),
                _BigButton(
                  icon: Icons.door_front_door,
                  title: "Zimmertüren",
                  subtitle: "Cloud",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ItemsCloudListScreen(
                        roomId: roomId,
                        roomName: roomName,
                        type: "zimmertuer",
                        typeLabel: "Zimmertüren",
                      ),
                    ),
                  ),
                ),
                _BigButton(
                  icon: Icons.meeting_room,
                  title: "Haustüren",
                  subtitle: "Cloud",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ItemsCloudListScreen(
                        roomId: roomId,
                        roomName: roomName,
                        type: "haustuer",
                        typeLabel: "Haustüren",
                      ),
                    ),
                  ),
                ),
                _BigButton(
                  icon: Icons.blinds,
                  title: "Rollladen",
                  subtitle: "Cloud",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ItemsCloudListScreen(
                        roomId: roomId,
                        roomName: roomName,
                        type: "rolladen",
                        typeLabel: "Rollladen",
                      ),
                    ),
                  ),
                ),
                _BigButton(
                  icon: Icons.bug_report,
                  title: "Fliegengitter",
                  subtitle: "Cloud",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ItemsCloudListScreen(
                        roomId: roomId,
                        roomName: roomName,
                        type: "fliegengitter",
                        typeLabel: "Fliegengitter",
                      ),
                    ),
                  ),
                ),
                _BigButton(
                  icon: Icons.roofing,
                  title: "Dachfenster",
                  subtitle: "Cloud",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ItemsCloudListScreen(
                        roomId: roomId,
                        roomName: roomName,
                        type: "dachfenster",
                        typeLabel: "Dachfenster",
                      ),
                    ),
                  ),
                ),
                _BigButton(
                  icon: Icons.picture_as_pdf,
                  title: "PDF Aufmaß",
                  subtitle: "Profi Layout",
                  onTap: () => exportRoomPdf(
                    context: context,
                    projectId: projectId,
                    projectName: projectName,
                    roomId: roomId,
                    roomName: roomName,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const _InfoBox(
              lines: [
                "Alles wird in der Supabase Cloud gespeichert.",
                "Fenster hat Profi-Aufmaß mit Fotos.",
              ],
            ),
          ],
        ),
      ),
    );
  }
}


/// =======================================================
/// GENERIC ITEMS LIST (CLOUD)
/// =======================================================

class ItemsCloudListScreen extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String type;
  final String typeLabel;

  const ItemsCloudListScreen({
    super.key,
    required this.roomId,
    required this.roomName,
    required this.type,
    required this.typeLabel,
  });

  @override
  State<ItemsCloudListScreen> createState() => _ItemsCloudListScreenState();
}

class _ItemsCloudListScreenState extends State<ItemsCloudListScreen> {
  final _client = Supabase.instance.client;

  bool _loading = true;
  String? _err;
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _err = null;
    });

    try {
      final res = await _client
          .from('items')
          .select('id, type, data, created_at')
          .eq('room_id', widget.roomId)
          .eq('type', widget.type)
          .order('created_at', ascending: false);

      _items = List<Map<String, dynamic>>.from(res);
    } catch (e) {
      _err = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _add() async {
    final data = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(
        builder: (_) => ItemFormScreen(
          type: widget.type,
          typeLabel: widget.typeLabel,
        ),
      ),
    );

    if (data == null) return;

    try {
      await _client.from('items').insert({
        'room_id': widget.roomId,
        'type': widget.type,
        'data': data,
      });
      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  Future<void> _delete(String id) async {
    try {
      await _client.from('items').delete().eq('id', id);
      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  String _headline(Map<String, dynamic> data) {
    // versucht ein "Nr" Feld automatisch zu finden
    final candidates = [
      "fensterNr",
      "tuerNr",
      "haustuerNr",
      "rolladenNr",
      "gitterNr",
      "dachfensterNr"
    ];
    for (final k in candidates) {
      if (data[k] != null && data[k].toString().trim().isNotEmpty) {
        return "${widget.typeLabel} ${data[k]}";
      }
    }
    return widget.typeLabel;
  }

  String _subtitle(Map<String, dynamic> data) {
    final b = (data["breiteMm"] ?? "").toString();
    final h = (data["hoeheMm"] ?? "").toString();
    if (b.isNotEmpty && h.isNotEmpty) return "$b × $h mm";

    // fallback: erstes Feld
    if (data.entries.isNotEmpty) {
      final first = data.entries.first;
      return "${first.key}: ${first.value}";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.typeLabel} • ${widget.roomName}"),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text("Neu"),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _err != null
              ? Center(child: Text(_err!))
              : _items.isEmpty
                  ? const _EmptyState(text: "Noch keine Einträge.\nTippe auf „Neu“. ")
                  : ListView.separated(
                      padding: const EdgeInsets.all(14),
                      itemCount: _items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final row = _items[i];
                        final id = row['id'] as String;
                        final data = (row['data'] as Map).cast<String, dynamic>();

                        return _ListCard(
                          title: _headline(data),
                          subtitle: _subtitle(data),
                          trailing: IconButton(
                            onPressed: () => _delete(id),
                            icon: const Icon(Icons.delete),
                          ),
                          onTap: () => _showDetails(context, data),
                        );
                      },
                    ),
    );
  }

  void _showDetails(BuildContext context, Map<String, dynamic> data) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_headline(data),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),
              ...data.entries.map((e) => _kv(e.key, e.value.toString())).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

/// =======================================================
/// ITEM FORM (GENERIC) – Pflicht: Nr + Breite + Höhe + Notizen
/// Du kannst das später pro Typ perfektionieren.
/// =======================================================

class ItemFormScreen extends StatefulWidget {
  final String type;
  final String typeLabel;

  const ItemFormScreen({
    super.key,
    required this.type,
    required this.typeLabel,
  });

  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _nr = TextEditingController();
  final _breite = TextEditingController();
  final _hoehe = TextEditingController();
  final _notizen = TextEditingController();

  @override
  void dispose() {
    _nr.dispose();
    _breite.dispose();
    _hoehe.dispose();
    _notizen.dispose();
    super.dispose();
  }

  String _nrKey() {
    switch (widget.type) {
      case "fenster":
        return "fensterNr";
      case "zimmertuer":
        return "tuerNr";
      case "haustuer":
        return "haustuerNr";
      case "rolladen":
        return "rolladenNr";
      case "fliegengitter":
        return "gitterNr";
      case "dachfenster":
        return "dachfensterNr";
      default:
        return "nr";
    }
  }

  Widget _tf(TextEditingController c, String label,
      {TextInputType kb = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        keyboardType: kb,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Neu: ${widget.typeLabel}")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: ListView(
          children: [
            _tf(_nr, "${widget.typeLabel} Nr. *"),
            _tf(_breite, "Breite (mm) *", kb: TextInputType.number),
            _tf(_hoehe, "Höhe (mm) *", kb: TextInputType.number),
            _tf(_notizen, "Notizen (optional)"),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: () {
                final nr = _nr.text.trim();
                final b = _breite.text.trim();
                final h = _hoehe.text.trim();

                if (nr.isEmpty || b.isEmpty || h.isEmpty) {
                  _toast(context, "Bitte Pflichtfelder ausfüllen");
                  return;
                }

                final data = <String, dynamic>{
                  _nrKey(): nr,
                  "breiteMm": b,
                  "hoeheMm": h,
                  "notizen": _notizen.text.trim(),
                };

                Navigator.pop(context, data);
              },
              icon: const Icon(Icons.check),
              label: const Text("Speichern"),
            ),
          ],
        ),
      ),
    );
  }
}

class FensterFormProScreen extends StatefulWidget {
  final String roomId;

  const FensterFormProScreen({
    super.key,
    required this.roomId,
  });

  @override
  State<FensterFormProScreen> createState() => _FensterFormProScreenState();
}

class _FensterFormProScreenState extends State<FensterFormProScreen> {
  final _formKey = GlobalKey<FormState>();

  // Pflicht
  final _fensterNr = TextEditingController();
  final _breite = TextEditingController();
  final _hoehe = TextEditingController();
  final _farbe = TextEditingController();

  // Optional
  final _notizen = TextEditingController();

  // Dropdowns
  String _oeffnung = "Dreh-Kipp";
  String _anschlag = "DIN Links";
  String _rahmen = "Kunststoff";
  String _glasart = "2-fach";
  String _glasdicke = "24 mm";
  String _sicherheit = "Standard";
  bool _barrierefrei = false;

  // Fotos (Pflicht min 1)
  final _picker = ImagePicker();
  final List<XFile> _photos = [];

  @override
  void dispose() {
    _fensterNr.dispose();
    _breite.dispose();
    _hoehe.dispose();
    _farbe.dispose();
    _notizen.dispose();
    super.dispose();
  }

  Future<void> _addPhotoCamera() async {
    final shot = await _picker.pickImage(source: ImageSource.camera, imageQuality: 75);
    if (shot == null) return;
    setState(() => _photos.add(shot));
  }

  Future<void> _addPhotoGallery() async {
    final shot = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (shot == null) return;
    setState(() => _photos.add(shot));
  }

  void _removePhoto(int index) {
    setState(() => _photos.removeAt(index));
  }

  Future<List<String>> _uploadPhotosToSupabase(String itemId) async {
    final client = Supabase.instance.client;

    // Upload-Pfade: fensterfotos/<roomId>/<itemId>/<timestamp>.jpg
    final List<String> publicUrls = [];

    for (final p in _photos) {
      final file = File(p.path);
      final bytes = await file.readAsBytes();

      final ext = p.path.toLowerCase().endsWith(".png") ? "png" : "jpg";
      final path =
          "${widget.roomId}/$itemId/${DateTime.now().microsecondsSinceEpoch}.$ext";

      await client.storage.from("fensterfotos").uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: ext == "png" ? "image/png" : "image/jpeg",
              upsert: true,
            ),
          );

      final url = client.storage.from("fensterfotos").getPublicUrl(path);
      publicUrls.add(url);
    }

    return publicUrls;
  }

  Widget _tf(TextEditingController c, String label,
      {TextInputType kb = TextInputType.text}) {
    final required = label.contains("*");
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: c,
        keyboardType: kb,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
        validator: (v) {
          if (!required) return null;
          if (v == null || v.trim().isEmpty) return "Pflichtfeld";
          return null;
        },
      ),
    );
  }

  Widget _dd({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String v) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (v) => onChanged(v ?? value),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    if (_photos.isEmpty) {
      _toast(context, "Mindestens 1 Foto ist Pflicht 📸");
      return;
    }

    final client = Supabase.instance.client;

    try {
      // 1) item row anlegen ohne fotos
      final inserted = await client.from("items").insert({
        "room_id": widget.roomId,
        "type": "fenster",
        "data": {
          "fensterNr": _fensterNr.text.trim(),
          "breiteMm": _breite.text.trim(),
          "hoeheMm": _hoehe.text.trim(),
          "oeffnungsart": _oeffnung,
          "anschlagsrichtung": _anschlag,
          "rahmenart": _rahmen,
          "farbe": _farbe.text.trim(),
          "glasart": _glasart,
          "glasdicke": _glasdicke,
          "sicherheitsstufe": _sicherheit,
          "barrierefrei": _barrierefrei ? "Ja" : "Nein",
          "notizen": _notizen.text.trim(),
          "fotos": [], // später update
        }
      }).select("id").single();

      final itemId = inserted["id"] as String;

      // 2) fotos hochladen
      final urls = await _uploadPhotosToSupabase(itemId);

      // 3) item update mit foto-urls
      await client.from("items").update({
        "data": {
          "fensterNr": _fensterNr.text.trim(),
          "breiteMm": _breite.text.trim(),
          "hoeheMm": _hoehe.text.trim(),
          "oeffnungsart": _oeffnung,
          "anschlagsrichtung": _anschlag,
          "rahmenart": _rahmen,
          "farbe": _farbe.text.trim(),
          "glasart": _glasart,
          "glasdicke": _glasdicke,
          "sicherheitsstufe": _sicherheit,
          "barrierefrei": _barrierefrei ? "Ja" : "Nein",
          "notizen": _notizen.text.trim(),
          "fotos": urls,
        }
      }).eq("id", itemId);

      Navigator.pop(context, true);
    } catch (e) {
      _toast(context, "Fehler beim Speichern: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fenster • Profi Aufmaß")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text("Pflichtfelder",
                  style: TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 10),

              _tf(_fensterNr, "FensterNr. *"),
              Row(
                children: [
                  Expanded(
                    child: _tf(_breite, "Breite (mm) *",
                        kb: TextInputType.number),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _tf(_hoehe, "Höhe (mm) *", kb: TextInputType.number),
                  ),
                ],
              ),

              _dd(
                label: "Öffnungsart *",
                value: _oeffnung,
                items: const [
                  "Dreh-Kipp",
                  "Dreh",
                  "Kipp",
                  "Schiebe",
                  "Festverglasung"
                ],
                onChanged: (v) => setState(() => _oeffnung = v),
              ),

              _dd(
                label: "Anschlagsrichtung *",
                value: _anschlag,
                items: const ["DIN Links", "DIN Rechts", "—"],
                onChanged: (v) => setState(() => _anschlag = v),
              ),

              _dd(
                label: "Rahmenart *",
                value: _rahmen,
                items: const ["Kunststoff", "Holz", "Aluminium", "Holz-Alu"],
                onChanged: (v) => setState(() => _rahmen = v),
              ),

              _tf(_farbe, "Farbe *"),

              _dd(
                label: "Glasart *",
                value: _glasart,
                items: const ["2-fach", "3-fach", "Sicherheitsglas", "Schallschutz"],
                onChanged: (v) => setState(() => _glasart = v),
              ),

              _dd(
                label: "Glasdicke *",
                value: _glasdicke,
                items: const ["24 mm", "28 mm", "32 mm", "36 mm", "40 mm", "44 mm"],
                onChanged: (v) => setState(() => _glasdicke = v),
              ),

              _dd(
                label: "Sicherheitsstufe *",
                value: _sicherheit,
                items: const ["Standard", "RC1", "RC2", "RC3"],
                onChanged: (v) => setState(() => _sicherheit = v),
              ),

              SwitchListTile(
                value: _barrierefrei,
                onChanged: (v) => setState(() => _barrierefrei = v),
                title: const Text("Barrierefrei"),
              ),

              const SizedBox(height: 10),
              const Text("Fotos (Pflicht) 📸",
                  style: TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _addPhotoCamera,
                      icon: const Icon(Icons.photo_camera),
                      label: const Text("Kamera"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _addPhotoGallery,
                      icon: const Icon(Icons.image),
                      label: const Text("Galerie"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              if (_photos.isEmpty)
                const Text("Noch keine Fotos hinzugefügt.",
                    style: TextStyle(color: Colors.black54)),

              if (_photos.isNotEmpty)
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: List.generate(_photos.length, (i) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_photos[i].path),
                            width: 110,
                            height: 110,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: InkWell(
                            onTap: () => _removePhoto(i),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),

              const SizedBox(height: 14),
              _tf(_notizen, "Notizen (optional)"),

              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: const Text("Fenster speichern"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =======================================================
/// PDF EXPORT PROFI: NUR EIN RAUM (aus Supabase)
/// =======================================================

Future<void> exportRoomPdf({
  required BuildContext context,
  required String projectId,
  required String projectName,
  required String roomId,
  required String roomName,
}) async {
  final client = Supabase.instance.client;

  try {
    // Projektinfos (optional)
    final projRes = await client
        .from('projects')
        .select('id, name, customer, address')
        .eq('id', projectId)
        .single();

    final proj = (projRes as Map).cast<String, dynamic>();
    final customer = (proj['customer'] ?? '') as String;
    final address = (proj['address'] ?? '') as String;

    final itemsRes = await client
        .from('items')
        .select('id, room_id, type, data, created_at')
        .eq('room_id', roomId)
        .order('created_at', ascending: true);

    final items = List<Map<String, dynamic>>.from(itemsRes);

    final doc = pw.Document();
    final now = DateTime.now();
    final df = DateFormat('dd.MM.yyyy – HH:mm');

    const primary = PdfColor.fromInt(0xFF0B6EF3);
    const dark = PdfColor.fromInt(0xFF1B1B1B);
    const lightGrey = PdfColor.fromInt(0xFFECEFF3);

    pw.TextStyle h1 =
        pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: dark);
    pw.TextStyle h2 =
        pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: dark);
    pw.TextStyle small =
        const pw.TextStyle(fontSize: 9, color: PdfColors.grey700);
    pw.TextStyle body =
        const pw.TextStyle(fontSize: 10, color: PdfColors.black);

    String typeLabel(String t) {
      switch (t) {
        case 'fenster':
          return 'Fenster';
        case 'zimmertuer':
          return 'Zimmertüren';
        case 'haustuer':
          return 'Haustüren';
        case 'rolladen':
          return 'Rollladen';
        case 'fliegengitter':
          return 'Fliegengitter';
        case 'dachfenster':
          return 'Dachfenster';
        default:
          return t;
      }
    }

    pw.Widget header() {
      return pw.Container(
        padding: const pw.EdgeInsets.only(bottom: 10),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Container(
              width: 28,
              height: 28,
              decoration: pw.BoxDecoration(
                color: primary,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Center(
                child: pw.Text("FP",
                    style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white)),
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text("FensterPro – Aufmaß", style: h2),
                  pw.Text("$projectName • $roomName", style: small),
                ],
              ),
            ),
            pw.Text(df.format(now), style: small),
          ],
        ),
      );
    }

    pw.Widget footer(pw.Context ctx) {
      return pw.Container(
        padding: const pw.EdgeInsets.only(top: 10),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text("FensterPro", style: small),
            pw.Text("Seite ${ctx.pageNumber} / ${ctx.pagesCount}", style: small),
          ],
        ),
      );
    }

    pw.Widget infoBox({required String title, required List<String> lines}) {
      return pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: lightGrey,
          borderRadius: pw.BorderRadius.circular(10),
          border: pw.Border.all(color: PdfColors.grey300),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title,
                style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: dark)),
            pw.SizedBox(height: 6),
            ...lines.map((l) => pw.Text(l, style: body)).toList(),
          ],
        ),
      );
    }

    // grouping
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final it in items) {
      final t = (it['type'] ?? '') as String;
      grouped.putIfAbsent(t, () => []);
      grouped[t]!.add(it);
    }

    final order = [
      'fenster',
      'zimmertuer',
      'haustuer',
      'rolladen',
      'fliegengitter',
      'dachfenster'
    ];

    pw.Widget tableForType(String type, List<Map<String, dynamic>> rows) {
      final headers = ["Nr", "BxH (mm)", "Info"];
      final data = rows.map((row) {
        final d = (row['data'] as Map).cast<String, dynamic>();

        String nr = "";
        for (final k in [
          "fensterNr",
          "tuerNr",
          "haustuerNr",
          "rolladenNr",
          "gitterNr",
          "dachfensterNr"
        ]) {
          if (d[k] != null && d[k].toString().trim().isNotEmpty) {
            nr = d[k].toString();
            break;
          }
        }

        final b = (d["breiteMm"] ?? "").toString();
        final h = (d["hoeheMm"] ?? "").toString();
        final note = (d["notizen"] ?? "").toString();

        return [nr, "${b}×${h}", note];
      }).toList();

      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            decoration: pw.BoxDecoration(
              color: primary,
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Text("${typeLabel(type)} (${rows.length})",
                style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white)),
          ),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: headers,
            data: data,
            cellStyle: const pw.TextStyle(fontSize: 9),
            headerStyle:
                pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            headerDecoration:
                const pw.BoxDecoration(color: PdfColors.grey200),
            cellAlignment: pw.Alignment.centerLeft,
            columnWidths: {0: const pw.FixedColumnWidth(60)},
            border: pw.TableBorder.all(color: PdfColors.grey300),
          ),
          pw.SizedBox(height: 12),
        ],
      );
    }

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        header: (_) => header(),
        footer: (ctx) => footer(ctx),
        build: (ctx) {
          final w = <pw.Widget>[];

          w.add(pw.Text("Aufmaß Raum", style: h1));
          w.add(pw.SizedBox(height: 10));

          w.add(
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  child: infoBox(
                    title: "Projekt",
                    lines: [
                      "Projekt: $projectName",
                      "Raum: $roomName",
                      "Kunde: ${customer.isEmpty ? "—" : customer}",
                      "Adresse: ${address.isEmpty ? "—" : address}",
                      "Export: ${df.format(now)}",
                    ],
                  ),
                ),
                pw.SizedBox(width: 12),
                pw.Expanded(
                  child: infoBox(
                    title: "Übersicht",
                    lines: [
                      "Positionen: ${items.length}",
                      "Einheit: mm",
                      "Quelle: Supabase Cloud",
                    ],
                  ),
                ),
              ],
            ),
          );

          w.add(pw.SizedBox(height: 14));

          if (items.isEmpty) {
            w.add(pw.Text("Keine Elemente in diesem Raum.", style: body));
            return w;
          }

          for (final t in order) {
            final list = grouped[t] ?? [];
            if (list.isEmpty) continue;
            w.add(tableForType(t, list));
          }

          for (final entry in grouped.entries) {
            if (order.contains(entry.key)) continue;
            w.add(tableForType(entry.key, entry.value));
          }

          w.add(pw.SizedBox(height: 14));
          w.add(pw.Text("Unterschrift Monteur: ____________________________", style: small));
          w.add(pw.SizedBox(height: 6));
          w.add(pw.Text("Unterschrift Kunde:   ____________________________", style: small));

          return w;
        },
      ),
    );

    final Uint8List bytes = await doc.save();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => bytes,
      name:
          "FensterPro_Aufmass_${projectName.replaceAll(' ', '_')}_${roomName.replaceAll(' ', '_')}.pdf",
    );
  } catch (e) {
    _toast(context, "PDF Fehler: $e");
  }
}

/// =======================================================
/// UI HELPERS
/// =======================================================

class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black54),
      ),
    );
  }
}

class _BigButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _BigButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE6E6E6)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28),
            const Spacer(),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final List<String> lines;
  const _InfoBox({required this.lines});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFFF1F5FF),
        border: Border.all(color: const Color(0xFFE0E7FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines.map((l) => Text("• $l")).toList(),
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  const _ListCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE6E6E6)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

Widget _kv(String k, String v) => Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(k, style: const TextStyle(fontWeight: FontWeight.w800)),
          ),
          Expanded(child: Text(v)),
        ],
      ),
    );

void _toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg)),
  );
}

Future<String?> _askText(
  BuildContext context, {
  required String title,
  required String hint,
}) async {
  final c = TextEditingController();

  final res = await showDialog<String?>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: TextField(
        controller: c,
        decoration: InputDecoration(hintText: hint),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Abbrechen"),
        ),
        FilledButton(
          onPressed: () {
            final v = c.text.trim();
            if (v.isEmpty) return;
            Navigator.pop(context, v);
          },
          child: const Text("OK"),
        ),
      ],
    ),
  );

  return res;
}
