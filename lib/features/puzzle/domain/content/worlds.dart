class WorldDefinition {
  const WorldDefinition({
    required this.id,
    required this.titleKey,
    required this.order,
  });

  final String id;
  final String titleKey;
  final int order;
}

const worlds = [
  WorldDefinition(id: 'basic_patterns', titleKey: 'worldBasicPatterns', order: 1),
  WorldDefinition(id: 'modular_rules', titleKey: 'worldModularRules', order: 2),
  WorldDefinition(id: 'number_groups', titleKey: 'worldNumberGroups', order: 3),
  WorldDefinition(id: 'prime_logic', titleKey: 'worldPrimeLogic', order: 4),
  WorldDefinition(
    id: 'forty_two_symmetry',
    titleKey: 'worldFortyTwoSymmetry',
    order: 5,
  ),
  WorldDefinition(id: 'meta_rules', titleKey: 'worldMetaRules', order: 6),
];

const int puzzlesPerWorldDesign = 40;
const int totalPuzzlesDesign = 240;
