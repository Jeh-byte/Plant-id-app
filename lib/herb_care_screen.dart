import 'package:flutter/material.dart';

import 'herb_care_data.dart';

/// Searchable list of herb care cards.
class HerbCareScreen extends StatefulWidget {
  const HerbCareScreen({super.key});

  @override
  State<HerbCareScreen> createState() => _HerbCareScreenState();
}

class _HerbCareScreenState extends State<HerbCareScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final q = _query.toLowerCase();
    final cards = [
      for (final c in herbCards)
        if (c.name.toLowerCase().contains(q) ||
            c.scientificName.toLowerCase().contains(q))
          c,
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Herb care')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search herbs',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
          const SizedBox(height: 12),
          for (final c in cards)
            Card(
              child: ListTile(
                title: Text(c.name),
                subtitle: Text(
                  c.scientificName,
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => openHerbCard(context, c),
              ),
            ),
        ],
      ),
    );
  }
}

void openHerbCard(BuildContext context, HerbCard card) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => HerbCardScreen(card: card)));
}

class HerbCardScreen extends StatelessWidget {
  const HerbCardScreen({super.key, required this.card});

  final HerbCard card;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget row(IconData icon, String label, String text) => ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(label, style: theme.textTheme.titleSmall),
      subtitle: Text(text, style: theme.textTheme.bodyLarge),
    );
    return Scaffold(
      appBar: AppBar(title: Text(card.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            card.scientificName,
            style: theme.textTheme.titleMedium?.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          row(Icons.wb_sunny_outlined, 'Sun', card.sun),
          row(Icons.water_drop_outlined, 'Water', card.water),
          row(Icons.grass, 'Soil', card.soil),
          const SizedBox(height: 8),
          Text('Growing tips', style: theme.textTheme.titleMedium),
          for (final t in card.tips)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text('• $t'),
            ),
          if (card.uses != null) ...[
            const SizedBox(height: 16),
            Text('Traditional uses', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(card.uses!),
            const SizedBox(height: 8),
            Text(
              'General information only, not medical advice.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}
