import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'pest_guide_screen.dart';
import 'plantnet.dart';

void main() {
  runApp(const PlantIdApp());
}

class PlantIdApp extends StatelessWidget {
  const PlantIdApp({super.key, this.plantNet});

  final PlantNetClient? plantNet;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant ID',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: HomeScreen(plantNet: plantNet),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.plantNet});

  /// Injectable for tests; defaults to the real Pl@ntNet client.
  final PlantNetClient? plantNet;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  late final PlantNetClient _plantNet = widget.plantNet ?? PlantNetClient();

  XFile? _photo;
  bool _identifying = false;
  List<PlantMatch>? _matches;
  String? _error;

  Future<void> _pick(ImageSource source) async {
    try {
      final photo = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (photo == null) return;
      setState(() {
        _photo = photo;
        _matches = null;
        _error = null;
      });
      await _identify();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not get a photo: $e')));
    }
  }

  Future<void> _identify() async {
    final photo = _photo;
    if (photo == null) return;
    setState(() {
      _identifying = true;
      _error = null;
    });
    try {
      final matches = await _plantNet.identify(photo.path);
      if (!mounted) return;
      setState(() => _matches = matches);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _identifying = false);
    }
  }

  void _openPestGuide() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const PestGuideScreen()));
  }

  bool get _busy => _identifying;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant ID'),
        actions: [
          IconButton(
            tooltip: 'Pests & diseases',
            icon: const Icon(Icons.bug_report_outlined),
            onPressed: _openPestGuide,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: _photo == null
                    ? [
                        const SizedBox(height: 80),
                        Icon(
                          Icons.local_florist,
                          size: 96,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Take a photo of a plant to identify it',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.titleMedium,
                        ),
                      ]
                    : [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Image.file(
                              File(_photo!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._resultsSection(theme),
                      ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    key: const Key('cameraButton'),
                    onPressed: _busy ? null : () => _pick(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Take photo'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _busy ? null : () => _pick(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Choose from gallery'),
                  ),
                  TextButton.icon(
                    key: const Key('pestGuideButton'),
                    onPressed: _openPestGuide,
                    icon: const Icon(Icons.bug_report_outlined),
                    label: const Text('Pest & disease guide'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _resultsSection(ThemeData theme) {
    if (_identifying) {
      return const [
        Center(child: CircularProgressIndicator()),
        SizedBox(height: 8),
        Text('Identifying…', textAlign: TextAlign.center),
      ];
    }
    if (_error != null) {
      return [
        Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: _identify, child: const Text('Try again')),
      ];
    }
    final matches = _matches;
    if (matches == null) return const [];
    if (matches.isEmpty) {
      return [
        Text(
          'No match found. Try a closer photo of a leaf or flower.',
          style: theme.textTheme.titleMedium,
        ),
      ];
    }
    return [
      Text('Best matches', style: theme.textTheme.titleLarge),
      const SizedBox(height: 8),
      for (final m in matches) _MatchTile(match: m),
    ];
  }
}

class _MatchTile extends StatelessWidget {
  const _MatchTile({required this.match});

  final PlantMatch match;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (match.score * 100).round();
    final common = match.commonNames.take(3).join(', ');
    return Card(
      child: ListTile(
        title: Text(common.isEmpty ? match.scientificName : common),
        subtitle: Text(
          [
            match.scientificName,
            if (match.family.isNotEmpty) match.family,
          ].join(' · '),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        trailing: Text('$percent%', style: theme.textTheme.titleMedium),
      ),
    );
  }
}
