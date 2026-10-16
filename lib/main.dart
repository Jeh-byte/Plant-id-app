import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'herb_care_data.dart';
import 'herb_care_screen.dart';
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

  final List<PlantPhoto> _photos = [];
  bool _identifying = false;
  List<PlantMatch>? _matches;
  String? _error;

  bool get _canAdd => !_identifying && _photos.length < maxPhotos;

  Future<void> _addPhoto(ImageSource source) async {
    try {
      final photo = await _picker.pickImage(
        source: source,
        maxWidth: 1600,
        imageQuality: 85,
      );
      if (photo == null) return;
      final organ = await _askOrgan();
      setState(() {
        _photos.add(PlantPhoto(photo.path, organ ?? Organ.auto));
        _matches = null;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not get a photo: $e')));
    }
  }

  Future<Organ?> _askOrgan() {
    return showModalBottomSheet<Organ>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(title: Text('What does this photo show?')),
            for (final o in Organ.values)
              ListTile(
                leading: Icon(_organIcon(o)),
                title: Text(o.label),
                onTap: () => Navigator.pop(context, o),
              ),
          ],
        ),
      ),
    );
  }

  void _setOrgan(PlantPhoto photo, Organ organ) {
    setState(() {
      photo.organ = organ;
      _matches = null;
    });
  }

  void _removePhoto(PlantPhoto photo) {
    setState(() {
      _photos.remove(photo);
      _matches = null;
      _error = null;
    });
  }

  Future<void> _identify() async {
    if (_photos.isEmpty) return;
    setState(() {
      _identifying = true;
      _error = null;
    });
    try {
      final matches = await _plantNet.identify(List.of(_photos));
      if (!mounted) return;
      setState(() => _matches = matches);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _identifying = false);
    }
  }

  void _startOver() {
    setState(() {
      _photos.clear();
      _matches = null;
      _error = null;
    });
  }

  void _open(Widget screen) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant ID'),
        actions: [
          IconButton(
            tooltip: 'Herb care',
            icon: const Icon(Icons.spa_outlined),
            onPressed: () => _open(const HerbCareScreen()),
          ),
          IconButton(
            tooltip: 'Pests & diseases',
            icon: const Icon(Icons.bug_report_outlined),
            onPressed: () => _open(const PestGuideScreen()),
          ),
          if (_photos.isNotEmpty)
            IconButton(
              tooltip: 'Start over',
              icon: const Icon(Icons.refresh),
              onPressed: _identifying ? null : _startOver,
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: _photos.isEmpty
                    ? _emptyState(theme)
                    : [
                        Text(
                          'Photos (${_photos.length} of $maxPhotos)',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add a leaf and a flower or fruit of the same plant '
                          'for the best match.',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        for (final p in _photos)
                          _PhotoRow(
                            photo: p,
                            enabled: !_identifying,
                            onOrgan: (o) => _setOrgan(p, o),
                            onRemove: () => _removePhoto(p),
                          ),
                        const SizedBox(height: 8),
                        if (_matches == null && !_identifying && _error == null)
                          FilledButton.icon(
                            key: const Key('identifyButton'),
                            onPressed: _identify,
                            icon: const Icon(Icons.search),
                            label: Text(
                              _photos.length == 1
                                  ? 'Identify'
                                  : 'Identify from ${_photos.length} photos',
                            ),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        const SizedBox(height: 16),
                        ..._resultsSection(theme),
                      ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      key: const Key('cameraButton'),
                      onPressed: _canAdd
                          ? () => _addPhoto(ImageSource.camera)
                          : null,
                      icon: const Icon(Icons.camera_alt),
                      label: Text(_photos.isEmpty ? 'Take photo' : 'Add photo'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _canAdd
                          ? () => _addPhoto(ImageSource.gallery)
                          : null,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _emptyState(ThemeData theme) => [
    const SizedBox(height: 48),
    Icon(Icons.local_florist, size: 96, color: theme.colorScheme.primary),
    const SizedBox(height: 16),
    Text(
      'Take a photo of a plant to identify it',
      textAlign: TextAlign.center,
      style: theme.textTheme.titleMedium,
    ),
    const SizedBox(height: 32),
    OutlinedButton.icon(
      key: const Key('herbCareButton'),
      onPressed: () => _open(const HerbCareScreen()),
      icon: const Icon(Icons.spa_outlined),
      label: const Text('Herb care cards'),
    ),
    const SizedBox(height: 8),
    OutlinedButton.icon(
      key: const Key('pestGuideButton'),
      onPressed: () => _open(const PestGuideScreen()),
      icon: const Icon(Icons.bug_report_outlined),
      label: const Text('Pest & disease guide'),
    ),
  ];

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

IconData _organIcon(Organ organ) => switch (organ) {
  Organ.auto => Icons.help_outline,
  Organ.leaf => Icons.eco_outlined,
  Organ.flower => Icons.local_florist_outlined,
  Organ.fruit => Icons.apple,
  Organ.bark => Icons.forest_outlined,
  Organ.habit => Icons.park_outlined,
};

class _PhotoRow extends StatelessWidget {
  const _PhotoRow({
    required this.photo,
    required this.enabled,
    required this.onOrgan,
    required this.onRemove,
  });

  final PlantPhoto photo;
  final bool enabled;
  final ValueChanged<Organ> onOrgan;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Image.file(
            File(photo.path),
            width: 96,
            height: 96,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                const SizedBox(width: 96, height: 96, child: Icon(Icons.image)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButton<Organ>(
              value: photo.organ,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              onChanged: enabled ? (o) => onOrgan(o!) : null,
              items: [
                for (final o in Organ.values)
                  DropdownMenuItem(
                    value: o,
                    child: Row(
                      children: [
                        Icon(_organIcon(o), size: 20),
                        const SizedBox(width: 8),
                        Text(o.label),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Remove photo',
            icon: const Icon(Icons.close),
            onPressed: enabled ? onRemove : null,
          ),
        ],
      ),
    );
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
    final card = herbCardFor(match.scientificName);
    return Card(
      child: ListTile(
        title: Text(common.isEmpty ? match.scientificName : common),
        subtitle: Text(
          [
            match.scientificName,
            if (match.family.isNotEmpty) match.family,
            if (card != null) 'Tap for care card',
          ].join(' · '),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        trailing: Text('$percent%', style: theme.textTheme.titleMedium),
        onTap: card == null ? null : () => openHerbCard(context, card),
      ),
    );
  }
}
