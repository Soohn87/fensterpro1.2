import 'package:flutter/material.dart';

void main() {
  runApp(const FensterProApp());
}

/// =============================
///  APP ROOT
/// =============================
class FensterProApp extends StatelessWidget {
  const FensterProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FensterPro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const StartScreen(),
    );
  }
}

/// =============================
///  STARTSCREEN (Fenster / Zimmertüren)
/// =============================
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _HomeCard(
        title: "Fenster",
        subtitle: "Aufmaß für Fenster erfassen",
        icon: Icons.window,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FensterListScreen()),
        ),
      ),
      _HomeCard(
        title: "Zimmertüren",
        subtitle: "Aufmaß für Innentüren erfassen",
        icon: Icons.door_front_door,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TuerenListScreen()),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("FensterPro"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Kategorie wählen",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: cards.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, i) => cards[i],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Hinweis: Offline-Modus aktiv. Später speichern wir Projekte dauerhaft + PDF Export.",
              style: TextStyle(fontSize: 12, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _HomeCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1.5,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style:
                            const TextStyle(fontSize: 13, color: Colors.black54)),
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

/// =============================
///  MODELS
/// =============================
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
  final String notizen; // optional

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
  final String din; // links/rechts
  final String oeffnungsrichtung; // innen/außen
  final String zarge; // Blockzarge/Umfassungszarge/etc.
  final String wandstaerkeMm;
  final String tuerblatt;
  final String farbe;
  final String schlossGarnitur;
  final String barrierefrei; // ja/nein
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

/// =============================
///  FENSTER LIST
/// =============================
class FensterListScreen extends StatefulWidget {
  const FensterListScreen({super.key});

  @override
  State<FensterListScreen> createState() => _FensterListScreenState();
}

class _FensterListScreenState extends State<FensterListScreen> {
  final List<FensterItem> _items = [];

  void _addFenster(FensterItem item) {
    setState(() => _items.add(item));
  }

  void _removeAt(int index) {
    setState(() => _items.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fenster"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push<FensterItem?>(
            context,
            MaterialPageRoute(builder: (_) => const FensterFormScreen()),
          );
          if (res != null) _addFenster(res);
        },
        icon: const Icon(Icons.add),
        label: const Text("Neu"),
      ),
      body: _items.isEmpty
          ? const _EmptyState(text: "Noch keine Fenster erfasst.\nTippe auf „Neu“.")
          : ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final f = _items[i];
                return Dismissible(
                  key: ValueKey("${f.fensterNr}-$i"),
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _removeAt(i),
                  child: _ListCard(
                    title: "Fenster ${f.fensterNr}",
                    subtitle:
                        "${f.breiteMm} × ${f.hoeheMm} mm • ${f.oeffnungsart} • DIN ${f.anschlagsrichtung}",
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showFensterDetails(context, f),
                  ),
                );
              },
            ),
    );
  }

  void _showFensterDetails(BuildContext context, FensterItem f) {
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
                Text("Fenster ${f.fensterNr}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
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
                  const Text("Notizen",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 6),
                  Text(f.notizen),
                ]
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
              flex: 4,
              child: Text(k,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.black54))),
          Expanded(
              flex: 6,
              child: Text(v,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}

/// =============================
///  FENSTER FORM
/// =============================
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Neues Fenster")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _textField(_fensterNr, "FensterNr. *"),
              _row([
                _textField(_breite, "Breite (mm) *", keyboard: TextInputType.number),
                _textField(_hoehe, "Höhe (mm) *", keyboard: TextInputType.number),
              ]),
              _dropdown(
                label: "Öffnungsart *",
                value: _oeffnungsart,
                items: const ["Dreh/Kipp", "Dreh", "Kipp", "Schiebefenster", "Festverglasung"],
                onChanged: (v) => setState(() => _oeffnungsart = v),
              ),
              _dropdown(
                label: "Anschlagsrichtung *",
                value: _anschlag,
                items: const ["Links", "Rechts"],
                onChanged: (v) => setState(() => _anschlag = v),
              ),
              _textField(_rahmenart, "Rahmenart *"),
              _textField(_farbe, "Farbe *"),
              _textField(_glasart, "Glasart *"),
              _textField(_glasDicke, "Glasdicke (mm) *", keyboard: TextInputType.number),
              _dropdown(
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
              _multiline(_notizen, "Notizen (optional)"),
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

  void _save() {
    final ok = _formKey.currentState!.validate();
    if (!ok) return;

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

  Widget _textField(TextEditingController c, String label,
      {TextInputType keyboard = TextInputType.text}) {
    final isRequired = label.contains("*");
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
          if (!isRequired) return null;
          if (v == null || v.trim().isEmpty) return "Pflichtfeld";
          return null;
        },
      ),
    );
  }

  Widget _multiline(TextEditingController c, String label) {
    return Padding(
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
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => onChanged(v ?? value),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _row(List<Widget> children) {
    return Row(
      children: children
          .map((w) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 10), child: w)))
          .toList()
        ..removeLast(), // remove last padding
    );
  }
}

/// =============================
///  TÜREN LIST
/// =============================
class TuerenListScreen extends StatefulWidget {
  const TuerenListScreen({super.key});

  @override
  State<TuerenListScreen> createState() => _TuerenListScreenState();
}

class _TuerenListScreenState extends State<TuerenListScreen> {
  final List<TuerItem> _items = [];

  void _add(TuerItem item) {
    setState(() => _items.add(item));
  }

  void _removeAt(int index) {
    setState(() => _items.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Zimmertüren")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push<TuerItem?>(
            context,
            MaterialPageRoute(builder: (_) => const TuerFormScreen()),
          );
          if (res != null) _add(res);
        },
        icon: const Icon(Icons.add),
        label: const Text("Neu"),
      ),
      body: _items.isEmpty
          ? const _EmptyState(text: "Noch keine Türen erfasst.\nTippe auf „Neu“.")
          : ListView.separated(
              padding: const EdgeInsets.all(14),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final t = _items[i];
                return Dismissible(
                  key: ValueKey("${t.tuerNr}-$i"),
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(.15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => _removeAt(i),
                  child: _ListCard(
                    title: "Tür ${t.tuerNr}",
                    subtitle: "${t.breiteMm} × ${t.hoeheMm} mm • DIN ${t.din} • ${t.oeffnungsrichtung}",
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showDetails(context, t),
                  ),
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
                  Expanded(
                      flex: 4,
                      child: Text(k,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.black54))),
                  Expanded(
                      flex: 6,
                      child: Text(v,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600))),
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
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w800)),
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
                  const Text("Notizen",
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
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

/// =============================
///  TÜREN FORM
/// =============================
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Neue Zimmertür")),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _tf(_tuerNr, "TürNr. *"),
              _two([
                _tf(_breite, "Breite (mm) *", keyboard: TextInputType.number),
                _tf(_hoehe, "Höhe (mm) *", keyboard: TextInputType.number),
              ]),
              _dd(
                label: "DIN *",
                value: _din,
                items: const ["Links", "Rechts"],
                onChanged: (v) => setState(() => _din = v),
              ),
              _dd(
                label: "Öffnungsrichtung *",
                value: _richtung,
                items: const ["Nach innen", "Nach außen"],
                onChanged: (v) => setState(() => _richtung = v),
              ),
              _dd(
                label: "Zarge *",
                value: _zarge,
                items: const ["Umfassungszarge", "Blockzarge", "Futterzarge", "Ohne"],
                onChanged: (v) => setState(() => _zarge = v),
              ),
              _tf(_wand, "Wandstärke (mm) *", keyboard: TextInputType.number),
              _tf(_tuerblatt, "Türblatt / Oberfläche *"),
              _tf(_farbe, "Farbe *"),
              _tf(_schloss, "Schloss / Garnitur *"),
              SwitchListTile(
                value: _barrierefrei,
                onChanged: (v) => setState(() => _barrierefrei = v),
                title: const Text("Barrierefrei"),
              ),
              _ml(_notizen, "Notizen (optional)"),
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

  Widget _tf(TextEditingController c, String label,
      {TextInputType keyboard = TextInputType.text}) {
    final isRequired = label.contains("*");
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
          if (!isRequired) return null;
          if (v == null || v.trim().isEmpty) return "Pflichtfeld";
          return null;
        },
      ),
    );
  }

  Widget _ml(TextEditingController c, String label) {
    return Padding(
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
  }

  Widget _dd({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: (v) => onChanged(v ?? value),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget _two(List<Widget> children) {
    return Row(
      children: [
        Expanded(child: Padding(padding: const EdgeInsets.only(right: 10), child: children[0])),
        Expanded(child: children[1]),
      ],
    );
  }
}

/// =============================
///  SHARED UI
/// =============================
class _EmptyState extends StatelessWidget {
  final String text;
  const _EmptyState({required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, color: Colors.black54),
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  const _ListCard({
    required this.title,
    required this.subtitle,
    required this.trailing,
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
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style:
                            const TextStyle(fontSize: 13, color: Colors.black54)),
                  ],
                ),
              ),
              trailing
            ],
          ),
        ),
      ),
    );
  }
}

