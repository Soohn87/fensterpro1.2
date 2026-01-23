import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'DEINE_SUPABASE_URL',
    anonKey: 'DEIN_SUPABASE_ANON_KEY',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FensterPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0B6EF3),
      ),
      home: const SupabaseAuthGate(),
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
    void addRolladen(String projectId, String roomId, RolladenItem item) {
    final p = projects.firstWhere((p) => p.id == projectId);
    final r = p.rooms.firstWhere((r) => r.id == roomId);
    r.rollaeden.add(item);
    notifyListeners();
  }

  void addFliegengitter(String projectId, String roomId, FliegengitterItem item) {
    final p = projects.firstWhere((p) => p.id == projectId);
    final r = p.rooms.firstWhere((r) => r.id == roomId);
    r.fliegengitter.add(item);
    notifyListeners();
  }

  void addDachfenster(String projectId, String roomId, DachfensterItem item) {
    final p = projects.firstWhere((p) => p.id == projectId);
    final r = p.rooms.firstWhere((r) => r.id == roomId);
    r.dachfenster.add(item);
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
                  text: "Noch keine Projekte.\nTippe auf „Neues Projekt“, um zu starten.",
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
                ),
              );
            },
            icon: const Icon(Icons.add),
            label: const Text("Raum hinzufügen"),
          ),
          body: proj.rooms.isEmpty
              ? const _EmptyState(text: "Noch keine Räume.\nTippe auf „Raum hinzufügen“. ")
              : ListView.separated(
                  padding: const EdgeInsets.all(14),
                  itemCount: proj.rooms.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, i) {
                    final r = proj.rooms[i];
                    return _ListCard(
                      title: r.name,
                      subtitle: "Fenster: ${r.fenster.length}",
                      onTap: () {
                        // hier war früher dein Local RoomDetail
                        // (wenn du komplett cloud gehst, wird dieser lokale Screen eh nicht mehr benutzt)
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}


  Future<String?> _askRoomName(BuildContext context) async {
    final c = TextEditingController();
     showDialog<String>(
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
            child: const Text("Abbrechen"),
          ),
          FilledButton(
            onPressed: () {
              final v = c.text.trim();
              if (v.isEmpty) ;
              Navigator.pop(context, v);
            },
            child: const Text("OK"),
          ),
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
     AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final proj = state.projects.firstWhere((p) => p.id == projectId);
        final r = proj.rooms.firstWhere((rr) => rr.id == roomId);

         Scaffold(
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
  subtitle: "Cloud • Erfassen / ansehen",
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => FensterCloudListScreen(
        roomId: roomId,
        roomName: roomName,
      ),
    ),
  ),
),

                    _BigButton(
  icon: Icons.door_front_door,
  title: "Zimmertüren",
  subtitle: "Cloud • Erfassen / ansehen",
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => TuerenCloudListScreen(
        roomId: roomId,
        roomName: roomName,
      ),
    ),
  ),
),

                    _BigButton(
  icon: Icons.meeting_room,
  title: "Haustüren",
  subtitle: "Cloud • Erfassen / ansehen",
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => HaustuerCloudListScreen(
        roomId: roomId,
        roomName: roomName,
      ),
    ),
  ),
),

                   _BigButton(
  icon: Icons.blinds,
  title: "Rollladen",
  subtitle: "Cloud • Erfassen / ansehen",
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => RolladenCloudListScreen(
        roomId: roomId,
        roomName: roomName,
      ),
    ),
  ),
),
_BigButton(
  icon: Icons.bug_report,
  title: "Fliegengitter",
  subtitle: "Cloud • Erfassen / ansehen",
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => FliegengitterCloudListScreen(
        roomId: roomId,
        roomName: roomName,
      ),
    ),
  ),
),
_BigButton(
  icon: Icons.roofing,
  title: "Dachfenster",
  subtitle: "Cloud • Erfassen / ansehen",
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => DachfensterCloudListScreen(
        roomId: roomId,
        roomName: roomName,
      ),
    ),
  ),
),

                const SizedBox(height: 14),
                _InfoBox(
                  lines: [
                    "Fenster: ${r.fenster.length}",
                    "Zimmertüren: ${r.tueren.length}",
                    "Haustüren: ${r.haustueren.length}",
                    "Rollladen: ${r.rollaeden.length}",
                    "Fliegengitter: ${r.fliegengitter.length}",
                    "Dachfenster: ${r.dachfenster.length}",
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

     Scaffold(
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
                 _ListCard(
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
    if (!_formKey.currentState!.validate()) ;

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
       Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          controller: c,
          keyboardType: keyboard,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          ),
          validator: (v) {
            if (!required)  null;
            if (v == null || v.trim().isEmpty)  "Pflichtfeld";
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
// =======================================================
// SUPABASE AUTH + COMPANY (FIRMA) GATE
// =======================================================

class SupabaseAuthGate extends StatelessWidget {
  const SupabaseAuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;

    return StreamBuilder<AuthState>(
      stream: client.auth.onAuthStateChange,
      builder: (context, snap) {
        // initial check
        final user = client.auth.currentUser;

        if (user == null) {
          return const SbLoginScreen();
        }

        return SbCompanyGate(userId: user.id, email: user.email ?? "");
      },
    );
  }
}

class SbCompanyGate extends StatelessWidget {
  final String userId;
  final String email;

  const SbCompanyGate({
    super.key,
    required this.userId,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final client = Supabase.instance.client;

    return FutureBuilder<String?>(
      future: _getCompanyId(client, userId),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final companyId = snap.data;

        if (companyId == null || companyId.isEmpty) {
          return SbCompanyJoinScreen(userId: userId, email: email);
        }

        // ✅ Ab hier ist der User Mitglied einer Firma
        // Als Nächstes bauen wir ProjectsCloudScreen.
        // Für jetzt zeigen wir nur einen Platzhalter.
        return ProjectsCloudScreen(companyId: companyId);
      },
    );
  }

  Future<String?> _getCompanyId(SupabaseClient client, String userId) async {
    // user_id in members finden
    final res = await client
        .from('members')
        .select('company_id')
        .eq('user_id', userId)
        .maybeSingle();

    if (res == null) return null;
    return res['company_id'] as String?;
  }
}

// Platzhalter Home – wird im nächsten Schritt durch ProjectsCloudScreen ersetzt
class SbHomePlaceholder extends StatelessWidget {
  final String companyId;
  const SbHomePlaceholder({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("FensterPro (Cloud)"),
        actions: [
          IconButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "✅ Login + Firma erfolgreich!\n\nAls nächstes: Projekte aus der Cloud laden.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 14),
            SelectableText("CompanyId: $companyId"),
            const SizedBox(height: 8),
            SelectableText("User: ${user?.email ?? ""}"),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// LOGIN
// =======================================================

class SbLoginScreen extends StatefulWidget {
  const SbLoginScreen({super.key});

  @override
  State<SbLoginScreen> createState() => _SbLoginScreenState();
}

class _SbLoginScreenState extends State<SbLoginScreen> {
  final _email = TextEditingController();
  final _pw = TextEditingController();
  bool _loading = false;
  String? _err;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("FensterPro • Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: "E-Mail"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pw,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Passwort"),
            ),
            const SizedBox(height: 12),
            if (_err != null) Text(_err!, style: const TextStyle(color: Color(0xFFD32F2F))),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loading ? null : _login,
              child: _loading
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator())
                  : const Text("Login"),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SbRegisterScreen()),
              ),
              child: const Text("Noch kein Account? Registrieren"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _err = null;
    });

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _email.text.trim(),
        password: _pw.text.trim(),
      );
    } catch (e) {
      setState(() => _err = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

// =======================================================
// REGISTER
// =======================================================

class SbRegisterScreen extends StatefulWidget {
  const SbRegisterScreen({super.key});

  @override
  State<SbRegisterScreen> createState() => _SbRegisterScreenState();
}

class _SbRegisterScreenState extends State<SbRegisterScreen> {
  final _email = TextEditingController();
  final _pw = TextEditingController();
  bool _loading = false;
  String? _err;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrieren")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _email, decoration: const InputDecoration(labelText: "E-Mail")),
            const SizedBox(height: 12),
            TextField(
              controller: _pw,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Passwort (min. 6 Zeichen)"),
            ),
            const SizedBox(height: 12),
            if (_err != null) Text(_err!, style: const TextStyle(color: Color(0xFFD32F2F))),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loading ? null : _register,
              child: _loading
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator())
                  : const Text("Account erstellen"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _register() async {
    setState(() {
      _loading = true;
      _err = null;
    });

    try {
      await Supabase.instance.client.auth.signUp(
        email: _email.text.trim(),
        password: _pw.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _err = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

// =======================================================
// COMPANY JOIN / CREATE
// =======================================================

class SbCompanyJoinScreen extends StatefulWidget {
  final String userId;
  final String email;

  const SbCompanyJoinScreen({
    super.key,
    required this.userId,
    required this.email,
  });

  @override
  State<SbCompanyJoinScreen> createState() => _SbCompanyJoinScreenState();
}

class _SbCompanyJoinScreenState extends State<SbCompanyJoinScreen> {
  final _code = TextEditingController();
  bool _loading = false;
  String? _err;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firma beitreten"),
        actions: [
          IconButton(
            onPressed: () async => Supabase.instance.client.auth.signOut(),
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Gib den Firmen-Code ein (z.B. FP-4K92).",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _code,
              decoration: const InputDecoration(labelText: "Firmen-Code"),
            ),
            const SizedBox(height: 12),
            if (_err != null) Text(_err!, style: const TextStyle(color: Color(0xFFD32F2F))),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _loading ? null : _joinCompany,
              icon: const Icon(Icons.key),
              label: const Text("Beitreten"),
            ),
            const SizedBox(height: 18),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SbCreateCompanyScreen(userId: widget.userId, email: widget.email),
                ),
              ),
              child: const Text("Neue Firma erstellen (Admin)"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _joinCompany() async {
    setState(() {
      _loading = true;
      _err = null;
    });

    try {
      final code = _code.text.trim().toUpperCase();
      if (code.isEmpty) throw Exception("Code fehlt");

      final client = Supabase.instance.client;

      final company = await client
          .from('companies')
          .select('id, code')
          .eq('code', code)
          .maybeSingle();

      if (company == null) throw Exception("Code nicht gefunden.");

      final companyId = company['id'] as String;

      // Member anlegen
      await client.from('members').insert({
        'company_id': companyId,
        'user_id': widget.userId,
        'role': 'user',
      });

      // 🔁 Gate wird automatisch neu geladen
    } catch (e) {
      setState(() => _err = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class SbCreateCompanyScreen extends StatefulWidget {
  final String userId;
  final String email;

  const SbCreateCompanyScreen({
    super.key,
    required this.userId,
    required this.email,
  });

  @override
  State<SbCreateCompanyScreen> createState() => _SbCreateCompanyScreenState();
}

class _SbCreateCompanyScreenState extends State<SbCreateCompanyScreen> {
  final _name = TextEditingController();
  bool _loading = false;
  String? _err;
  String? _createdCode;

  String _genCode() {
    const chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789";
    final now = DateTime.now().microsecondsSinceEpoch;
    String out = "FP-";
    for (int i = 0; i < 4; i++) {
      out += chars[(now + i * 17) % chars.length];
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Firma erstellen")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _name, decoration: const InputDecoration(labelText: "Firmenname")),
            const SizedBox(height: 12),
            if (_err != null) Text(_err!, style: const TextStyle(color: Color(0xFFD32F2F))),
            if (_createdCode != null) ...[
              const SizedBox(height: 12),
              SelectableText(
                "✅ Firmen-Code: $_createdCode",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Text("Diesen Code an deine Mitarbeiter weitergeben."),
            ],
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loading ? null : _createCompany,
              child: _loading
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator())
                  : const Text("Firma erstellen"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _createCompany() async {
    setState(() {
      _loading = true;
      _err = null;
      _createdCode = null;
    });

    try {
      final name = _name.text.trim();
      if (name.isEmpty) throw Exception("Firmenname fehlt");

      final code = _genCode();
      final client = Supabase.instance.client;

      // company erstellen
      final inserted = await client.from('companies').insert({
        'name': name,
        'code': code,
      }).select('id').single();

      final companyId = inserted['id'] as String;

      // admin member
      await client.from('members').insert({
        'company_id': companyId,
        'user_id': widget.userId,
        'role': 'admin',
      });

      setState(() => _createdCode = code);
    } catch (e) {
      setState(() => _err = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
// =======================================================
// SUPABASE CLOUD: PROJECTS + ROOMS
// =======================================================

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

  Future<void> _addProject() async {
    final nameC = TextEditingController();
    final customerC = TextEditingController();
    final addressC = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Neues Projekt"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameC, decoration: const InputDecoration(labelText: "Projektname *")),
              const SizedBox(height: 8),
              TextField(controller: customerC, decoration: const InputDecoration(labelText: "Kunde")),
              const SizedBox(height: 8),
              TextField(controller: addressC, decoration: const InputDecoration(labelText: "Adresse")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Abbrechen")),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text("Speichern")),
        ],
      ),
    );

    if (ok != true) return;

    final name = nameC.text.trim();
    if (name.isEmpty) return;

    try {
      await _client.from('projects').insert({
        'company_id': widget.companyId,
        'name': name,
        'customer': customerC.text.trim(),
        'address': addressC.text.trim(),
      });

      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  Future<void> _deleteProject(String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Projekt löschen?"),
        content: const Text("Willst du das Projekt wirklich löschen?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Abbrechen")),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD32F2F)),
            child: const Text("Löschen"),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await _client.from('projects').delete().eq('id', id);
      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _client.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("FensterPro • Projekte (Cloud)"),
        actions: [
          IconButton(
            onPressed: _load,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async => _client.auth.signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addProject,
        icon: const Icon(Icons.add),
        label: const Text("Neues Projekt"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoBox(
              lines: [
                "Team Cloud aktiv ✅",
                "User: ${user?.email ?? "—"}",
              ],
            ),
            const SizedBox(height: 12),

            if (_err != null) ...[
              Text(_err!, style: const TextStyle(color: Color(0xFFD32F2F))),
              const SizedBox(height: 12),
            ],

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _projects.isEmpty
                      ? const _EmptyState(text: "Noch keine Projekte.\nTippe auf „Neues Projekt“. ")
                      : ListView.separated(
                          itemCount: _projects.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final p = _projects[i];
                            final pid = p['id'] as String;
                            final name = (p['name'] ?? '') as String;
                            final customer = (p['customer'] ?? '') as String;
                            final address = (p['address'] ?? '') as String;

                            return _ListCard(
                              title: name,
                              subtitle: [
                                if (customer.isNotEmpty) customer,
                                if (address.isNotEmpty) address,
                              ].join(" • "),
                              trailing: IconButton(
                                onPressed: () => _deleteProject(pid),
                                icon: const Icon(Icons.delete),
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RoomsCloudScreen(
                                    companyId: widget.companyId,
                                    projectId: pid,
                                    projectName: name,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
// =======================================================
// SUPABASE CLOUD: FENSTER
// items: type="fenster", data=json
// =======================================================

class FensterCloudListScreen extends StatefulWidget {
  final String roomId;
  final String roomName;

  const FensterCloudListScreen({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  @override
  State<FensterCloudListScreen> createState() => _FensterCloudListScreenState();
}

class _FensterCloudListScreenState extends State<FensterCloudListScreen> {
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
          .eq('type', 'fenster')
          .order('created_at', ascending: false);

      _items = List<Map<String, dynamic>>.from(res);
    } catch (e) {
      _err = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _add() async {
    final res = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(
        builder: (_) => const FensterCloudFormScreen(),
      ),
    );

    if (res == null) return;

    try {
      await _client.from('items').insert({
        'room_id': widget.roomId,
        'type': 'fenster',
        'data': res,
      });

      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  Future<void> _delete(String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Fenster löschen?"),
        content: const Text("Willst du dieses Fenster wirklich löschen?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Abbrechen")),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD32F2F)),
            child: const Text("Löschen"),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await _client.from('items').delete().eq('id', id);
      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fenster • ${widget.roomName} (Cloud)"),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text("Neu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_err != null) ...[
              Text(_err!, style: const TextStyle(color: Color(0xFFD32F2F))),
              const SizedBox(height: 12),
            ],
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _items.isEmpty
                      ? const _EmptyState(text: "Noch keine Fenster.\nTippe auf „Neu“. ")
                      : ListView.separated(
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final row = _items[i];
                            final id = row['id'] as String;
                            final data = (row['data'] as Map).cast<String, dynamic>();

                            final nr = (data['fensterNr'] ?? '') as String;
                            final b = (data['breiteMm'] ?? '') as String;
                            final h = (data['hoeheMm'] ?? '') as String;
                            final art = (data['oeffnungsart'] ?? '') as String;

                            return _ListCard(
                              title: "Fenster $nr",
                              subtitle: "$b × $h mm • $art",
                              trailing: IconButton(
                                onPressed: () => _delete(id),
                                icon: const Icon(Icons.delete),
                              ),
                              onTap: () => _showDetails(context, data),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, Map<String, dynamic> d) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Fenster ${d['fensterNr'] ?? ''}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              _kv("Breite", "${d['breiteMm'] ?? ''} mm"),
              _kv("Höhe", "${d['hoeheMm'] ?? ''} mm"),
              _kv("Öffnungsart", "${d['oeffnungsart'] ?? ''}"),
              _kv("Anschlag", "${d['anschlagsrichtung'] ?? ''}"),
              _kv("Rahmenart", "${d['rahmenart'] ?? ''}"),
              _kv("Farbe", "${d['farbe'] ?? ''}"),
              _kv("Glasart", "${d['glasart'] ?? ''}"),
              _kv("Glasdicke", "${d['glasdicke'] ?? ''}"),
              _kv("Sicherheitsstufe", "${d['sicherheitsstufe'] ?? ''}"),
              _kv("Barrierefrei", "${d['barrierefrei'] ?? ''}"),
              if (((d['notizen'] ?? '') as String).trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text("Notizen", style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text("${d['notizen']}"),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class FensterCloudFormScreen extends StatefulWidget {
  const FensterCloudFormScreen({super.key});

  @override
  State<FensterCloudFormScreen> createState() => _FensterCloudFormScreenState();
}

class _FensterCloudFormScreenState extends State<FensterCloudFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nr = TextEditingController();
  final _breite = TextEditingController();
  final _hoehe = TextEditingController();
  final _farbe = TextEditingController();
  final _glasdicke = TextEditingController();
  final _notizen = TextEditingController();

  String _oeffnungsart = "Dreh-Kipp";
  String _anschlag = "Links";
  String _rahmenart = "Kunststoff";
  String _glasart = "2-fach";
  String _sicherheit = "Standard";
  bool _barrierefrei = false;

  @override
  void dispose() {
    _nr.dispose();
    _breite.dispose();
    _hoehe.dispose();
    _farbe.dispose();
    _glasdicke.dispose();
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

      final data = <String, dynamic>{
        "fensterNr": _nr.text.trim(),
        "breiteMm": _breite.text.trim(),
        "hoeheMm": _hoehe.text.trim(),
        "oeffnungsart": _oeffnungsart,
        "anschlagsrichtung": _anschlag,
        "rahmenart": _rahmenart,
        "farbe": _farbe.text.trim(),
        "glasart": _glasart,
        "glasdicke": _glasdicke.text.trim(),
        "sicherheitsstufe": _sicherheit,
        "barrierefrei": _barrierefrei ? "Ja" : "Nein",
        "notizen": _notizen.text.trim(),
      };

      Navigator.pop(context, data);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Neues Fenster (Cloud)")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              tf(_nr, "FensterNr. *"),
              tf(_breite, "Breite (mm) *", keyboard: TextInputType.number),
              tf(_hoehe, "Höhe (mm) *", keyboard: TextInputType.number),

              dd(
                label: "Öffnungsart *",
                value: _oeffnungsart,
                items: const ["Dreh-Kipp", "Dreh", "Kipp", "Fest"],
                onChanged: (v) => setState(() => _oeffnungsart = v),
              ),

              dd(
                label: "Anschlag *",
                value: _anschlag,
                items: const ["Links", "Rechts"],
                onChanged: (v) => setState(() => _anschlag = v),
              ),

              dd(
                label: "Rahmenart *",
                value: _rahmenart,
                items: const ["Kunststoff", "Alu", "Holz", "Holz-Alu"],
                onChanged: (v) => setState(() => _rahmenart = v),
              ),

              tf(_farbe, "Farbe *"),

              dd(
                label: "Glasart *",
                value: _glasart,
                items: const ["2-fach", "3-fach", "Sicherheitsglas"],
                onChanged: (v) => setState(() => _glasart = v),
              ),

              tf(_glasdicke, "Glasdicke (optional)"),

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

// =======================================================
// SUPABASE CLOUD: ZIMMERTÜREN
// items: type="zimmertuer", data=json
// =======================================================

class TuerenCloudListScreen extends StatefulWidget {
  final String roomId;
  final String roomName;

  const TuerenCloudListScreen({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  @override
  State<TuerenCloudListScreen> createState() => _TuerenCloudListScreenState();
}

class _TuerenCloudListScreenState extends State<TuerenCloudListScreen> {
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
          .eq('type', 'zimmertuer')
          .order('created_at', ascending: false);

      _items = List<Map<String, dynamic>>.from(res);
    } catch (e) {
      _err = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _add() async {
    final res = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(
        builder: (_) => const TuerenCloudFormScreen(),
      ),
    );

    if (res == null) return;

    try {
      await _client.from('items').insert({
        'room_id': widget.roomId,
        'type': 'zimmertuer',
        'data': res,
      });

      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  Future<void> _delete(String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Tür löschen?"),
        content: const Text("Willst du diese Zimmertür wirklich löschen?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Abbrechen"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD32F2F)),
            child: const Text("Löschen"),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await _client.from('items').delete().eq('id', id);
      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zimmertüren • ${widget.roomName} (Cloud)"),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text("Neu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_err != null) ...[
              Text(_err!, style: const TextStyle(color: Color(0xFFD32F2F))),
              const SizedBox(height: 12),
            ],
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _items.isEmpty
                      ? const _EmptyState(
                          text: "Noch keine Zimmertüren.\nTippe auf „Neu“.",
                        )
                      : ListView.separated(
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final row = _items[i];
                            final id = row['id'] as String;
                            final data = (row['data'] as Map).cast<String, dynamic>();

                            final nr = (data['tuerNr'] ?? '') as String;
                            final b = (data['breiteMm'] ?? '') as String;
                            final h = (data['hoeheMm'] ?? '') as String;
                            final art = (data['oeffnungsart'] ?? '') as String;

                            return _ListCard(
                              title: "Tür $nr",
                              subtitle: "$b × $h mm • $art",
                              trailing: IconButton(
                                onPressed: () => _delete(id),
                                icon: const Icon(Icons.delete),
                              ),
                              onTap: () => _showDetails(context, data),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, Map<String, dynamic> d) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tür ${d['tuerNr'] ?? ''}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              _kv("Breite", "${d['breiteMm'] ?? ''} mm"),
              _kv("Höhe", "${d['hoeheMm'] ?? ''} mm"),
              _kv("Öffnungsart", "${d['oeffnungsart'] ?? ''}"),
              _kv("Anschlag", "${d['anschlag'] ?? ''}"),
              _kv("Rahmenart", "${d['rahmenart'] ?? ''}"),
              _kv("Zarge", "${d['zarge'] ?? ''}"),
              _kv("Farbe", "${d['farbe'] ?? ''}"),
              _kv("Sicherheitsstufe", "${d['sicherheitsstufe'] ?? ''}"),
              _kv("Barrierefrei", "${d['barrierefrei'] ?? ''}"),
              if (((d['notizen'] ?? '') as String).trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text("Notizen", style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text("${d['notizen']}"),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class TuerenCloudFormScreen extends StatefulWidget {
  const TuerenCloudFormScreen({super.key});

  @override
  State<TuerenCloudFormScreen> createState() => _TuerenCloudFormScreenState();
}

class _TuerenCloudFormScreenState extends State<TuerenCloudFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nr = TextEditingController();
  final _breite = TextEditingController();
  final _hoehe = TextEditingController();
  final _farbe = TextEditingController();
  final _notizen = TextEditingController();

  String _oeffnungsart = "Dreh";
  String _anschlag = "Links";
  String _rahmenart = "Holz";
  String _zarge = "Umfassungszarge";
  String _sicherheit = "Standard";
  bool _barrierefrei = false;

  @override
  void dispose() {
    _nr.dispose();
    _breite.dispose();
    _hoehe.dispose();
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

      final data = <String, dynamic>{
        "tuerNr": _nr.text.trim(),
        "breiteMm": _breite.text.trim(),
        "hoeheMm": _hoehe.text.trim(),
        "oeffnungsart": _oeffnungsart,
        "anschlag": _anschlag,
        "rahmenart": _rahmenart,
        "zarge": _zarge,
        "farbe": _farbe.text.trim(),
        "sicherheitsstufe": _sicherheit,
        "barrierefrei": _barrierefrei ? "Ja" : "Nein",
        "notizen": _notizen.text.trim(),
      };

      Navigator.pop(context, data);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Neue Zimmertür (Cloud)")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              tf(_nr, "TürNr. *"),
              tf(_breite, "Breite (mm) *", keyboard: TextInputType.number),
              tf(_hoehe, "Höhe (mm) *", keyboard: TextInputType.number),

              dd(
                label: "Öffnungsart *",
                value: _oeffnungsart,
                items: const ["Dreh", "Dreh-Kipp", "Schiebetür", "Glastür"],
                onChanged: (v) => setState(() => _oeffnungsart = v),
              ),

              dd(
                label: "Anschlag *",
                value: _anschlag,
                items: const ["Links", "Rechts"],
                onChanged: (v) => setState(() => _anschlag = v),
              ),

              dd(
                label: "Rahmenart *",
                value: _rahmenart,
                items: const ["Holz", "Stahlzarge", "Alu"],
                onChanged: (v) => setState(() => _rahmenart = v),
              ),

              dd(
                label: "Zarge *",
                value: _zarge,
                items: const ["Umfassungszarge", "Blockzarge", "Stahlzarge"],
                onChanged: (v) => setState(() => _zarge = v),
              ),

              tf(_farbe, "Farbe *"),

              dd(
                label: "Sicherheitsstufe *",
                value: _sicherheit,
                items: const ["Standard", "RC1", "RC2"],
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

// =======================================================
// SUPABASE CLOUD: HAUSTÜREN
// items: type="haustuer", data=json
// =======================================================

class HaustuerCloudListScreen extends StatefulWidget {
  final String roomId;
  final String roomName;

  const HaustuerCloudListScreen({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  @override
  State<HaustuerCloudListScreen> createState() => _HaustuerCloudListScreenState();
}

class _HaustuerCloudListScreenState extends State<HaustuerCloudListScreen> {
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
          .eq('type', 'haustuer')
          .order('created_at', ascending: false);

      _items = List<Map<String, dynamic>>.from(res);
    } catch (e) {
      _err = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _add() async {
    final res = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(
        builder: (_) => const HaustuerCloudFormScreen(),
      ),
    );

    if (res == null) return;

    try {
      await _client.from('items').insert({
        'room_id': widget.roomId,
        'type': 'haustuer',
        'data': res,
      });

      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  Future<void> _delete(String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Haustür löschen?"),
        content: const Text("Willst du diese Haustür wirklich löschen?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Abbrechen"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD32F2F)),
            child: const Text("Löschen"),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await _client.from('items').delete().eq('id', id);
      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Haustüren • ${widget.roomName} (Cloud)"),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text("Neu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_err != null) ...[
              Text(_err!, style: const TextStyle(color: Color(0xFFD32F2F))),
              const SizedBox(height: 12),
            ],
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _items.isEmpty
                      ? const _EmptyState(
                          text: "Noch keine Haustüren.\nTippe auf „Neu“.",
                        )
                      : ListView.separated(
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final row = _items[i];
                            final id = row['id'] as String;
                            final data = (row['data'] as Map).cast<String, dynamic>();

                            final nr = (data['haustuerNr'] ?? '') as String;
                            final b = (data['breiteMm'] ?? '') as String;
                            final h = (data['hoeheMm'] ?? '') as String;
                            final art = (data['oeffnungsart'] ?? '') as String;

                            return _ListCard(
                              title: "Haustür $nr",
                              subtitle: "$b × $h mm • $art",
                              trailing: IconButton(
                                onPressed: () => _delete(id),
                                icon: const Icon(Icons.delete),
                              ),
                              onTap: () => _showDetails(context, data),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, Map<String, dynamic> d) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Haustür ${d['haustuerNr'] ?? ''}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              _kv("Breite", "${d['breiteMm'] ?? ''} mm"),
              _kv("Höhe", "${d['hoeheMm'] ?? ''} mm"),
              _kv("Öffnungsart", "${d['oeffnungsart'] ?? ''}"),
              _kv("Anschlag", "${d['anschlag'] ?? ''}"),
              _kv("Material", "${d['material'] ?? ''}"),
              _kv("Farbe", "${d['farbe'] ?? ''}"),
              _kv("Verglasung", "${d['verglasung'] ?? ''}"),
              _kv("Sicherheitsstufe", "${d['sicherheitsstufe'] ?? ''}"),
              _kv("Schloss", "${d['schloss'] ?? ''}"),
              _kv("Barrierefrei", "${d['barrierefrei'] ?? ''}"),
              if (((d['notizen'] ?? '') as String).trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text("Notizen", style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text("${d['notizen']}"),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class HaustuerCloudFormScreen extends StatefulWidget {
  const HaustuerCloudFormScreen({super.key});

  @override
  State<HaustuerCloudFormScreen> createState() => _HaustuerCloudFormScreenState();
}

class _HaustuerCloudFormScreenState extends State<HaustuerCloudFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nr = TextEditingController();
  final _breite = TextEditingController();
  final _hoehe = TextEditingController();
  final _farbe = TextEditingController();
  final _notizen = TextEditingController();

  String _oeffnungsart = "Dreh";
  String _anschlag = "Links";
  String _material = "Alu";
  String _verglasung = "Ohne";
  String _sicherheit = "Standard";
  String _schloss = "Standard";
  bool _barrierefrei = false;

  @override
  void dispose() {
    _nr.dispose();
    _breite.dispose();
    _hoehe.dispose();
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

      final data = <String, dynamic>{
        "haustuerNr": _nr.text.trim(),
        "breiteMm": _breite.text.trim(),
        "hoeheMm": _hoehe.text.trim(),
        "oeffnungsart": _oeffnungsart,
        "anschlag": _anschlag,
        "material": _material,
        "farbe": _farbe.text.trim(),
        "verglasung": _verglasung,
        "sicherheitsstufe": _sicherheit,
        "schloss": _schloss,
        "barrierefrei": _barrierefrei ? "Ja" : "Nein",
        "notizen": _notizen.text.trim(),
      };

      Navigator.pop(context, data);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Neue Haustür (Cloud)")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              tf(_nr, "HaustürNr. *"),
              tf(_breite, "Breite (mm) *", keyboard: TextInputType.number),
              tf(_hoehe, "Höhe (mm) *", keyboard: TextInputType.number),

              dd(
                label: "Öffnungsart *",
                value: _oeffnungsart,
                items: const ["Dreh", "Dreh-Kipp", "2-flügelig", "Seitenteil"],
                onChanged: (v) => setState(() => _oeffnungsart = v),
              ),

              dd(
                label: "Anschlag *",
                value: _anschlag,
                items: const ["Links", "Rechts"],
                onChanged: (v) => setState(() => _anschlag = v),
              ),

              dd(
                label: "Material *",
                value: _material,
                items: const ["Alu", "Kunststoff", "Holz", "Holz-Alu", "Stahl"],
                onChanged: (v) => setState(() => _material = v),
              ),

              tf(_farbe, "Farbe *"),

              dd(
                label: "Verglasung *",
                value: _verglasung,
                items: const ["Ohne", "Glas", "Sicherheitsglas"],
                onChanged: (v) => setState(() => _verglasung = v),
              ),

              dd(
                label: "Sicherheitsstufe *",
                value: _sicherheit,
                items: const ["Standard", "RC1", "RC2", "RC3"],
                onChanged: (v) => setState(() => _sicherheit = v),
              ),

              dd(
                label: "Schloss *",
                value: _schloss,
                items: const ["Standard", "Mehrfachverriegelung", "Elektrisch"],
                onChanged: (v) => setState(() => _schloss = v),
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
// =======================================================
// SUPABASE CLOUD: ROLLLADEN
// items: type="rolladen", data=json
// =======================================================

class RolladenCloudListScreen extends StatefulWidget {
  final String roomId;
  final String roomName;

  const RolladenCloudListScreen({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  @override
  State<RolladenCloudListScreen> createState() => _RolladenCloudListScreenState();
}

class _RolladenCloudListScreenState extends State<RolladenCloudListScreen> {
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
          .eq('type', 'rolladen')
          .order('created_at', ascending: false);

      _items = List<Map<String, dynamic>>.from(res);
    } catch (e) {
      _err = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _add() async {
    final res = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(
        builder: (_) => const RolladenCloudFormScreen(),
      ),
    );

    if (res == null) return;

    try {
      await _client.from('items').insert({
        'room_id': widget.roomId,
        'type': 'rolladen',
        'data': res,
      });

      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  Future<void> _delete(String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Rollladen löschen?"),
        content: const Text("Willst du diesen Rollladen wirklich löschen?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Abbrechen"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD32F2F)),
            child: const Text("Löschen"),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await _client.from('items').delete().eq('id', id);
      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rollladen • ${widget.roomName} (Cloud)"),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text("Neu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_err != null) ...[
              Text(_err!, style: const TextStyle(color: Color(0xFFD32F2F))),
              const SizedBox(height: 12),
            ],
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _items.isEmpty
                      ? const _EmptyState(
                          text: "Noch keine Rollläden.\nTippe auf „Neu“.",
                        )
                      : ListView.separated(
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final row = _items[i];
                            final id = row['id'] as String;
                            final data = (row['data'] as Map).cast<String, dynamic>();

                            final nr = (data['rolladenNr'] ?? '') as String;
                            final b = (data['breiteMm'] ?? '') as String;
                            final h = (data['hoeheMm'] ?? '') as String;
                            final art = (data['kastenart'] ?? '') as String;

                            return _ListCard(
                              title: "Rollladen $nr",
                              subtitle: "$b × $h mm • $art",
                              trailing: IconButton(
                                onPressed: () => _delete(id),
                                icon: const Icon(Icons.delete),
                              ),
                              onTap: () => _showDetails(context, data),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, Map<String, dynamic> d) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Rollladen ${d['rolladenNr'] ?? ''}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              _kv("Breite", "${d['breiteMm'] ?? ''} mm"),
              _kv("Höhe", "${d['hoeheMm'] ?? ''} mm"),
              _kv("Kastenart", "${d['kastenart'] ?? ''}"),
              _kv("Kastenhöhe", "${d['kastenhoeheMm'] ?? ''} mm"),
              _kv("Panzerprofil", "${d['panzerprofil'] ?? ''}"),
              _kv("Farbe", "${d['farbe'] ?? ''}"),
              _kv("Antrieb", "${d['antrieb'] ?? ''}"),
              _kv("Barrierefrei", "${d['barrierefrei'] ?? ''}"),
              if (((d['notizen'] ?? '') as String).trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text("Notizen", style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text("${d['notizen']}"),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class RolladenCloudFormScreen extends StatefulWidget {
  const RolladenCloudFormScreen({super.key});

  @override
  State<RolladenCloudFormScreen> createState() => _RolladenCloudFormScreenState();
}

class _RolladenCloudFormScreenState extends State<RolladenCloudFormScreen> {
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

      final data = <String, dynamic>{
        "rolladenNr": _nr.text.trim(),
        "breiteMm": _breite.text.trim(),
        "hoeheMm": _hoehe.text.trim(),
        "kastenart": _kastenart,
        "kastenhoeheMm": _kastenhoehe.text.trim(),
        "panzerprofil": _panzer,
        "farbe": _farbe.text.trim(),
        "antrieb": _antrieb,
        "barrierefrei": _barrierefrei ? "Ja" : "Nein",
        "notizen": _notizen.text.trim(),
      };

      Navigator.pop(context, data);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Neuer Rollladen (Cloud)")),
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

              tf(_kastenhoehe, "Kastenhöhe (mm) (optional)", keyboard: TextInputType.number),

              dd(
                label: "Panzerprofil *",
                value: _panzer,
                items: const ["Alu", "PVC", "Stahl"],
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
// =======================================================
// SUPABASE CLOUD: FLIEGENGITTER
// items: type="fliegengitter", data=json
// =======================================================

class FliegengitterCloudListScreen extends StatefulWidget {
  final String roomId;
  final String roomName;

  const FliegengitterCloudListScreen({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  @override
  State<FliegengitterCloudListScreen> createState() =>
      _FliegengitterCloudListScreenState();
}

class _FliegengitterCloudListScreenState
    extends State<FliegengitterCloudListScreen> {
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
          .eq('type', 'fliegengitter')
          .order('created_at', ascending: false);

      _items = List<Map<String, dynamic>>.from(res);
    } catch (e) {
      _err = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _add() async {
    final res = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(
        builder: (_) => const FliegengitterCloudFormScreen(),
      ),
    );

    if (res == null) return;

    try {
      await _client.from('items').insert({
        'room_id': widget.roomId,
        'type': 'fliegengitter',
        'data': res,
      });

      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  Future<void> _delete(String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Fliegengitter löschen?"),
        content: const Text("Willst du dieses Fliegengitter wirklich löschen?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Abbrechen"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD32F2F)),
            child: const Text("Löschen"),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await _client.from('items').delete().eq('id', id);
      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fliegengitter • ${widget.roomName} (Cloud)"),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text("Neu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_err != null) ...[
              Text(_err!, style: const TextStyle(color: Color(0xFFD32F2F))),
              const SizedBox(height: 12),
            ],
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _items.isEmpty
                      ? const _EmptyState(
                          text: "Noch keine Fliegengitter.\nTippe auf „Neu“.",
                        )
                      : ListView.separated(
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final row = _items[i];
                            final id = row['id'] as String;
                            final data = (row['data'] as Map).cast<String, dynamic>();

                            final nr = (data['gitterNr'] ?? '') as String;
                            final b = (data['breiteMm'] ?? '') as String;
                            final h = (data['hoeheMm'] ?? '') as String;
                            final typ = (data['typ'] ?? '') as String;

                            return _ListCard(
                              title: "Fliegengitter $nr",
                              subtitle: "$b × $h mm • $typ",
                              trailing: IconButton(
                                onPressed: () => _delete(id),
                                icon: const Icon(Icons.delete),
                              ),
                              onTap: () => _showDetails(context, data),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, Map<String, dynamic> d) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Fliegengitter ${d['gitterNr'] ?? ''}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              _kv("Breite", "${d['breiteMm'] ?? ''} mm"),
              _kv("Höhe", "${d['hoeheMm'] ?? ''} mm"),
              _kv("Typ", "${d['typ'] ?? ''}"),
              _kv("Rahmenfarbe", "${d['rahmenfarbe'] ?? ''}"),
              _kv("Gewebe", "${d['gewebe'] ?? ''}"),
              _kv("Montage", "${d['montage'] ?? ''}"),
              _kv("Barrierefrei", "${d['barrierefrei'] ?? ''}"),
              if (((d['notizen'] ?? '') as String).trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text("Notizen", style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text("${d['notizen']}"),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class FliegengitterCloudFormScreen extends StatefulWidget {
  const FliegengitterCloudFormScreen({super.key});

  @override
  State<FliegengitterCloudFormScreen> createState() =>
      _FliegengitterCloudFormScreenState();
}

class _FliegengitterCloudFormScreenState
    extends State<FliegengitterCloudFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nr = TextEditingController();
  final _breite = TextEditingController();
  final _hoehe = TextEditingController();
  final _rahmenfarbe = TextEditingController();
  final _notizen = TextEditingController();

  String _typ = "Spannrahmen";
  String _gewebe = "Standard";
  String _montage = "Einclip";
  bool _barrierefrei = false;

  @override
  void dispose() {
    _nr.dispose();
    _breite.dispose();
    _hoehe.dispose();
    _rahmenfarbe.dispose();
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

      final data = <String, dynamic>{
        "gitterNr": _nr.text.trim(),
        "breiteMm": _breite.text.trim(),
        "hoeheMm": _hoehe.text.trim(),
        "typ": _typ,
        "rahmenfarbe": _rahmenfarbe.text.trim(),
        "gewebe": _gewebe,
        "montage": _montage,
        "barrierefrei": _barrierefrei ? "Ja" : "Nein",
        "notizen": _notizen.text.trim(),
      };

      Navigator.pop(context, data);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Neues Fliegengitter (Cloud)")),
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
                items: const ["Spannrahmen", "Drehtür", "Schiebetür", "Rollo"],
                onChanged: (v) => setState(() => _typ = v),
              ),

              tf(_rahmenfarbe, "Rahmenfarbe *"),

              dd(
                label: "Gewebe *",
                value: _gewebe,
                items: const ["Standard", "Pollenschutz", "Edelstahl", "Haustier"],
                onChanged: (v) => setState(() => _gewebe = v),
              ),

              dd(
                label: "Montage *",
                value: _montage,
                items: const ["Einclip", "Schrauben", "Magnet"],
                onChanged: (v) => setState(() => _montage = v),
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
// =======================================================
// SUPABASE CLOUD: DACHFENSTER
// items: type="dachfenster", data=json
// =======================================================

class DachfensterCloudListScreen extends StatefulWidget {
  final String roomId;
  final String roomName;

  const DachfensterCloudListScreen({
    super.key,
    required this.roomId,
    required this.roomName,
  });

  @override
  State<DachfensterCloudListScreen> createState() =>
      _DachfensterCloudListScreenState();
}

class _DachfensterCloudListScreenState extends State<DachfensterCloudListScreen> {
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
          .eq('type', 'dachfenster')
          .order('created_at', ascending: false);

      _items = List<Map<String, dynamic>>.from(res);
    } catch (e) {
      _err = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _add() async {
    final res = await Navigator.push<Map<String, dynamic>?>(
      context,
      MaterialPageRoute(
        builder: (_) => const DachfensterCloudFormScreen(),
      ),
    );

    if (res == null) return;

    try {
      await _client.from('items').insert({
        'room_id': widget.roomId,
        'type': 'dachfenster',
        'data': res,
      });

      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  Future<void> _delete(String id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Dachfenster löschen?"),
        content: const Text("Willst du dieses Dachfenster wirklich löschen?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Abbrechen"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: const Color(0xFFD32F2F)),
            child: const Text("Löschen"),
          ),
        ],
      ),
    );

    if (ok != true) return;

    try {
      await _client.from('items').delete().eq('id', id);
      await _load();
    } catch (e) {
      _toast(context, "Fehler: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dachfenster • ${widget.roomName} (Cloud)"),
        actions: [
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        icon: const Icon(Icons.add),
        label: const Text("Neu"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_err != null) ...[
              Text(_err!, style: const TextStyle(color: Color(0xFFD32F2F))),
              const SizedBox(height: 12),
            ],
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _items.isEmpty
                      ? const _EmptyState(
                          text: "Noch keine Dachfenster.\nTippe auf „Neu“.",
                        )
                      : ListView.separated(
                          itemCount: _items.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final row = _items[i];
                            final id = row['id'] as String;
                            final data = (row['data'] as Map).cast<String, dynamic>();

                            final nr = (data['dachfensterNr'] ?? '') as String;
                            final b = (data['breiteMm'] ?? '') as String;
                            final h = (data['hoeheMm'] ?? '') as String;
                            final hersteller = (data['hersteller'] ?? '') as String;

                            return _ListCard(
                              title: "Dachfenster $nr",
                              subtitle: "$b × $h mm • $hersteller",
                              trailing: IconButton(
                                onPressed: () => _delete(id),
                                icon: const Icon(Icons.delete),
                              ),
                              onTap: () => _showDetails(context, data),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, Map<String, dynamic> d) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dachfenster ${d['dachfensterNr'] ?? ''}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              _kv("Breite", "${d['breiteMm'] ?? ''} mm"),
              _kv("Höhe", "${d['hoeheMm'] ?? ''} mm"),
              _kv("Hersteller", "${d['hersteller'] ?? ''}"),
              _kv("Typ", "${d['typ'] ?? ''}"),
              _kv("Öffnungsart", "${d['oeffnungsart'] ?? ''}"),
              _kv("Verglasung", "${d['verglasung'] ?? ''}"),
              _kv("Farbe außen", "${d['farbeAussen'] ?? ''}"),
              _kv("Farbe innen", "${d['farbeInnen'] ?? ''}"),
              _kv("Sicherheitsstufe", "${d['sicherheitsstufe'] ?? ''}"),
              _kv("Barrierefrei", "${d['barrierefrei'] ?? ''}"),
              if (((d['notizen'] ?? '') as String).trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                const Text("Notizen", style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text("${d['notizen']}"),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class DachfensterCloudFormScreen extends StatefulWidget {
  const DachfensterCloudFormScreen({super.key});

  @override
  State<DachfensterCloudFormScreen> createState() =>
      _DachfensterCloudFormScreenState();
}

class _DachfensterCloudFormScreenState extends State<DachfensterCloudFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nr = TextEditingController();
  final _breite = TextEditingController();
  final _hoehe = TextEditingController();
  final _hersteller = TextEditingController();
  final _farbeAussen = TextEditingController();
  final _farbeInnen = TextEditingController();
  final _notizen = TextEditingController();

  String _typ = "Schwingfenster";
  String _oeffnungsart = "Manuell";
  String _verglasung = "2-fach";
  String _sicherheit = "Standard";
  bool _barrierefrei = false;

  @override
  void dispose() {
    _nr.dispose();
    _breite.dispose();
    _hoehe.dispose();
    _hersteller.dispose();
    _farbeAussen.dispose();
    _farbeInnen.dispose();
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

      final data = <String, dynamic>{
        "dachfensterNr": _nr.text.trim(),
        "breiteMm": _breite.text.trim(),
        "hoeheMm": _hoehe.text.trim(),
        "hersteller": _hersteller.text.trim(),
        "typ": _typ,
        "oeffnungsart": _oeffnungsart,
        "verglasung": _verglasung,
        "farbeAussen": _farbeAussen.text.trim(),
        "farbeInnen": _farbeInnen.text.trim(),
        "sicherheitsstufe": _sicherheit,
        "barrierefrei": _barrierefrei ? "Ja" : "Nein",
        "notizen": _notizen.text.trim(),
      };

      Navigator.pop(context, data);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Neues Dachfenster (Cloud)")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              tf(_nr, "DachfensterNr. *"),
              tf(_breite, "Breite (mm) *", keyboard: TextInputType.number),
              tf(_hoehe, "Höhe (mm) *", keyboard: TextInputType.number),

              tf(_hersteller, "Hersteller *"),

              dd(
                label: "Typ *",
                value: _typ,
                items: const ["Schwingfenster", "Klapp-Schwing", "Ausstieg", "Lichtband"],
                onChanged: (v) => setState(() => _typ = v),
              ),

              dd(
                label: "Öffnungsart *",
                value: _oeffnungsart,
                items: const ["Manuell", "Elektrisch", "Solar"],
                onChanged: (v) => setState(() => _oeffnungsart = v),
              ),

              dd(
                label: "Verglasung *",
                value: _verglasung,
                items: const ["2-fach", "3-fach", "Sicherheitsglas"],
                onChanged: (v) => setState(() => _verglasung = v),
              ),

              tf(_farbeAussen, "Farbe außen *"),
              tf(_farbeInnen, "Farbe innen *"),

              dd(
                label: "Sicherheitsstufe *",
                value: _sicherheit,
                items: const ["Standard", "RC1", "RC2"],
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
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

// =======================================================
// PDF EXPORT PROFI: AUFMASS (Projekt → Räume → Elemente)
// =======================================================

Future<void> exportProjectPdf({
  required BuildContext context,
  required String projectId,
  required String projectName,
}) async {
  final client = Supabase.instance.client;

  try {
    // ----------------------------
    // 1) Projekt laden (für Profi-Kopf)
    // ----------------------------
    final projRes = await client
        .from('projects')
        .select('id, name, customer, address, created_at')
        .eq('id', projectId)
        .single();

    final proj = (projRes as Map).cast<String, dynamic>();
    final customer = (proj['customer'] ?? '') as String;
    final address = (proj['address'] ?? '') as String;

    // ----------------------------
    // 2) Räume laden
    // ----------------------------
    final roomsRes = await client
        .from('rooms')
        .select('id, name, created_at')
        .eq('project_id', projectId)
        .order('created_at', ascending: true);

    final rooms = List<Map<String, dynamic>>.from(roomsRes);

    // ----------------------------
    // 3) Items laden (alle Räume)
    // ----------------------------
    final roomIds = rooms.map((r) => r['id'] as String).toList();

    List<Map<String, dynamic>> items = [];
    if (roomIds.isNotEmpty) {
      final itemsRes = await client
          .from('items')
          .select('id, room_id, type, data, created_at')
          .inFilter('room_id', roomIds)
          .order('created_at', ascending: true);

      items = List<Map<String, dynamic>>.from(itemsRes);
    }

    // group by room
    final itemsByRoom = <String, List<Map<String, dynamic>>>{};
    for (final it in items) {
      final rid = it['room_id'] as String;
      itemsByRoom.putIfAbsent(rid, () => []);
      itemsByRoom[rid]!.add(it);
    }

    // ----------------------------
    // 4) PDF erstellen
    // ----------------------------
    final doc = pw.Document();
    final now = DateTime.now();
    final df = DateFormat('dd.MM.yyyy – HH:mm');

    // Farben/Styles
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

    // Helfer: Kopfzeile (oben auf jeder Seite)
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
                  pw.Text(projectName, style: small),
                ],
              ),
            ),
            pw.Text(df.format(now), style: small),
          ],
        ),
      );
    }

    // Helfer: Fußzeile
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

    // Helfer: Info-Kästchen
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

    // Helfer: Tabellenblock pro Typ
    pw.Widget tableForType(String type, List<Map<String, dynamic>> rows) {
      // Spalten je Typ
      List<String> headers;
      List<List<String>> data;

      String mm(dynamic v) => (v == null || v.toString().trim().isEmpty)
          ? ""
          : "${v.toString()}";

      switch (type) {
        case 'fenster':
          headers = ["Nr", "BxH (mm)", "Öffnung", "Anschlag", "Rahmen", "Farbe", "Glas"];
          data = rows.map((row) {
            final d = (row['data'] as Map).cast<String, dynamic>();
            return [
              (d['fensterNr'] ?? '').toString(),
              "${mm(d['breiteMm'])}×${mm(d['hoeheMm'])}",
              (d['oeffnungsart'] ?? '').toString(),
              (d['anschlagsrichtung'] ?? '').toString(),
              (d['rahmenart'] ?? '').toString(),
              (d['farbe'] ?? '').toString(),
              (d['glasart'] ?? '').toString(),
            ];
          }).toList();
          break;

        case 'zimmertuer':
          headers = ["Nr", "BxH (mm)", "Öffnung", "Anschlag", "Rahmen", "Zarge", "Farbe"];
          data = rows.map((row) {
            final d = (row['data'] as Map).cast<String, dynamic>();
            return [
              (d['tuerNr'] ?? '').toString(),
              "${mm(d['breiteMm'])}×${mm(d['hoeheMm'])}",
              (d['oeffnungsart'] ?? '').toString(),
              (d['anschlag'] ?? '').toString(),
              (d['rahmenart'] ?? '').toString(),
              (d['zarge'] ?? '').toString(),
              (d['farbe'] ?? '').toString(),
            ];
          }).toList();
          break;

        case 'haustuer':
          headers = ["Nr", "BxH (mm)", "Öffnung", "Anschlag", "Material", "Farbe", "Sicherh."];
          data = rows.map((row) {
            final d = (row['data'] as Map).cast<String, dynamic>();
            return [
              (d['haustuerNr'] ?? '').toString(),
              "${mm(d['breiteMm'])}×${mm(d['hoeheMm'])}",
              (d['oeffnungsart'] ?? '').toString(),
              (d['anschlag'] ?? '').toString(),
              (d['material'] ?? '').toString(),
              (d['farbe'] ?? '').toString(),
              (d['sicherheitsstufe'] ?? '').toString(),
            ];
          }).toList();
          break;

        case 'rolladen':
          headers = ["Nr", "BxH (mm)", "Kastenart", "Kastenhöhe", "Panzer", "Farbe", "Antrieb"];
          data = rows.map((row) {
            final d = (row['data'] as Map).cast<String, dynamic>();
            return [
              (d['rolladenNr'] ?? '').toString(),
              "${mm(d['breiteMm'])}×${mm(d['hoeheMm'])}",
              (d['kastenart'] ?? '').toString(),
              (d['kastenhoeheMm'] ?? '').toString(),
              (d['panzerprofil'] ?? '').toString(),
              (d['farbe'] ?? '').toString(),
              (d['antrieb'] ?? '').toString(),
            ];
          }).toList();
          break;

        case 'fliegengitter':
          headers = ["Nr", "BxH (mm)", "Typ", "Rahmenfarbe", "Gewebe", "Montage", "Hinweis"];
          data = rows.map((row) {
            final d = (row['data'] as Map).cast<String, dynamic>();
            return [
              (d['gitterNr'] ?? '').toString(),
              "${mm(d['breiteMm'])}×${mm(d['hoeheMm'])}",
              (d['typ'] ?? '').toString(),
              (d['rahmenfarbe'] ?? '').toString(),
              (d['gewebe'] ?? '').toString(),
              (d['montage'] ?? '').toString(),
              (d['notizen'] ?? '').toString(),
            ];
          }).toList();
          break;

        case 'dachfenster':
          headers = ["Nr", "BxH (mm)", "Hersteller", "Typ", "Öffnung", "Verglasung", "Sicherh."];
          data = rows.map((row) {
            final d = (row['data'] as Map).cast<String, dynamic>();
            return [
              (d['dachfensterNr'] ?? '').toString(),
              "${mm(d['breiteMm'])}×${mm(d['hoeheMm'])}",
              (d['hersteller'] ?? '').toString(),
              (d['typ'] ?? '').toString(),
              (d['oeffnungsart'] ?? '').toString(),
              (d['verglasung'] ?? '').toString(),
              (d['sicherheitsstufe'] ?? '').toString(),
            ];
          }).toList();
          break;

        default:
          headers = ["Info"];
          data = rows.map((row) => ["${row['data']}"]).toList();
      }

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
            columnWidths: {
              0: const pw.FixedColumnWidth(52),
            },
            border: pw.TableBorder.all(color: PdfColors.grey300),
          ),
          pw.SizedBox(height: 12),
        ],
      );
    }

    // ----------------------------
    // 4A) Deckblatt
    // ----------------------------
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        build: (ctx) {
          final totalItems = items.length;
          final totalRooms = rooms.length;

          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              header(),
              pw.SizedBox(height: 16),
              pw.Text("Aufmaßprotokoll", style: h1),
              pw.SizedBox(height: 10),

              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: infoBox(
                      title: "Projektinformationen",
                      lines: [
                        "Projekt: $projectName",
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
                        "Räume: $totalRooms",
                        "Positionen: $totalItems",
                        "Einheit: mm",
                        "Quelle: Supabase Cloud",
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 16),
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  borderRadius: pw.BorderRadius.circular(10),
                  border: pw.Border.all(color: PdfColors.grey300),
                ),
                child: pw.Text(
                  "Hinweis: Dieses Dokument wurde automatisch in FensterPro erzeugt. "
                  "Alle Maße und Angaben sind vor Bestellung/Montage zu prüfen.",
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ),

              pw.Spacer(),

              // Unterschriftenblock
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: lightGrey,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Unterschriften", style: h2),
                    pw.SizedBox(height: 12),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(height: 1, color: PdfColors.grey600),
                              pw.SizedBox(height: 6),
                              pw.Text("Monteur / Aufmaßnehmer", style: small),
                            ],
                          ),
                        ),
                        pw.SizedBox(width: 18),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(height: 1, color: PdfColors.grey600),
                              pw.SizedBox(height: 6),
                              pw.Text("Kunde / Auftraggeber", style: small),
                            ],
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 12),
                    pw.Text("Datum: ____________________", style: small),
                  ],
                ),
              ),

              footer(ctx),
            ],
          );
        },
      ),
    );

    // ----------------------------
    // 4B) Pro Raum eine Profi-Seite mit Tabellen
    // ----------------------------
    final order = [
      'fenster',
      'zimmertuer',
      'haustuer',
      'rolladen',
      'fliegengitter',
      'dachfenster'
    ];

    for (final room in rooms) {
      final rid = room['id'] as String;
      final rname = (room['name'] ?? '') as String;
      final roomItems = itemsByRoom[rid] ?? [];

      final grouped = <String, List<Map<String, dynamic>>>{};
      for (final it in roomItems) {
        final t = (it['type'] ?? '') as String;
        grouped.putIfAbsent(t, () => []);
        grouped[t]!.add(it);
      }

      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(28),
          header: (_) => header(),
          footer: (ctx) => footer(ctx),
          build: (ctx) {
            final widgets = <pw.Widget>[];

            widgets.add(
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: lightGrey,
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      child: pw.Text("Raum: $rname",
                          style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: dark)),
                    ),
                    pw.Text("Positionen: ${roomItems.length}", style: small),
                  ],
                ),
              ),
            );
            widgets.add(pw.SizedBox(height: 12));

            if (roomItems.isEmpty) {
              widgets.add(pw.Text("Keine Elemente in diesem Raum erfasst.", style: body));
              return widgets;
            }

            for (final t in order) {
              final list = grouped[t] ?? [];
              if (list.isEmpty) continue;
              widgets.add(tableForType(t, list));
            }

            // Falls später neue Typen existieren:
            for (final entry in grouped.entries) {
              if (order.contains(entry.key)) continue;
              widgets.add(tableForType(entry.key, entry.value));
            }

            // Notiz / Bemerkungen am Ende
            widgets.add(
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(10),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Bemerkungen", style: h2),
                    pw.SizedBox(height: 30),
                    pw.Container(height: 1, color: PdfColors.grey300),
                    pw.SizedBox(height: 12),
                    pw.Container(height: 1, color: PdfColors.grey300),
                    pw.SizedBox(height: 12),
                    pw.Container(height: 1, color: PdfColors.grey300),
                  ],
                ),
              ),
            );

            return widgets;
          },
        ),
      );
    }

    // ----------------------------
    // 5) Anzeigen / Drucken / Teilen
    // ----------------------------
    final Uint8List bytes = await doc.save();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => bytes,
      name: "FensterPro_Aufmass_${projectName.replaceAll(' ', '_')}.pdf",
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("PDF Profi Export Fehler: $e")),
    );
  }
}
