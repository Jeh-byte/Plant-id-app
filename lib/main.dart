import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'diagnose.dart';
import 'plantnet.dart';

void main() {
  runApp(const PlantIdApp());
}

class PlantIdApp extends StatelessWidget {
  const PlantIdApp({super.key, this.plantNet, this.doctor});

  final PlantNetClient? plantNet;
  final PlantDoctor? doctor;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant ID',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: HomeScreen(plantNet: plantNet, doctor: doctor),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.plantNet, this.doctor});

  /// Injectable for tests; default to the real clients.
  final PlantNetClient? plantNet;
  final PlantDoctor? doctor;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  late final PlantNetClient _plantNet = widget.plantNet ?? PlantNetClient();
  late final PlantDoctor _doctor = widget.doctor ?? PlantDoctor();

  XFile? _photo;
  bool _identifying = false;
  List<PlantMatch>? _matches;
  String? _error;
  bool _diagnosing = false;
  String? _diagnosis;
  String? _diagnosisError;

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
        _diagnosis = null;
        _diagnosisError = null;
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

  Future<void> _diagnose() async {
    final photo = _photo;
    if (photo == null) return;
    final best = _matches?.isNotEmpty == true ? _matches!.first : null;
    setState(() {
      _diagnosing = true;
      _diagnosisError = null;
    });
    try {
      final text = await _doctor.diagnose(
        photo.path,
        plantNetGuess: best == null
            ? null
            : '${best.scientificName} (${(best.score * 100).round()}%)',
      );
      if (!mounted) return;
      setState(() => _diagnosis = text);
    } catch (e) {
      if (!mounted) return;
      setState(() => _diagnosisError = '$e');
    } finally {
      if (mounted) setState(() => _diagnosing = false);
    }
  }

  bool get _busy => _identifying || _diagnosing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Plant ID')),
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
                        if (!_identifying) ..._healthSection(theme),
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

extension on _HomeScreenState {
  List<Widget> _healthSection(ThemeData theme) {
    if (!_doctor.hasKey) return const [];
    if (_diagnosing) {
      return const [
        SizedBox(height: 16),
        Center(child: CircularProgressIndicator()),
        SizedBox(height: 8),
        Text('Checking for diseases and pests…', textAlign: TextAlign.center),
      ];
    }
    return [
      const SizedBox(height: 16),
      if (_diagnosis != null)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SelectableText(_diagnosis!),
          ),
        ),
      if (_diagnosisError != null)
        Text(
          _diagnosisError!,
          style: TextStyle(color: theme.colorScheme.error),
        ),
      if (_diagnosis == null)
        OutlinedButton.icon(
          key: const Key('diagnoseButton'),
          onPressed: _diagnose,
          icon: const Icon(Icons.healing),
          label: const Text('Check health, pests & natural remedies'),
        ),
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
