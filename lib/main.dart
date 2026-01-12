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
  final List<HaustuerItem> haustueren;

  final List<RolladenItem> rollaeden;
  final List<FliegengitterItem> fliegengitter;
  final List<DachfensterItem> dachfenster;

  Room({
    required this.id,
    required this.name,
    required this.fenster,
    required this.tueren,
    required this.haustueren,
    required this.rollaeden,
    required this.fliegengitter,
    required this.dachfenster,
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
  final String barrierefrei;
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

  /// "Türblattmaß" oder "Öffnungsmaß"
  final String massArt;

  /// je nach Maßart sind das Türblatt- oder Öffnungsmaße
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
    required this.massArt,
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

class HaustuerItem {
  final String haustuerNr;
  final String breiteMm;
  final String hoeheMm;
  final String din;
  final String oeffnungsrichtung;
  final String rahmenart;
  final String farbeAussen;
  final String farbeInnen;
  final String glasart;
  final String glasDicke;
  final String sicherheitsstufe;
  final String barrierefrei;
  final String notizen;

  const HaustuerItem({
    required this.haustuerNr,
    required this.breiteMm,
    required this.hoeheMm,
    required this.din,
    required this.oeffnungsrichtung,
    required this.rahmenart,
    required this.farbeAussen,
    required this.farbeInnen,
    required this.glasart,
    required this.glasDicke,
    required this.sicherheitsstufe,
    required this.barrierefrei,
    required this.notizen,
  });
}
// ===============================
// ROLLLADEN
// ===============================
class RolladenItem {
  final String rolladenNr;
  final String breiteMm;
  final String hoeheMm;
  final String kastenart;
  final String kastenhoeheMm;
  final String panzerprofil;
  final String farbe;
  final String antrieb;
  final String barrierefrei;
  final String notizen;

  const RolladenItem({
    required this.rolladenNr,
    required this.breiteMm,
    required this.hoeheMm,
    required this.kastenart,
    required this.kastenhoeheMm,
    required this.panzerprofil,
    required this.farbe,
    required this.antrieb,
    required this.barrierefrei,
    required this.notizen,
  });
}

// ===============================
// FLIEGENGITTER
// ===============================
class FliegengitterItem {
  final String gitterNr;
  final String breiteMm;
  final String hoeheMm;
  final String typ;
  final String montage;
  final String farbeRahmen;
  final String gewebe;
  final String notizen;

  const FliegengitterItem({
    required this.gitterNr,
    required this.breiteMm,
    required this.hoeheMm,
    required this.typ,
    required this.montage,
    required this.farbeRahmen,
    required this.gewebe,
    required this.notizen,
  });
}

// ===============================
// DACHFENSTER
// ===============================
class DachfensterItem {
  final String dachfensterNr;
  final String hersteller;
  final String typBezeichnung;
  final String breiteMm;
  final String hoeheMm;
  final String oeffnungsart;
  final String anschlag;
  final String verglasung;
  final String zusatz;
  final String notizen;

  const DachfensterItem({
    required this.dachfensterNr,
    required this.hersteller,
    required this.typBezeichnung,
    required this.breiteMm,
    required this.hoeheMm,
    required this.oeffnungsart,
    required this.anschlag,
    required this.verglasung,
    required this.zusatz,
    required this.notizen,
  });
}

/// ===============================
/// APP STATE
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

  void addHaustuer(String projectId, String roomId, HaustuerItem item) {
    final p = projects.firstWhere((p) => p.id == projectId);
    final r = p.rooms.firstWhere((r) => r.id == roomId);
    r.haustueren.add(item);
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
/// Project Detail (Rooms)
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
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final proj = state.projects.firstWhere((p) => p.id == projectId);

        return Scaffold(
          appBar: AppBar(title: Text(proj.name)),
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
        haustueren: [],
        rollaeden: [],
        fliegengitter: [],
        dachfenster: [],
      ),
    );
  },
  icon: const Icon(Icons.add),
  label: const Text("Raum hinzufügen"),
),


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
                    "Erstellt: ${_fmtDate(proj.createdAt)}",
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
                      ? const _EmptyState(
                          text:
                              "Noch keine Räume.\nTippe auf „Raum hinzufügen“.",
                        )
                      : ListView.separated(
                          itemCount: proj.rooms.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final r = proj.rooms[i];
                            return _ListCard(
                              title: r.name,
                              subtitle:
                                  "Fenster: ${r.fenster.length} • Zimmertüren: ${r.tueren.length} • Haustüren: ${r.haustueren.length}",
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
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Abbrechen")),
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
/// Room Detail (Kategorie Buttons)
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
    final proj = state.projects.firstWhere((p) => p.id == projectId);
    final room = proj.rooms.firstWhere((r) => r.id == roomId);

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final p = state.projects.firstWhere((p) => p.id == projectId);
        final r = p.rooms.firstWhere((r) => r.id == roomId);

        return Scaffold(
          appBar: AppBar(title: Text(r.name)),
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
    subtitle: "Erfassen / ansehen",
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FensterListScreen(
          title: "Fenster • ${r.name}",
          getItems: () => r.fenster,
          onAdd: (item) => state.addFenster(projectId, roomId, item),
        ),
      ),
    ),
  ),

  _BigButton(
    icon: Icons.door_front_door,
    title: "Zimmertüren",
    subtitle: "Erfassen / ansehen",
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TuerenListScreen(
          title: "Zimmertüren • ${r.name}",
          getItems: () => r.tueren,
          onAdd: (item) => state.addTuer(projectId, roomId, item),
        ),
      ),
    ),
  ),

  _BigButton(
    icon: Icons.meeting_room,
    title: "Haustüren",
    subtitle: "Erfassen / ansehen",
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HaustuerListScreen(
          title: "Haustüren • ${r.name}",
          getItems: () => r.haustueren,
          onAdd: (item) => state.addHaustuer(projectId, roomId, item),
        ),
      ),
    ),
  ),

  _BigButton(
    icon: Icons.blinds,
    title: "Rollladen",
    subtitle: "Erfassen / ansehen",
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RolladenListScreen(
          title: "Rollladen • ${r.name}",
          getItems: () => r.rollaeden,
          onAdd: (item) => state.addRolladen(projectId, roomId, item),
        ),
      ),
    ),
  ),

  _BigButton(
    icon: Icons.bug_report,
    title: "Fliegengitter",
    subtitle: "Erfassen / ansehen",
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FliegengitterListScreen(
          title: "Fliegengitter • ${r.name}",
          getItems: () => r.fliegengitter,
          onAdd: (item) => state.addFliegengitter(projectId, roomId, item),
        ),
      ),
    ),
  ),

  _BigButton(
    icon: Icons.roofing,
    title: "Dachfenster",
    subtitle: "Erfassen / ansehen",
    onTap: () => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DachfensterListScreen(
          title: "Dachfenster • ${r.name}",
          getItems: () => r.dachfenster,
          onAdd: (item) => state.addDachfenster(projectId, roomId, item),
        ),
      ),
    ),
  ),
],


  context,
  MaterialPageRoute(
    builder: (_) => RolladenListScreen(
      title: "Rollladen • ${r.name}",
      getItems: () => r.rollaeden,
      onAdd: (item) => state.addRolladen(projectId, roomId, item),
    ),
  ),
),

                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _InfoBox(
                  lines: [
                    "Fenster: ${room.fenster.length}",
                    "Zimmertüren: ${room.tueren.length}",
                    "Haustüren: ${room.haustueren.length}",
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

/// ===============================
/// FENSTER
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
                  subtitle:
                      "${f.breiteMm} × ${f.hoeheMm} mm • ${f.oeffnungsart} • DIN ${f.anschlagsrichtung}",
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
              ],
            ],
          ),
        ),
      ),
    );
  }
}

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
              tf(_breite, "Breite (mm) *", keyboard: TextInputType.number),
              tf(_hoehe, "Höhe (mm) *", keyboard: TextInputType.number),
              dd(
                label: "Öffnungsart *",
                value: _oeffnungsart,
                items: const [
                  "Dreh/Kipp",
                  "Dreh",
                  "Kipp",
                  "Schiebefenster",
                  "Festverglasung"
                ],
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

/// ===============================
/// ZIMMER TÜREN
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
                  subtitle:
                      "${t.massArt} • ${t.breiteMm} × ${t.hoeheMm} mm • DIN ${t.din} • ${t.oeffnungsrichtung}",
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
        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tür ${t.tuerNr}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                _kv("Maßart", t.massArt),
                _kv(
                  t.massArt == "Türblattmaß"
                      ? "Türblatt Breite"
                      : "Öffnungsmaß Breite",
                  "${t.breiteMm} mm",
                ),
                _kv(
                  t.massArt == "Türblattmaß"
                      ? "Türblatt Höhe"
                      : "Öffnungsmaß Höhe",
                  "${t.hoeheMm} mm",
                ),
                _kv("DIN", t.din),
                _kv("Öffnungsrichtung", t.oeffnungsrichtung),
                _kv("Zarge", t.zarge),
                _kv("Wandstärke", "${t.wandstaerkeMm} mm"),
                _kv("Türblatt", t.tuerblatt),
                _kv("Farbe", t.farbe),
                _kv("Schloss/Garnitur", t.schlossGarnitur),
                _kv("Barrierefrei", t.barrierefrei),
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

  String _massArt = "Türblattmaß";
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

    void save() {
      if (!_formKey.currentState!.validate()) return;

      final item = TuerItem(
        tuerNr: _tuerNr.text.trim(),
        massArt: _massArt,
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

    return Scaffold(
      appBar: AppBar(title: const Text("Neue Zimmertür")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              tf(_tuerNr, "TürNr. *"),
              const SizedBox(height: 6),
              const Text("Maßart *", style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: "Türblattmaß", label: Text("Türblattmaß")),
                  ButtonSegment(value: "Öffnungsmaß", label: Text("Öffnungsmaß")),
                ],
                selected: {_massArt},
                onSelectionChanged: (s) => setState(() => _massArt = s.first),
              ),
              const SizedBox(height: 12),
              tf(
                _breite,
                _massArt == "Türblattmaß"
                    ? "Türblatt Breite (mm) *"
                    : "Öffnungsmaß Breite (mm) *",
                keyboard: TextInputType.number,
              ),
              tf(
                _hoehe,
                _massArt == "Türblattmaß"
                    ? "Türblatt Höhe (mm) *"
                    : "Öffnungsmaß Höhe (mm) *",
                keyboard: TextInputType.number,
              ),
              dd(label: "DIN *", value: _din, items: const ["Links", "Rechts"],
                  onChanged: (v) => setState(() => _din = v)),
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
                onPressed: save,
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
/// HAUSTÜREN
/// ===============================
class HaustuerListScreen extends StatefulWidget {
  final String title;
  final List<HaustuerItem> Function() getItems;
  final void Function(HaustuerItem item) onAdd;

  const HaustuerListScreen({
    super.key,
    required this.title,
    required this.getItems,
    required this.onAdd,
  });

  @override
  State<HaustuerListScreen> createState() => _HaustuerListScreenState();
}

class _HaustuerListScreenState extends State<HaustuerListScreen> {
  @override
  Widget build(BuildContext context) {
    final items = widget.getItems();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push<HaustuerItem?>(
            context,
            MaterialPageRoute(builder: (_) => const HaustuerFormScreen()),
          );
          if (res != null) setState(() => widget.onAdd(res));
        },
        icon: const Icon(Icons.add),
        label: const Text("Neu"),
      ),
      body: items.isEmpty
          ? const _EmptyState(text: "Noch keine Haustüren erfasst.\nTippe auf „Neu“.")
          : ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final t = items[i];
                return _ListCard(
                  title: "Haustür ${t.haustuerNr}",
                  subtitle: "${t.breiteMm} × ${t.hoeheMm} mm • DIN ${t.din} • ${t.sicherheitsstufe}",
                  onTap: () => _showDetails(context, t),
                );
              },
            ),
    );
  }

  void _showDetails(BuildContext context, HaustuerItem t) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Haustür ${t.haustuerNr}",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                _kv("Breite", "${t.breiteMm} mm"),
                _kv("Höhe", "${t.hoeheMm} mm"),
                _kv("DIN", t.din),
                _kv("Öffnungsrichtung", t.oeffnungsrichtung),
                _kv("Rahmenart/Zarge", t.rahmenart),
                _kv("Farbe außen", t.farbeAussen),
                _kv("Farbe innen", t.farbeInnen),
                _kv("Glasart", t.glasart),
                _kv("Glasdicke", "${t.glasDicke} mm"),
                _kv("Sicherheitsstufe", t.sicherheitsstufe),
                _kv("Barrierefrei", t.barrierefrei),
                if (t.notizen.trim().isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Text("Notizen", style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(t.notizen),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class HaustuerFormScreen extends StatefulWidget {
  const HaustuerFormScreen({super.key});

  @override
  State<HaustuerFormScreen> createState() => _HaustuerFormScreenState();
}

class _HaustuerFormScreenState extends State<HaustuerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nr = TextEditingController();
  final _breite = TextEditingController();
  final _hoehe = TextEditingController();
  final _rahmenart = TextEditingController();
  final _farbeAussen = TextEditingController();
  final _farbeInnen = TextEditingController();
  final _glasDicke = TextEditingController();
  final _notizen = TextEditingController();

  String _din = "Links";
  String _richtung = "Nach innen";
  String _glasart = "Keine";
  String _sicherheit = "Standard";
  bool _barrierefrei = false;

  @override
  void dispose() {
    _nr.dispose();
    _breite.dispose();
    _hoehe.dispose();
    _rahmenart.dispose();
    _farbeAussen.dispose();
    _farbeInnen.dispose();
    _glasDicke.dispose();
    _notizen.dispose();
    super.dispose();
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

    void save() {
      if (!_formKey.currentState!.validate()) return;

      final item = HaustuerItem(
        haustuerNr: _nr.text.trim(),
        breiteMm: _breite.text.trim(),
        hoeheMm: _hoehe.text.trim(),
        din: _din,
        oeffnungsrichtung: _richtung,
        rahmenart: _rahmenart.text.trim(),
        farbeAussen: _farbeAussen.text.trim(),
        farbeInnen: _farbeInnen.text.trim(),
        glasart: _glasart,
        glasDicke: _glasDicke.text.trim(),
        sicherheitsstufe: _sicherheit,
        barrierefrei: _barrierefrei ? "Ja" : "Nein",
        notizen: _notizen.text.trim(),
      );

      Navigator.pop(context, item);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Neue Haustür")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              tf(_nr, "HaustürNr. *"),
              tf(_breite, "Öffnungsmaß Breite (mm) *", keyboard: TextInputType.number),
              tf(_hoehe, "Öffnungsmaß Höhe (mm) *", keyboard: TextInputType.number),
              dd(label: "DIN *", value: _din, items: const ["Links", "Rechts"], onChanged: (v) => setState(() => _din = v)),
              dd(label: "Öffnungsrichtung *", value: _richtung, items: const ["Nach innen", "Nach außen"], onChanged: (v) => setState(() => _richtung = v)),
              tf(_rahmenart, "Rahmenart/Zarge *"),
              tf(_farbeAussen, "Farbe außen *"),
              tf(_farbeInnen, "Farbe innen *"),
              dd(
                label: "Glasart *",
                value: _glasart,
                items: const ["Keine", "Klarglas", "Milchglas", "Ornament", "Sicherheitsglas"],
                onChanged: (v) => setState(() => _glasart = v),
              ),
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
                onPressed: save,
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
/// SHARED UI
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

Widget _kv(String k, String v) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(k, style: const TextStyle(fontSize: 13, color: Colors.black54))),
          Expanded(flex: 6, child: Text(v, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))),
        ],
      ),
    );

String _fmtDate(DateTime dt) {
  final d = dt.day.toString().padLeft(2, "0");
  final m = dt.month.toString().padLeft(2, "0");
  final y = dt.year.toString();
  return "$d.$m.$y";
}
// =======================================================
// ROLLLADEN – LISTE + FORMULAR + DETAILS
// =======================================================

class RolladenListScreen extends StatefulWidget {
  final String title;
  final List<RolladenItem> Function() getItems;
  final void Function(RolladenItem item) onAdd;

  const RolladenListScreen({
    super.key,
    required this.title,
    required this.getItems,
    required this.onAdd,
  });

  @override
  State<RolladenListScreen> createState() => _RolladenListScreenState();
}

class _RolladenListScreenState extends State<RolladenListScreen> {
  @override
  Widget build(BuildContext context) {
    final items = widget.getItems();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push<RolladenItem?>(
            context,
            MaterialPageRoute(builder: (_) => const RolladenFormScreen()),
          );
          if (res != null) setState(() => widget.onAdd(res));
        },
        icon: const Icon(Icons.add),
        label: const Text("Neu"),
      ),
      body: items.isEmpty
          ? const _EmptyState(
              text: "Noch keine Rollläden erfasst.\nTippe auf „Neu“.",
            )
          : ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final r = items[i];
                return _ListCard(
                  title: "Rollladen ${r.rolladenNr}",
                  subtitle:
                      "${r.breiteMm} × ${r.hoeheMm} mm • ${r.kastenart} • ${r.antrieb}",
                  onTap: () => _showDetails(context, r),
                );
              },
            ),
    );
  }

  void _showDetails(BuildContext context, RolladenItem r) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Rollladen ${r.rolladenNr}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              _kv("Breite", "${r.breiteMm} mm"),
              _kv("Höhe", "${r.hoeheMm} mm"),
              _kv("Kastenart", r.kastenart),
              _kv("Kastenhöhe", "${r.kastenhoeheMm} mm"),
              _kv("Panzerprofil", r.panzerprofil),
              _kv("Farbe", r.farbe),
              _kv("Antrieb", r.antrieb),
              _kv("Barrierefrei", r.barrierefrei),
              if (r.notizen.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text("Notizen", style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(r.notizen),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class RolladenFormScreen extends StatefulWidget {
  const RolladenFormScreen({super.key});

  @override
  State<RolladenFormScreen> createState() => _RolladenFormScreenState();
}

class _RolladenFormScreenState extends State<RolladenFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nr = TextEditingController();
  final _breite = TextEditingController();
  final _hoehe = TextEditingController();
  final _kastenhoehe = TextEditingController();
  final _farbe = TextEditingController();
  final _notizen = TextEditingController();

  String _kastenart = "Aufsatzkasten";
  String _panzer = "Alu";
  String _antrieb = "Gurt";
  bool _barrierefrei = false;

  @override
  void dispose() {
    _nr.dispose();
    _breite.dispose();
    _hoehe.dispose();
    _kastenhoehe.dispose();
    _farbe.dispose();
    _notizen.dispose();
    super.dispose();
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

    void save() {
      if (!_formKey.currentState!.validate()) return;

      final item = RolladenItem(
        rolladenNr: _nr.text.trim(),
        breiteMm: _breite.text.trim(),
        hoeheMm: _hoehe.text.trim(),
        kastenart: _kastenart,
        kastenhoeheMm: _kastenhoehe.text.trim(),
        panzerprofil: _panzer,
        farbe: _farbe.text.trim(),
        antrieb: _antrieb,
        barrierefrei: _barrierefrei ? "Ja" : "Nein",
        notizen: _notizen.text.trim(),
      );

      Navigator.pop(context, item);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Neuer Rollladen")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              tf(_nr, "RollladenNr. *"),
              tf(_breite, "Breite (mm) *", keyboard: TextInputType.number),
              tf(_hoehe, "Höhe (mm) *", keyboard: TextInputType.number),

              dd(
                label: "Kastenart *",
                value: _kastenart,
                items: const ["Aufsatzkasten", "Vorbau", "Einbau"],
                onChanged: (v) => setState(() => _kastenart = v),
              ),

              tf(_kastenhoehe, "Kastenhöhe (mm) (optional)",
                  keyboard: TextInputType.number),

              dd(
                label: "Panzerprofil *",
                value: _panzer,
                items: const ["Alu", "PVC", "Sonstige"],
                onChanged: (v) => setState(() => _panzer = v),
              ),

              tf(_farbe, "Farbe *"),

              dd(
                label: "Antrieb *",
                value: _antrieb,
                items: const ["Gurt", "Kurbel", "Motor"],
                onChanged: (v) => setState(() => _antrieb = v),
              ),

              SwitchListTile(
                value: _barrierefrei,
                onChanged: (v) => setState(() => _barrierefrei = v),
                title: const Text("Barrierefrei (Bedienung)"),
              ),

              ml(_notizen, "Notizen (optional)"),

              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: save,
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
// =======================================================
// FLIEGENGITTER – LISTE + FORMULAR + DETAILS
// =======================================================

class FliegengitterListScreen extends StatefulWidget {
  final String title;
  final List<FliegengitterItem> Function() getItems;
  final void Function(FliegengitterItem item) onAdd;

  const FliegengitterListScreen({
    super.key,
    required this.title,
    required this.getItems,
    required this.onAdd,
  });

  @override
  State<FliegengitterListScreen> createState() => _FliegengitterListScreenState();
}

class _FliegengitterListScreenState extends State<FliegengitterListScreen> {
  @override
  Widget build(BuildContext context) {
    final items = widget.getItems();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push<FliegengitterItem?>(
            context,
            MaterialPageRoute(builder: (_) => const FliegengitterFormScreen()),
          );
          if (res != null) setState(() => widget.onAdd(res));
        },
        icon: const Icon(Icons.add),
        label: const Text("Neu"),
      ),
      body: items.isEmpty
          ? const _EmptyState(
              text: "Noch keine Fliegengitter erfasst.\nTippe auf „Neu“.",
            )
          : ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final f = items[i];
                return _ListCard(
                  title: "Fliegengitter ${f.gitterNr}",
                  subtitle: "${f.breiteMm} × ${f.hoeheMm} mm • ${f.typ} • ${f.montage}",
                  onTap: () => _showDetails(context, f),
                );
              },
            ),
    );
  }

  void _showDetails(BuildContext context, FliegengitterItem f) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Fliegengitter ${f.gitterNr}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              _kv("Breite", "${f.breiteMm} mm"),
              _kv("Höhe", "${f.hoeheMm} mm"),
              _kv("Typ", f.typ),
              _kv("Montage", f.montage),
              _kv("Rahmenfarbe", f.farbeRahmen),
              _kv("Gewebe", f.gewebe),
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
}

class FliegengitterFormScreen extends StatefulWidget {
  const FliegengitterFormScreen({super.key});

  @override
  State<FliegengitterFormScreen> createState() => _FliegengitterFormScreenState();
}

class _FliegengitterFormScreenState extends State<FliegengitterFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nr = TextEditingController();
  final _breite = TextEditingController();
  final _hoehe = TextEditingController();
  final _farbeRahmen = TextEditingController();
  final _notizen = TextEditingController();

  String _typ = "Spannrahmen";
  String _montage = "Innen";
  String _gewebe = "Standard";

  @override
  void dispose() {
    _nr.dispose();
    _breite.dispose();
    _hoehe.dispose();
    _farbeRahmen.dispose();
    _notizen.dispose();
    super.dispose();
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

    void save() {
      if (!_formKey.currentState!.validate()) return;

      final item = FliegengitterItem(
        gitterNr: _nr.text.trim(),
        breiteMm: _breite.text.trim(),
        hoeheMm: _hoehe.text.trim(),
        typ: _typ,
        montage: _montage,
        farbeRahmen: _farbeRahmen.text.trim(),
        gewebe: _gewebe,
        notizen: _notizen.text.trim(),
      );

      Navigator.pop(context, item);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Neues Fliegengitter")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              tf(_nr, "FliegengitterNr. *"),
              tf(_breite, "Breite (mm) *", keyboard: TextInputType.number),
              tf(_hoehe, "Höhe (mm) *", keyboard: TextInputType.number),

              dd(
                label: "Typ *",
                value: _typ,
                items: const ["Spannrahmen", "Drehrahmen", "Schiebeanlage", "Plissee"],
                onChanged: (v) => setState(() => _typ = v),
              ),

              dd(
                label: "Montage *",
                value: _montage,
                items: const ["Innen", "Außen"],
                onChanged: (v) => setState(() => _montage = v),
              ),

              tf(_farbeRahmen, "Rahmenfarbe *"),

              dd(
                label: "Gewebe *",
                value: _gewebe,
                items: const ["Standard", "Pollenschutz", "PetScreen"],
                onChanged: (v) => setState(() => _gewebe = v),
              ),

              ml(_notizen, "Notizen (optional)"),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: save,
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
// =======================================================
// DACHFENSTER – LISTE + FORMULAR + DETAILS
// =======================================================

class DachfensterListScreen extends StatefulWidget {
  final String title;
  final List<DachfensterItem> Function() getItems;
  final void Function(DachfensterItem item) onAdd;

  const DachfensterListScreen({
    super.key,
    required this.title,
    required this.getItems,
    required this.onAdd,
  });

  @override
  State<DachfensterListScreen> createState() => _DachfensterListScreenState();
}

class _DachfensterListScreenState extends State<DachfensterListScreen> {
  @override
  Widget build(BuildContext context) {
    final items = widget.getItems();

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push<DachfensterItem?>(
            context,
            MaterialPageRoute(builder: (_) => const DachfensterFormScreen()),
          );
          if (res != null) setState(() => widget.onAdd(res));
        },
        icon: const Icon(Icons.add),
        label: const Text("Neu"),
      ),
      body: items.isEmpty
          ? const _EmptyState(
              text: "Noch keine Dachfenster erfasst.\nTippe auf „Neu“.",
            )
          : ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final d = items[i];
                return _ListCard(
                  title: "Dachfenster ${d.dachfensterNr}",
                  subtitle:
                      "${d.hersteller} • ${d.typBezeichnung} • ${d.breiteMm} × ${d.hoeheMm} mm",
                  onTap: () => _showDetails(context, d),
                );
              },
            ),
    );
  }

  void _showDetails(BuildContext context, DachfensterItem d) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Dachfenster ${d.dachfensterNr}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              _kv("Hersteller", d.hersteller),
              _kv("Typ", d.typBezeichnung),
              _kv("Breite", "${d.breiteMm} mm"),
              _kv("Höhe", "${d.hoeheMm} mm"),
              _kv("Öffnungsart", d.oeffnungsart),
              _kv("Anschlag", d.anschlag),
              _kv("Verglasung", d.verglasung),
              _kv("Zusatz", d.zusatz.isEmpty ? "-" : d.zusatz),
              if (d.notizen.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text("Notizen", style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(d.notizen),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

class DachfensterFormScreen extends StatefulWidget {
  const DachfensterFormScreen({super.key});

  @override
  State<DachfensterFormScreen> createState() => _DachfensterFormScreenState();
}

class _DachfensterFormScreenState extends State<DachfensterFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nr = TextEditingController();
  final _typ = TextEditingController();
  final _breite = TextEditingController();
  final _hoehe = TextEditingController();
  final _zusatz = TextEditingController();
  final _notizen = TextEditingController();

  String _hersteller = "Velux";
  String _oeffnungsart = "Schwingfenster";
  String _anschlag = "Links";
  String _verglasung = "2-fach";

  @override
  void dispose() {
    _nr.dispose();
    _typ.dispose();
    _breite.dispose();
    _hoehe.dispose();
    _zusatz.dispose();
    _notizen.dispose();
    super.dispose();
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

    void save() {
      if (!_formKey.currentState!.validate()) return;

      final item = DachfensterItem(
        dachfensterNr: _nr.text.trim(),
        hersteller: _hersteller,
        typBezeichnung: _typ.text.trim(),
        breiteMm: _breite.text.trim(),
        hoeheMm: _hoehe.text.trim(),
        oeffnungsart: _oeffnungsart,
        anschlag: _anschlag,
        verglasung: _verglasung,
        zusatz: _zusatz.text.trim(),
        notizen: _notizen.text.trim(),
      );

      Navigator.pop(context, item);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Neues Dachfenster")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              tf(_nr, "DachfensterNr. *"),

              dd(
                label: "Hersteller *",
                value: _hersteller,
                items: const ["Velux", "Roto", "Fakro", "Sonstige"],
                onChanged: (v) => setState(() => _hersteller = v),
              ),

              tf(_typ, "Typ / Bezeichnung * (z.B. GGU MK06)"),

              tf(_breite, "Breite (mm) *", keyboard: TextInputType.number),
              tf(_hoehe, "Höhe (mm) *", keyboard: TextInputType.number),

              dd(
                label: "Öffnungsart *",
                value: _oeffnungsart,
                items: const ["Schwingfenster", "Klapp-Schwing", "Ausstieg"],
                onChanged: (v) => setState(() => _oeffnungsart = v),
              ),

              dd(
                label: "Anschlag *",
                value: _anschlag,
                items: const ["Links", "Rechts"],
                onChanged: (v) => setState(() => _anschlag = v),
              ),

              dd(
                label: "Verglasung *",
                value: _verglasung,
                items: const ["2-fach", "3-fach"],
                onChanged: (v) => setState(() => _verglasung = v),
              ),

              tf(_zusatz, "Zusatz (optional)"),
              ml(_notizen, "Notizen (optional)"),

              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: save,
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
