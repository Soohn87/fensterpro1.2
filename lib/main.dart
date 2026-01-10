import 'package:flutter/material.dart';

void main() {
  runApp(const FensterProApp());
}

class FensterProApp extends StatelessWidget {
  const FensterProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FensterPro',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        useMaterial3: true,
      ),
      home: const ProjectListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

/* =========================
   MODELLE
========================= */

class Project {
  String name;
  List<WindowItem> windows;

  Project(this.name, this.windows);
}

class WindowItem {
  String fensterNr;
  String raum;
  String breite;
  String hoehe;
  String oeffnung;
  String anschlag;
  String rahmen;
  String farbe;
  String glas;
  String glasDicke;
  String sicherheit;
  bool barrierefrei;
  String notizen;

  WindowItem({
    required this.fensterNr,
    required this.raum,
    required this.breite,
    required this.hoehe,
    required this.oeffnung,
    required this.anschlag,
    required this.rahmen,
    required this.farbe,
    required this.glas,
    required this.glasDicke,
    required this.sicherheit,
    required this.barrierefrei,
    required this.notizen,
  });
}

/* =========================
   PROJEKTÜBERSICHT
========================= */

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({super.key});

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  final List<Project> projects = [];

  void addProject() {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Neues Projekt"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Projektname",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  projects.add(Project(controller.text, []));
                });
              }
              Navigator.pop(context);
            },
            child: const Text("Erstellen"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FensterPro – Projekte"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addProject,
        child: const Icon(Icons.add),
      ),
      body: projects.isEmpty
          ? const Center(child: Text("Noch keine Projekte"))
          : ListView.builder(
              itemCount: projects.length,
              itemBuilder: (_, i) {
                return ListTile(
                  title: Text(projects[i].name),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            WindowListPage(project: projects[i]),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

/* =========================
   FENSTERLISTE
========================= */

class WindowListPage extends StatefulWidget {
  final Project project;

  const WindowListPage({super.key, required this.project});

  @override
  State<WindowListPage> createState() => _WindowListPageState();
}

class _WindowListPageState extends State<WindowListPage> {
  bool handwerkerModus = false;

  void addWindow() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WindowFormPage(
          onSave: (window) {
            setState(() {
              widget.project.windows.add(window);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
        actions: [
          Switch(
            value: handwerkerModus,
            onChanged: (v) {
              setState(() => handwerkerModus = v);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addWindow,
        child: const Icon(Icons.add),
      ),
      body: widget.project.windows.isEmpty
          ? const Center(child: Text("Keine Fenster erfasst"))
          : ListView.builder(
              itemCount: widget.project.windows.length,
              itemBuilder: (_, i) {
                final w = widget.project.windows[i];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text("Fenster ${w.fensterNr} – ${w.raum}"),
                    subtitle: Text(
                      handwerkerModus
                          ? "${w.breite} × ${w.hoehe} mm"
                          : "Öffnung: ${w.oeffnung}, Glas: ${w.glas}",
                    ),
                  ),
                );
              },
            ),
    );
  }
}

/* =========================
   FENSTERFORMULAR
========================= */

class WindowFormPage extends StatefulWidget {
  final Function(WindowItem) onSave;

  const WindowFormPage({super.key, required this.onSave});

  @override
  State<WindowFormPage> createState() => _WindowFormPageState();
}

class _WindowFormPageState extends State<WindowFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController fensterNr = TextEditingController();
  final TextEditingController raum = TextEditingController();
  final TextEditingController breite = TextEditingController();
  final TextEditingController hoehe = TextEditingController();
  final TextEditingController notizen = TextEditingController();

  String oeffnung = "Dreh";
  String anschlag = "Links";
  String rahmen = "Kunststoff";
  String farbe = "Weiß";
  String glas = "2-fach";
  String glasDicke = "24 mm";
  String sicherheit = "Standard";
  bool barrierefrei = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Fenster erfassen")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: fensterNr,
                decoration: const InputDecoration(labelText: "Fenster Nr."),
                validator: (v) => v!.isEmpty ? "Pflichtfeld" : null,
              ),
              TextFormField(
                controller: raum,
                decoration: const InputDecoration(labelText: "Raum"),
              ),
              TextFormField(
                controller: breite,
                decoration:
                    const InputDecoration(labelText: "Breite (mm)"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: hoehe,
                decoration:
                    const InputDecoration(labelText: "Höhe (mm)"),
                keyboardType: TextInputType.number,
              ),
              SwitchListTile(
                title: const Text("Barrierefrei"),
                value: barrierefrei,
                onChanged: (v) => setState(() => barrierefrei = v),
              ),
              TextFormField(
                controller: notizen,
                decoration:
                    const InputDecoration(labelText: "Notizen (optional)"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.onSave(
                      WindowItem(
                        fensterNr: fensterNr.text,
                        raum: raum.text,
                        breite: breite.text,
                        hoehe: hoehe.text,
                        oeffnung: oeffnung,
                        anschlag: anschlag,
                        rahmen: rahmen,
                        farbe: farbe,
                        glas: glas,
                        glasDicke: glasDicke,
                        sicherheit: sicherheit,
                        barrierefrei: barrierefrei,
                        notizen: notizen.text,
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text("Speichern"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
