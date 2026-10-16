/// Offline guide to common garden pests, diseases and problems, with natural
/// (organic, home-garden) remedies. Written for Australian herb and veggie
/// gardens.
library;

class Symptom {
  const Symptom(this.id, this.label);
  final String id;
  final String label;
}

class PlantProblem {
  const PlantProblem({
    required this.name,
    required this.kind,
    required this.symptoms,
    required this.signs,
    required this.remedies,
    required this.prevention,
  });

  final String name;

  /// Pest, Disease or Growing problem.
  final String kind;
  final Set<String> symptoms;
  final String signs;
  final List<String> remedies;
  final List<String> prevention;
}

const symptoms = [
  Symptom('holes', 'Holes chewed in leaves'),
  Symptom('eaten_overnight', 'Leaves or seedlings eaten overnight'),
  Symptom('slime', 'Shiny slime trails'),
  Symptom('caterpillars', 'Caterpillars or green droppings'),
  Symptom('clusters', 'Clusters of tiny insects on new shoots'),
  Symptom('curled', 'Curled or twisted new leaves'),
  Symptom('sticky', 'Sticky leaves or black sooty coating'),
  Symptom('white_powder', 'White powder on leaves'),
  Symptom('stippling', 'Fine yellow speckles on leaves'),
  Symptom('webbing', 'Fine webbing under leaves'),
  Symptom('cotton', 'White cottony blobs'),
  Symptom('white_flies', 'Tiny white flies when disturbed'),
  Symptom('bumps', 'Hard brown or white bumps on stems'),
  Symptom('silvery', 'Silvery streaks with black specks'),
  Symptom('trails', 'Wiggly pale trails inside leaves'),
  Symptom('spots', 'Brown or black spots on leaves'),
  Symptom('rust', 'Orange or rusty powder under leaves'),
  Symptom('grey_mould', 'Grey fuzzy mould'),
  Symptom('yellow_lower', 'Older lower leaves turning yellow'),
  Symptom('wilting_wet', 'Wilting even though soil is wet'),
  Symptom('soil_flies', 'Small dark flies around the soil'),
  Symptom('seedlings_collapse', 'Seedlings collapse at soil level'),
  Symptom('knobbly_roots', 'Knobbly, swollen roots'),
];

const _soapSpray =
    'Soap spray: 1 tablespoon pure soap flakes or Castile soap dissolved in 1 '
    'litre of water. Spray all surfaces, especially under leaves, every 3 to '
    '5 days.';

const _garlicChilliSpray =
    'Garlic and chilli spray: blend 1 garlic bulb and 2 hot chillies with 1 '
    'litre of water, steep overnight, strain, add 1 teaspoon soap. Test on a '
    'few leaves first.';

const _whiteOil =
    'Homemade white oil: shake 1 cup vegetable oil with 1/4 cup dishwashing '
    'liquid; use 1 tablespoon per litre of water. Do not spray above 30°C or '
    'in full sun.';

const _neem =
    'Neem oil spray (from garden centres) every 7 days, in the evening to '
    'protect bees.';

const problems = [
  PlantProblem(
    name: 'Aphids',
    kind: 'Pest',
    symptoms: {'clusters', 'curled', 'sticky'},
    signs: 'Soft green, black or grey insects bunched on tips and buds.',
    remedies: [
      'Blast them off with a strong jet of water, or squash with fingers.',
      _soapSpray,
      _garlicChilliSpray,
      'Encourage ladybirds, lacewings and hoverflies by planting alyssum, '
          'dill, coriander and calendula nearby.',
    ],
    prevention: [
      'Go easy on high-nitrogen fertiliser, which causes soft sappy growth.',
      'Check new growth weekly.',
    ],
  ),
  PlantProblem(
    name: 'Caterpillars (e.g. cabbage white butterfly)',
    kind: 'Pest',
    symptoms: {'holes', 'caterpillars'},
    signs: 'Irregular holes, green droppings, caterpillars under leaves.',
    remedies: [
      'Hand-pick daily and check the undersides of leaves for eggs.',
      'Spray Bt (Bacillus thuringiensis, e.g. Dipel), a natural bacterium '
          'that only affects caterpillars. Reapply after rain.',
    ],
    prevention: [
      'Cover brassicas and leafy herbs with fine insect netting.',
      'Grow aromatic herbs like sage, thyme and dill as companions.',
    ],
  ),
  PlantProblem(
    name: 'Snails and slugs',
    kind: 'Pest',
    symptoms: {'holes', 'eaten_overnight', 'slime'},
    signs: 'Ragged holes and missing seedlings, shiny trails in the morning.',
    remedies: [
      'Go out at night with a torch and collect them.',
      'Beer traps: sink a shallow container of beer level with the soil.',
      'Use iron-based (iron phosphate) pellets, which are certified organic '
          'and safer for pets and wildlife than older baits.',
      'Copper tape around pots and raised beds.',
    ],
    prevention: [
      'Water in the morning so the soil surface is dry at night.',
      'Remove boards and debris where they hide during the day.',
    ],
  ),
  PlantProblem(
    name: 'Powdery mildew',
    kind: 'Disease',
    symptoms: {'white_powder'},
    signs: 'White, flour-like coating, worst in humid weather.',
    remedies: [
      'Milk spray: 1 part milk to 9 parts water, sprayed weekly in sunshine.',
      'Bicarb spray: 1 teaspoon bicarbonate of soda and a few drops of oil '
          'per litre of water.',
      'Pick off and bin (do not compost) the worst leaves.',
    ],
    prevention: [
      'Space plants for good airflow.',
      'Water the soil, not the leaves, and water early in the day.',
    ],
  ),
  PlantProblem(
    name: 'Two-spotted mite (red spider mite)',
    kind: 'Pest',
    symptoms: {'stippling', 'webbing'},
    signs: 'Leaves look dusty and speckled; tiny moving dots under leaves.',
    remedies: [
      'Hose the undersides of leaves every few days; mites hate humidity.',
      _soapSpray,
      'Release predatory mites (Phytoseiulus), sold online in Australia.',
    ],
    prevention: ['Keep plants well watered and mulched in hot, dry weather.'],
  ),
  PlantProblem(
    name: 'Mealybugs',
    kind: 'Pest',
    symptoms: {'cotton', 'sticky'},
    signs: 'White waxy cotton blobs in leaf joints and on roots.',
    remedies: [
      'Dab each blob with a cotton bud dipped in methylated spirits.',
      _soapSpray,
      'Mealybug ladybirds (Cryptolaemus) eat them and can be bought online.',
    ],
    prevention: [
      'Check new plants before bringing them home.',
      'Control ants, which protect mealybugs.',
    ],
  ),
  PlantProblem(
    name: 'Whitefly',
    kind: 'Pest',
    symptoms: {'white_flies', 'sticky', 'yellow_lower'},
    signs: 'Clouds of tiny white moths fly up when leaves are touched.',
    remedies: ['Hang yellow sticky traps among the plants.', _soapSpray, _neem],
    prevention: [
      'Remove badly infested lower leaves.',
      'Plant nasturtiums or marigolds nearby as trap and companion plants.',
    ],
  ),
  PlantProblem(
    name: 'Scale insects',
    kind: 'Pest',
    symptoms: {'bumps', 'sticky'},
    signs: 'Small hard or waxy shells stuck to stems and leaf veins.',
    remedies: [
      'Scrape them off with a fingernail or soft toothbrush.',
      _whiteOil,
    ],
    prevention: ['Control ants, which farm scale for their honeydew.'],
  ),
  PlantProblem(
    name: 'Sooty mould',
    kind: 'Disease',
    symptoms: {'sticky'},
    signs:
        'Black coating that wipes off. It grows on honeydew from '
        'sap-sucking insects.',
    remedies: [
      'Treat the insects causing it (aphids, scale, mealybugs or whitefly).',
      'Wipe leaves with warm soapy water once the insects are gone.',
    ],
    prevention: ['Keep sap-sucking insects under control.'],
  ),
  PlantProblem(
    name: 'Thrips',
    kind: 'Pest',
    symptoms: {'silvery', 'curled'},
    signs: 'Silvery or bleached patches with tiny black dots of droppings.',
    remedies: ['Hang blue sticky traps.', 'Hose plants regularly.', _neem],
    prevention: ['Keep plants watered; thrips thrive on stressed plants.'],
  ),
  PlantProblem(
    name: 'Leaf miner',
    kind: 'Pest',
    symptoms: {'trails'},
    signs: 'Wandering pale tunnels inside leaves made by tiny larvae.',
    remedies: [
      'Pick off and bin affected leaves, or squash the larva in the tunnel.',
      _neem,
    ],
    prevention: ['Cover young plants with fine insect netting.'],
  ),
  PlantProblem(
    name: 'Fungal leaf spot',
    kind: 'Disease',
    symptoms: {'spots', 'yellow_lower'},
    signs:
        'Brown or black spots, often with a yellow ring, spreading from '
        'lower leaves.',
    remedies: [
      'Remove spotted leaves and bin them.',
      'Bicarb spray: 1 teaspoon bicarbonate of soda and a few drops of oil '
          'per litre of water, weekly.',
    ],
    prevention: [
      'Mulch to stop soil splashing onto leaves.',
      'Water at the base in the morning.',
    ],
  ),
  PlantProblem(
    name: 'Rust (common on mint)',
    kind: 'Disease',
    symptoms: {'rust', 'spots'},
    signs: 'Orange powdery pustules under leaves, yellow spots on top.',
    remedies: [
      'Cut affected stems right back; mint can be cut to the ground and '
          'will regrow clean.',
      'Bin the cuttings rather than composting them.',
    ],
    prevention: [
      'Keep leaves dry and give plants space.',
      'Grow mint in its own pot with fresh mix every year or two.',
    ],
  ),
  PlantProblem(
    name: 'Grey mould (Botrytis)',
    kind: 'Disease',
    symptoms: {'grey_mould'},
    signs:
        'Grey fuzzy growth on flowers, fruit or soft leaves in damp '
        'weather.',
    remedies: [
      'Remove all affected parts straight away and bin them.',
      'Improve airflow by thinning crowded growth.',
    ],
    prevention: ['Avoid overhead watering and overcrowding.'],
  ),
  PlantProblem(
    name: 'Overwatering or root rot',
    kind: 'Growing problem',
    symptoms: {'wilting_wet', 'yellow_lower', 'soil_flies'},
    signs: 'Plant droops although the soil is damp; roots brown and mushy.',
    remedies: [
      'Let the soil dry out before watering again.',
      'Repot into free-draining mix and trim off any mushy roots.',
    ],
    prevention: [
      'Use pots with drainage holes and do not leave them in saucers of water.',
      'Mediterranean herbs (rosemary, thyme, sage, oregano) like to dry out '
          'between waterings.',
    ],
  ),
  PlantProblem(
    name: 'Nitrogen deficiency',
    kind: 'Growing problem',
    symptoms: {'yellow_lower'},
    signs: 'Even yellowing of older leaves first, with slow pale growth.',
    remedies: [
      'Feed with worm tea, fish emulsion or a seaweed and fish blend.',
      'Dig in compost or a little blood and bone.',
    ],
    prevention: ['Top up beds with compost each season.'],
  ),
  PlantProblem(
    name: 'Fungus gnats',
    kind: 'Pest',
    symptoms: {'soil_flies', 'seedlings_collapse'},
    signs: 'Small dark flies around pots; larvae live in wet potting mix.',
    remedies: [
      'Let the top few centimetres of mix dry between waterings.',
      'Yellow sticky traps for the adults.',
      'Cover the mix with a layer of coarse sand or grit.',
    ],
    prevention: ['Do not overwater indoor and seedling pots.'],
  ),
  PlantProblem(
    name: 'Damping off',
    kind: 'Disease',
    symptoms: {'seedlings_collapse'},
    signs: 'Seedlings pinch at the base and fall over.',
    remedies: [
      'Remove collapsed seedlings and the mix around them.',
      'Let the surface dry between waterings and improve airflow.',
    ],
    prevention: [
      'Use fresh seed-raising mix and clean trays.',
      'Water from below and avoid sowing too thickly.',
    ],
  ),
  PlantProblem(
    name: 'Root-knot nematodes',
    kind: 'Pest',
    symptoms: {'knobbly_roots', 'wilting_wet', 'yellow_lower'},
    signs:
        'Plants sulk and wilt; roots have swollen knots (common in sandy '
        'soils).',
    remedies: [
      'Pull out and bin infected plants, roots and all.',
      'Solarise the bed: water, cover with clear plastic for 4 to 6 weeks in '
          'summer.',
      'Grow French marigolds (Tagetes patula) densely for a season, then dig '
          'them in.',
    ],
    prevention: [
      'Add plenty of compost; healthy soil life suppresses nematodes.',
      'Rotate crops.',
    ],
  ),
];

/// Problems that match at least one selected symptom, best match first.
List<PlantProblem> matchProblems(Set<String> selected) {
  if (selected.isEmpty) return [];
  final scored = [
    for (final p in problems)
      (problem: p, score: p.symptoms.intersection(selected).length),
  ]..removeWhere((e) => e.score == 0);
  scored.sort((a, b) => b.score.compareTo(a.score));
  return [for (final e in scored) e.problem];
}
