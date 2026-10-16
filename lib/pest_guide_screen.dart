import 'package:flutter/material.dart';

import 'pest_guide_data.dart';

/// Pick the symptoms you can see to get likely causes and natural remedies.
class PestGuideScreen extends StatefulWidget {
  const PestGuideScreen({super.key});

  @override
  State<PestGuideScreen> createState() => _PestGuideScreenState();
}

class _PestGuideScreenState extends State<PestGuideScreen> {
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final matches = matchProblems(_selected);
    return Scaffold(
      appBar: AppBar(title: const Text('Pests & diseases')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('What do you see?', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final s in symptoms)
                FilterChip(
                  label: Text(s.label),
                  selected: _selected.contains(s.id),
                  onSelected: (on) => setState(
                    () => on ? _selected.add(s.id) : _selected.remove(s.id),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (_selected.isEmpty)
            Text(
              'Tap one or more symptoms to see likely causes and natural '
              'remedies.',
              style: theme.textTheme.bodyLarge,
            )
          else ...[
            Text('Likely causes', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            for (final p in matches) _ProblemCard(problem: p),
            const SizedBox(height: 16),
            Text(
              'Herbs you plan to eat or use: wash well after any spray, and '
              'wait a few days after neem or oil sprays before harvesting.',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }
}

class _ProblemCard extends StatelessWidget {
  const _ProblemCard({required this.problem});

  final PlantProblem problem;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: ExpansionTile(
        title: Text(problem.name),
        subtitle: Text(problem.kind),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(problem.signs),
          const SizedBox(height: 12),
          Text('Natural remedies', style: theme.textTheme.titleSmall),
          for (final r in problem.remedies) Text('• $r'),
          const SizedBox(height: 12),
          Text('Prevention', style: theme.textTheme.titleSmall),
          for (final r in problem.prevention) Text('• $r'),
        ],
      ),
    );
  }
}
