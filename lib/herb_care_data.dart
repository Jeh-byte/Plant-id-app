/// Offline care cards for common culinary and medicinal herbs, with tips for
/// subtropical south-east Queensland gardens.
library;

class HerbCard {
  const HerbCard({
    required this.name,
    required this.scientificName,
    required this.sun,
    required this.water,
    required this.soil,
    required this.tips,
    this.uses,
  });

  final String name;

  /// Genus and species, used to link Pl@ntNet matches to a card.
  final String scientificName;
  final String sun;
  final String water;
  final String soil;
  final List<String> tips;

  /// Traditional culinary or medicinal uses (general information only).
  final String? uses;
}

const herbCards = [
  HerbCard(
    name: 'Basil',
    scientificName: 'Ocimum basilicum',
    sun: 'Full sun to light afternoon shade.',
    water: 'Keep evenly moist; do not let it dry out in summer.',
    soil: 'Rich, free-draining soil with compost.',
    tips: [
      'Pinch out flower spikes to keep leaves coming.',
      'An annual in Qld: sow from spring to late summer.',
    ],
    uses: 'Culinary; traditionally used for digestion.',
  ),
  HerbCard(
    name: 'Holy basil (tulsi)',
    scientificName: 'Ocimum tenuiflorum',
    sun: 'Full sun.',
    water: 'Moderate; let the top of the soil dry between waterings.',
    soil: 'Free-draining, moderately rich.',
    tips: [
      'Short-lived perennial in warm areas; trim after flowering.',
      'Cut back by a third in late winter to refresh it.',
    ],
    uses: 'Ayurvedic herb, often taken as a tea for stress and colds.',
  ),
  HerbCard(
    name: 'Parsley',
    scientificName: 'Petroselinum crispum',
    sun: 'Full sun to part shade (part shade in summer).',
    water: 'Regular, even moisture.',
    soil: 'Rich, moist, well-drained.',
    tips: [
      'Best sown in autumn and winter in Qld; bolts in summer heat.',
      'Harvest outer stems first.',
    ],
    uses: 'Culinary; rich in vitamin C.',
  ),
  HerbCard(
    name: 'Coriander',
    scientificName: 'Coriandrum sativum',
    sun: 'Full sun in cool months, afternoon shade otherwise.',
    water: 'Keep moist; dry soil makes it bolt.',
    soil: 'Light, well-drained.',
    tips: [
      'Sow every few weeks from March to August in Qld.',
      'Let some go to seed for coriander seed and self-sown plants.',
    ],
    uses: 'Culinary leaves, roots and seeds; seeds used for digestion.',
  ),
  HerbCard(
    name: 'Vietnamese mint',
    scientificName: 'Persicaria odorata',
    sun: 'Part shade.',
    water: 'Loves wet feet; keep constantly moist.',
    soil: 'Rich, moist soil; grows well in a pot in a saucer.',
    tips: [
      'Very easy in Qld; cut back hard if leggy.',
      'Grow in a pot, as it spreads.',
    ],
    uses: 'Culinary (laksa, salads).',
  ),
  HerbCard(
    name: 'Mint',
    scientificName: 'Mentha spicata',
    sun: 'Part shade.',
    water: 'Keep moist.',
    soil: 'Rich, moist.',
    tips: [
      'Always grow in a pot; it spreads by runners.',
      'If rust appears, cut to the ground and bin the cuttings.',
    ],
    uses: 'Culinary and teas; peppermint is used for digestion.',
  ),
  HerbCard(
    name: 'Rosemary',
    scientificName: 'Salvia rosmarinus',
    sun: 'Full sun.',
    water: 'Low; water deeply but rarely once established.',
    soil: 'Sandy, very free-draining. Hates wet feet.',
    tips: [
      'Most rosemary losses are from overwatering or humid, soggy soil.',
      'Prune lightly after flowering.',
    ],
    uses: 'Culinary; traditionally used for memory and circulation.',
  ),
  HerbCard(
    name: 'Thyme',
    scientificName: 'Thymus vulgaris',
    sun: 'Full sun.',
    water: 'Low; let it dry out between waterings.',
    soil: 'Gritty, free-draining, slightly alkaline.',
    tips: [
      'Struggles in humid Qld summers; give it airflow and a raised spot.',
      'Trim after flowering to stop it going woody.',
    ],
    uses: 'Culinary; thyme tea traditionally used for coughs.',
  ),
  HerbCard(
    name: 'Sage',
    scientificName: 'Salvia officinalis',
    sun: 'Full sun.',
    water: 'Low to moderate.',
    soil: 'Free-draining.',
    tips: [
      'Prone to rot in wet summers; keep it on the dry side.',
      'Replace every few years when woody.',
    ],
    uses: 'Culinary; sage tea traditionally used as a sore-throat gargle.',
  ),
  HerbCard(
    name: 'Oregano',
    scientificName: 'Origanum vulgare',
    sun: 'Full sun.',
    water: 'Low to moderate.',
    soil: 'Free-draining, not too rich.',
    tips: [
      'Flavour is strongest in poorer soil and full sun.',
      'Cut back after flowering.',
    ],
    uses: 'Culinary.',
  ),
  HerbCard(
    name: 'Chives',
    scientificName: 'Allium schoenoprasum',
    sun: 'Full sun to part shade.',
    water: 'Regular.',
    soil: 'Rich, moist, well-drained.',
    tips: [
      'Cut to 5 cm above the ground; it regrows.',
      'Divide clumps every couple of years.',
    ],
    uses: 'Culinary.',
  ),
  HerbCard(
    name: 'Lemongrass',
    scientificName: 'Cymbopogon citratus',
    sun: 'Full sun.',
    water: 'Regular in summer, less in winter.',
    soil: 'Rich, moist, well-drained.',
    tips: [
      'Cut the whole clump back to 20 cm in late winter.',
      'Harvest stems from the outside of the clump.',
    ],
    uses: 'Culinary and teas.',
  ),
  HerbCard(
    name: 'Lemon balm',
    scientificName: 'Melissa officinalis',
    sun: 'Part shade.',
    water: 'Moderate.',
    soil: 'Moist, well-drained.',
    tips: [
      'Self-seeds readily; trim before seed sets.',
      'Grow in a pot to contain it.',
    ],
    uses: 'Calming tea, traditionally used for sleep and nerves.',
  ),
  HerbCard(
    name: 'Gotu kola (brahmi of Ayurveda)',
    scientificName: 'Centella asiatica',
    sun: 'Part shade.',
    water: 'Keep consistently moist; tolerates boggy soil.',
    soil: 'Rich and moist.',
    tips: [
      'Spreads by runners; great as a ground cover in damp spots.',
      'Harvest a few leaves at a time.',
    ],
    uses: 'Traditionally eaten fresh for memory and skin healing.',
  ),
  HerbCard(
    name: 'Comfrey',
    scientificName: 'Symphytum officinale',
    sun: 'Full sun to part shade.',
    water: 'Moderate.',
    soil: 'Deep, rich soil.',
    tips: [
      'Very hard to remove once planted; even root pieces regrow.',
      'Cut leaves for mulch, compost or liquid fertiliser.',
    ],
    uses:
        'External use only (poultices for bruises and sprains). '
        'Do not eat; it contains liver-toxic alkaloids.',
  ),
  HerbCard(
    name: 'Calendula',
    scientificName: 'Calendula officinalis',
    sun: 'Full sun.',
    water: 'Moderate.',
    soil: 'Most well-drained soils.',
    tips: [
      'A cool-season annual in Qld: sow in autumn.',
      'Deadhead to keep it flowering; petals attract beneficial insects.',
    ],
    uses: 'Petals used in skin salves and as an edible garnish.',
  ),
  HerbCard(
    name: 'German chamomile',
    scientificName: 'Matricaria chamomilla',
    sun: 'Full sun.',
    water: 'Moderate.',
    soil: 'Light, well-drained.',
    tips: [
      'Sow in autumn in Qld; finishes as it warms up.',
      'Pick flowers when fully open and dry them for tea.',
    ],
    uses: 'Calming tea for sleep and digestion.',
  ),
  HerbCard(
    name: 'Aloe vera',
    scientificName: 'Aloe vera',
    sun: 'Full sun to bright shade.',
    water: 'Low; water only when the soil is dry.',
    soil: 'Cactus or gritty, free-draining mix.',
    tips: [
      'Rot from overwatering is the main problem.',
      'Remove pups to make new plants.',
    ],
    uses: 'Leaf gel used on minor burns and sunburn (external use).',
  ),
  HerbCard(
    name: 'Yarrow',
    scientificName: 'Achillea millefolium',
    sun: 'Full sun.',
    water: 'Low once established.',
    soil: 'Most soils, well-drained.',
    tips: [
      'Spreads into a mat; divide every few years.',
      'Great for attracting hoverflies and ladybirds.',
    ],
    uses: 'Traditionally used on minor cuts and in teas for colds.',
  ),
  HerbCard(
    name: 'Turmeric',
    scientificName: 'Curcuma longa',
    sun: 'Part shade.',
    water: 'Keep moist in the growing season, dry in winter dormancy.',
    soil: 'Rich, moist, well-drained.',
    tips: [
      'Plant rhizomes in spring; harvest in winter when leaves die back.',
      'Thrives in Qld humidity.',
    ],
    uses: 'Culinary and traditional anti-inflammatory.',
  ),
  HerbCard(
    name: 'Ginger',
    scientificName: 'Zingiber officinale',
    sun: 'Part shade.',
    water: 'Moist in summer, drier in winter.',
    soil: 'Rich, moist, well-drained.',
    tips: [
      'Plant in spring; harvest from late autumn when leaves yellow.',
      'Keep a few rhizomes to replant.',
    ],
    uses: 'Culinary and traditional remedy for nausea.',
  ),
  HerbCard(
    name: 'Toothache plant (spilanthes)',
    scientificName: 'Acmella oleracea',
    sun: 'Full sun to part shade.',
    water: 'Keep moist.',
    soil: 'Rich, well-drained.',
    tips: [
      'Short-lived; let some flowers set seed.',
      'Easy in warm months in Qld.',
    ],
    uses: 'Flower buds numb the mouth; traditionally used for toothache.',
  ),
  HerbCard(
    name: 'Stevia',
    scientificName: 'Stevia rebaudiana',
    sun: 'Full sun.',
    water: 'Moderate; do not let it sit wet.',
    soil: 'Light, free-draining.',
    tips: [
      'Cut back hard in late winter.',
      'Leaves are sweetest just before flowering.',
    ],
    uses: 'Natural sweetener.',
  ),
  HerbCard(
    name: 'Lavender',
    scientificName: 'Lavandula dentata',
    sun: 'Full sun.',
    water: 'Low.',
    soil: 'Gritty, free-draining, slightly alkaline.',
    tips: [
      'French (dentata) and Spanish types cope best with Qld humidity.',
      'Prune lightly after flowering, never into old wood.',
    ],
    uses: 'Calming scent; flowers used in teas and baking.',
  ),
  HerbCard(
    name: 'Dill',
    scientificName: 'Anethum graveolens',
    sun: 'Full sun.',
    water: 'Regular.',
    soil: 'Light, well-drained.',
    tips: [
      'Sow in autumn in Qld; does not transplant well.',
      'Flowers attract beneficial insects.',
    ],
    uses: 'Culinary; seeds traditionally used for wind and colic.',
  ),
];

/// The care card for a Pl@ntNet match, matched on genus and species.
HerbCard? herbCardFor(String scientificName) {
  String key(String name) =>
      name.toLowerCase().split(RegExp(r'\s+')).take(2).join(' ');
  final wanted = key(scientificName);
  for (final card in herbCards) {
    if (key(card.scientificName) == wanted) return card;
  }
  return null;
}
