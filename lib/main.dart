import 'package:flutter/material.dart';

void main() => runApp(const FensterProApp());

class FensterProApp extends StatelessWidget {
  const FensterProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FensterPro – Aufmaß für Bauelemente',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const ProjectHomeScreen(),
    );
  }
}

/// ===============================
/// MODELS
/// ===============================
class Project {
  final String id;
  final String name;
  final String customer;
  final String address;
  final DateTime createdAt;
  final List<Room> rooms;

  Project({
    required this.id,
    required this.name,
    required this.customer,
    required this.address,
    required this.createdAt,
    required this.rooms,
  });
}

class Room {
  final String id;
  final String name;
  final List<FensterItem> fenster;
  final List<TuerItem> tueren;

  Room({
    required this.id,
    required this.name,
    required this.fenster,
    required this.tueren,
  });
}

class FensterItem {
  final String fensterNr;
  final String breiteMm;
  final String hoeheMm;
  final String oeffnungsart;
  final String anschlagsrichtung;
  final String rahmenart;
  final String farbe;
  final String glasart;
  final String glasDicke;
  final String sicherheitsstufe;
  final String barrierefrei; // ja/nein
  final String notizen;

  const FensterItem({
    required this.fensterNr,
    required this.breiteMm,
    required this.hoeheMm,
    required this.oeffnungsart,
    required this.anschlagsrichtung,
    required this.rahmenart,
    required this.farbe,
    required this.glasart,
    required this.glasDicke,
    required this.sicherheitsstufe,
    required this.barrierefrei,
    required this.notizen,
  });
}

class TuerItem {
  final String tuerNr;
  final String breiteMm;
  final String hoeheMm;
  final String din;
  final String oeffnungsrichtung;
  final String zarge;
  final String wandstaerkeMm;
  final String tuerblatt;
  final String farbe;
  final String schlossGarnitur;
  final String barrierefrei;
  final String notizen;

  const TuerItem({
    required this.tuerNr,
    required this.breiteMm,
    required this.hoeheMm,
    required this.din,
    required this.oeffnungsrichtung,
    required this.zarge,
    required this.wandstaerkeMm,
    required this.tuerblatt,
    required this.farbe,
    required this.schlossGarnitur,
    required this.barrierefrei,
    required this.notizen,
  });
}

/// ===============================
/// APP STATE (einfach, offline)
/// ===============================
class AppState extends ChangeNotifier {
  final List<Project> projects = [];

  void addProject(Project p) {
    projects.insert(0, p);
    notifyListeners();
  }

  void deleteProject(String projectId) {
    projects.removeWhere((p) => p.id == projectId);
    notifyListeners();
  }

  void addRoom(String projectId, Room room) {
    final p = projects.firstWhere((p) => p.id == projectId);
    p.rooms.insert(0, room);
    notifyListeners();
  }

  void addFenster(String projectId, String roomId, FensterItem item) {
    final p = projects.firstWhere((p) => p.id == projectId);
    final r = p.rooms.firstWhere((r) => r.id == roomId);
    r.fenster.add(item);
    notifyListeners();
  }

  void addTuer(String projectId, String roomId, TuerItem item) {
    final p = projects.firstWhere((p) => p.id == projectId);
    final r = p.rooms.firstWhere((r) => r.id == roomId);
    r.tueren.add(item);
    notifyListeners();
  }
}

/// ===============================
/// HOME: Projekte
/// ===============================
class ProjectHomeScreen extends StatefulWidget {
  const ProjectHomeScreen({super.key});

  @override
  State<ProjectHomeScreen> createState() => _ProjectHomeScreenState();
}

class _ProjectHomeScreenState extends State<ProjectHomeScreen> {
  final state = AppState();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('FensterPro – Aufmaß für Bauelemente'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final created = await Navigator.push<Project?>(
                context,
                MaterialPageRoute(builder: (_) => const CreateProjectScreen()),
              );
              if (created != null) state.addProject(created);
            },
            icon: const Icon(Icons.add),
            label: const Text("Neues Projekt"),
          ),
          body: state.projects.isEmpty
              ? const _EmptyState(
                  text:
                      "Noch keine Projekte.\nTippe auf „Neues Projekt“, um zu starten.",
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(14),
                  itemCount: state.projects.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final p = state.projects[i];
                    return Dismissible(
                      key: ValueKey(p.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 16),
                        child: const Icon(Icons.delete, color: Colors.red),
                      ),
                      onDismissed: (_) => state.deleteProject(p.id),
                      child: _ListCard(
                        title: p.name,
                        subtitle:
                            "${p.customer.isEmpty ? "—" : p.customer} • Räume: ${p.rooms.length}",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProjectDetailScreen(
                                state: state,
                                projectId: p.id,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

/// ===============================
/// Create Project Screen
/// ===============================
class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _formKey = GlobalKey<FormState>();
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

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final p = Project(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: _name.text.trim(),
      customer: _customer.text.trim(),
      address: _address.text.trim(),
      createdAt: DateTime.now(),
      rooms: [],
    );
    Navigator.pop(context, p);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Neues Projekt")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _tf(_name, "Projektname *"),
              _tf(_customer, "Kunde (optional)"),
              _tf(_address, "Adresse (optional)"),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: const Text("Projekt speichern"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _tf(TextEditingController c, String label) {
    final required = label.contains("*");
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: c,
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
}

/// ===============================
/// Project Detail
/// ===============================
class ProjectDetailScreen extends StatelessWidget {
  final AppState state;
  final String projectId;

  const ProjectDetailScreen({
    super.key,
    required this.state,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    final p = state.projects.firstWhere((p) => p.id == projectId);

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final proj = state.projects.firstWhere((x) => x.id == projectId);
        return Scaffold(
          appBar: AppBar(
            title: Text(proj.name),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              final name = await _askRoomName(context);
              if (name == null) return;
              state.addRoom(
                projectId,
                Room(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  name: name,
                  fenster: [],
                  tueren: [],
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text("Raum hinzufügen"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoBox(
                  lines: [
                    "Kunde: ${proj.customer.isEmpty ? "—" : proj.customer}",
                    "Adresse: ${proj.address.isEmpty ? "—" : proj.address}",
                    "Erstellt: ${proj.createdAt.day}.${proj.createdAt.month}.${proj.createdAt.year}",
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  "Räume",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: proj.rooms.isEmpty
                      ? const _EmptyState(text: "Noch keine Räume.\nTippe auf „Raum hinzufügen“. ")
                      : ListView.separated(
                          itemCount: proj.rooms.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final r = proj.rooms[i];
                            return _ListCard(
                              title: r.name,
                              subtitle:
                                  "Fenster: ${r.fenster.length} • Türen: ${r.tueren.length}",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => RoomDetailScreen(
                                      state: state,
                                      projectId: proj.id,
                                      roomId: r.id,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> _askRoomName(BuildContext context) async {
    final c = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Raumname"),
        content: TextField(
          controller: c,
          decoration: const InputDecoration(hintText: "z.B. Wohnzimmer"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Abbrechen")),
          FilledButton(
            onPressed: () {
              final v = c.text.trim();
              if (v.isEmpty) return;
              Navigator.pop(context, v);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }
}

/// ===============================
/// Room Detail
/// ===============================
class RoomDetailScreen extends StatelessWidget {
  final AppState state;
  final String projectId;
  final String roomId;

  const RoomDetailScreen({
    super.key,
    required this.state,
    required this.projectId,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    final p = state.projects.firstWhere((p) => p.id == projectId);
    final r = p.rooms.firstWhere((r) => r.id == roomId);

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final pp = state.projects.firstWhere((p) => p.id == projectId);
        final rr = pp.rooms.firstWhere((r) => r.id == roomId);

        return Scaffold(
          appBar: AppBar(title: Text(rr.name)),
          body: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _BigButton(
                        icon: Icons.window,
                        title: "Fenster",
                        subtitle: "Erfassen / ansehen",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FensterListScreen(
                              title: "Fenster • ${rr.name}",
                              getItems: () => rr.fenster,
                              onAdd: (item) => state.addFenster(projectId, roomId, item),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _BigButton(
                        icon: Icons.door_front_door,
                        title: "Zimmertüren",
                        subtitle: "Erfassen / ansehen",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TuerenListScreen(
                              title: "Zimmertüren • ${rr.name}",
                              getItems: () => rr.tueren,
                              onAdd: (item) => state.addTuer(projectId, roomId, item),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _InfoBox(
                  lines: [
                    "Fenster erfasst: ${rr.fenster.length}",
                    "Zimmertüren erfasst: ${rr.tueren.length}",
                    "Tipp: Alles offline. Export (PDF/Excel) folgt als nächstes.",
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// ===============================
/// Fenster Screens (Room-based)
/// ===============================
class FensterListScreen extends StatefulWidget {
  final String title;
  final List<FensterItem> Function() getItems;
  final void Function(FensterItem item) onAdd;

  const FensterListScreen({
    super.key,
    required this.title,
    required this.getItems,
    required this.onAdd,
  });

  @override
  State<FensterListScreen> createState() => _FensterListScreenState();
}

class _FensterListScreenState extends State<FensterListScreen> {
  @override
  Widget build(BuildContext context) {
    final items = widget.getItems();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push<FensterItem?>(
            context,
            MaterialPageRoute(builder: (_) => const FensterFormScreen()),
          );
          if (res != null) setState(() => widget.onAdd(res));
        },
        icon: const Icon(Icons.add),
        label: const Text("Neu"),
      ),
      body: items.isEmpty
          ? const _EmptyState(text: "Noch keine Fenster erfasst.\nTippe auf „Neu“.")
          : ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final f = items[i];
                return _ListCard(
                  title: "Fenster ${f.fensterNr}",
                  subtitle: "${f.breiteMm} × ${f.hoeheMm} mm • ${f.oeffnungsart} • DIN ${f.anschlagsrichtung}",
                  onTap: () => _showFensterDetails(context, f),
                );
              },
            ),
    );
  }

  void _showFensterDetails(BuildContext context, FensterItem f) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Fenster ${f.fensterNr}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              _kv("Breite", "${f.breiteMm} mm"),
              _kv("Höhe", "${f.hoeheMm} mm"),
              _kv("Öffnungsart", f.oeffnungsart),
              _kv("Anschlagsrichtung", f.anschlagsrichtung),
              _kv("Rahmenart", f.rahmenart),
              _kv("Farbe", f.farbe),
              _kv("Glasart", f.glasart),
              _kv("Glasdicke", "${f.glasDicke} mm"),
              _kv("Sicherheitsstufe", f.sicherheitsstufe),
              _kv("Barrierefrei", f.barrierefrei),
              if (f.notizen.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text("Notizen", style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(f.notizen),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _kv(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Expanded(flex: 4, child: Text(k, style: const TextStyle(fontSize: 13, color: Colors.black54))),
            Expanded(flex: 6, child: Text(v, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
          ],
        ),
      );
}

/// ===============================
/// Türen Screens (Room-based)
/// ===============================
class TuerenListScreen extends StatefulWidget {
  final String title;
  final List<TuerItem> Function() getItems;
  final void Function(TuerItem item) onAdd;

  const TuerenListScreen({
    super.key,
    required this.title,
    required this.getItems,
    required this.onAdd,
  });

  @override
  State<TuerenListScreen> createState() => _TuerenListScreenState();
}

class _TuerenListScreenState extends State<TuerenListScreen> {
  @override
  Widget build(BuildContext context) {
    final items = widget.getItems();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push<TuerItem?>(
            context,
            MaterialPageRoute(builder: (_) => const TuerFormScreen()),
          );
          if (res != null) setState(() => widget.onAdd(res));
        },
        icon: const Icon(Icons.add),
        label: const Text("Neu"),
      ),
      body: items.isEmpty
          ? const _EmptyState(text: "Noch keine Türen erfasst.\nTippe auf „Neu“.")
          : ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final t = items[i];
                return _ListCard(
                  title: "Tür ${t.tuerNr}",
                  subtitle: "${t.breiteMm} × ${t.hoeheMm} mm • DIN ${t.din} • ${t.oeffnungsrichtung}",
                  onTap: () => _showDetails(context, t),
                );
              },
            ),
    );
  }

  void _showDetails(BuildContext context, TuerItem t) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        Widget kv(String k, String v) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Expanded(flex: 4, child: Text(k, style: const TextStyle(fontSize: 13, color: Colors.black54))),
                  Expanded(flex: 6, child: Text(v, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
                ],
              ),
            );

        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tür ${t.tuerNr}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                kv("Breite", "${t.breiteMm} mm"),
                kv("Höhe", "${t.hoeheMm} mm"),
                kv("DIN", t.din),
                kv("Öffnungsrichtung", t.oeffnungsrichtung),
                kv("Zarge", t.zarge),
                kv("Wandstärke", "${t.wandstaerkeMm} mm"),
                kv("Türblatt", t.tuerblatt),
                kv("Farbe", t.farbe),
                kv("Schloss/Garnitur", t.schlossGarnitur),
                kv("Barrierefrei", t.barrierefrei),
                if (t.notizen.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Text("Notizen", style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(t.notizen),
                ]
              ],
            ),
          ),
        );
      },
    );
  }
}

/// ===============================
/// Forms (reuse from earlier)
/// ===============================
class FensterFormScreen extends StatefulWidget {
  const FensterFormScreen({super.key});

  @override
  State<FensterFormScreen> createState() => _FensterFormScreenState();
}

class _FensterFormScreenState extends State<FensterFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fensterNr = TextEditingController();
  final _breite = TextEditingController();
  final _hoehe = TextEditingController();
  final _rahmenart = TextEditingController();
  final _farbe = TextEditingController();
  final _glasart = TextEditingController();
  final _glasDicke = TextEditingController();
  final _notizen = TextEditingController();

  String _oeffnungsart = "Dreh/Kipp";
  String _anschlag = "Links";
  String _sicherheit = "Standard";
  bool _barrierefrei = false;

  @override
  void dispose() {
    _fensterNr.dispose();
    _breite.dispose();
    _hoehe.dispose();
    _rahmenart.dispose();
    _farbe.dispose();
    _glasart.dispose();
    _glasDicke.dispose();
    _notizen.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final item = FensterItem(
      fensterNr: _fensterNr.text.trim(),
      breiteMm: _breite.text.trim(),
      hoeheMm: _hoehe.text.trim(),
      oeffnungsart: _oeffnungsart,
      anschlagsrichtung: _anschlag,
      rahmenart: _rahmenart.text.trim(),
      farbe: _farbe.text.trim(),
      glasart: _glasart.text.trim(),
      glasDicke: _glasDicke.text.trim(),
      sicherheitsstufe: _sicherheit,
      barrierefrei: _barrierefrei ? "Ja" : "Nein",
      notizen: _notizen.text.trim(),
    );
    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    Widget tf(TextEditingController c, String label,
        {TextInputType keyboard = TextInputType.text}) {
      final required = label.contains("*");
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          controller: c,
          keyboardType: keyboard,
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

    Widget dd({
      required String label,
      required String value,
      required List<String> items,
      required ValueChanged<String> onChanged,
    }) =>
        Padding(
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

    Widget ml(TextEditingController c, String label) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            controller: c,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: const Text("Neues Fenster")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              tf(_fensterNr, "FensterNr. *"),
              Row(
                children: [
                  Expanded(child: tf(_breite, "Breite (mm) *", keyboard: TextInputType.number)),
                  const SizedBox(width: 10),
                  Expanded(child: tf(_hoehe, "Höhe (mm) *", keyboard: TextInputType.number)),
                ],
              ),
              dd(
                label: "Öffnungsart *",
                value: _oeffnungsart,
                items: const ["Dreh/Kipp", "Dreh", "Kipp", "Schiebefenster", "Festverglasung"],
                onChanged: (v) => setState(() => _oeffnungsart = v),
              ),
              dd(
                label: "Anschlagsrichtung *",
                value: _anschlag,
                items: const ["Links", "Rechts"],
                onChanged: (v) => setState(() => _anschlag = v),
              ),
              tf(_rahmenart, "Rahmenart *"),
              tf(_farbe, "Farbe *"),
              tf(_glasart, "Glasart *"),
              tf(_glasDicke, "Glasdicke (mm) *", keyboard: TextInputType.number),
              dd(
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
              ml(_notizen, "Notizen (optional)"),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: const Text("Speichern"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TuerFormScreen extends StatefulWidget {
  const TuerFormScreen({super.key});

  @override
  State<TuerFormScreen> createState() => _TuerFormScreenState();
}

class _TuerFormScreenState extends State<TuerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _tuerNr = TextEditingController();
  final _breite = TextEditingController();
  final _hoehe = TextEditingController();
  final _wand = TextEditingController();
  final _tuerblatt = TextEditingController();
  final _farbe = TextEditingController();
  final _schloss = TextEditingController();
  final _notizen = TextEditingController();

  String _din = "Links";
  String _richtung = "Nach innen";
  String _zarge = "Umfassungszarge";
  bool _barrierefrei = false;

  @override
  void dispose() {
    _tuerNr.dispose();
    _breite.dispose();
    _hoehe.dispose();
    _wand.dispose();
    _tuerblatt.dispose();
    _farbe.dispose();
    _schloss.dispose();
    _notizen.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final item = TuerItem(
      tuerNr: _tuerNr.text.trim(),
      breiteMm: _breite.text.trim(),
      hoeheMm: _hoehe.text.trim(),
      din: _din,
      oeffnungsrichtung: _richtung,
      zarge: _zarge,
      wandstaerkeMm: _wand.text.trim(),
      tuerblatt: _tuerblatt.text.trim(),
      farbe: _farbe.text.trim(),
      schlossGarnitur: _schloss.text.trim(),
      barrierefrei: _barrierefrei ? "Ja" : "Nein",
      notizen: _notizen.text.trim(),
    );
    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    Widget tf(TextEditingController c, String label,
        {TextInputType keyboard = TextInputType.text}) {
      final required = label.contains("*");
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          controller: c,
          keyboardType: keyboard,
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

    Widget dd({
      required String label,
      required String value,
      required List<String> items,
      required ValueChanged<String> onChanged,
    }) =>
        Padding(
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

    Widget ml(TextEditingController c, String label) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            controller: c,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: label,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(title: const Text("Neue Zimmertür")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              tf(_tuerNr, "TürNr. *"),
              Row(
                children: [
                  Expanded(child: tf(_breite, "Breite (mm) *", keyboard: TextInputType.number)),
                  const SizedBox(width: 10),
                  Expanded(child: tf(_hoehe, "Höhe (mm) *", keyboard: TextInputType.number)),
                ],
              ),
              dd(label: "DIN *", value: _din, items: const ["Links", "Rechts"], onChanged: (v) => setState(() => _din = v)),
              dd(
                label: "Öffnungsrichtung *",
                value: _richtung,
                items: const ["Nach innen", "Nach außen"],
                onChanged: (v) => setState(() => _richtung = v),
              ),
              dd(
                label: "Zarge *",
                value: _zarge,
                items: const ["Umfassungszarge", "Blockzarge", "Futterzarge", "Ohne"],
                onChanged: (v) => setState(() => _zarge = v),
              ),
              tf(_wand, "Wandstärke (mm) *", keyboard: TextInputType.number),
              tf(_tuerblatt, "Türblatt / Oberfläche *"),
              tf(_farbe, "Farbe *"),
              tf(_schloss, "Schloss / Garnitur *"),
              SwitchListTile(
                value: _barrierefrei,
                onChanged: (v) => setState(() => _barrierefrei = v),
                title: const Text("Barrierefrei"),
              ),
              ml(_notizen, "Notizen (optional)"),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: const Text("Speichern"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ===============================
/// UI Helpers
/// ===============================
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
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, size: 36),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ],
          ),
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
        color: Colors.black.withOpacity(.04),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(e, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                ))
            .toList(),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) => Center(
        child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.black54)),
      );
}

class _ListCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ListCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
