import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_id_app/main.dart';
import 'package:plant_id_app/pest_guide_data.dart';

void main() {
  test('every problem uses only known symptoms', () {
    final ids = {for (final s in symptoms) s.id};
    for (final p in problems) {
      expect(ids.containsAll(p.symptoms), isTrue, reason: p.name);
    }
  });

  test('best-matching problem comes first', () {
    final matches = matchProblems({'clusters', 'curled', 'sticky'});
    expect(matches.first.name, 'Aphids');
    expect(matchProblems({}), isEmpty);
  });

  testWidgets('picking a symptom shows remedies', (tester) async {
    tester.view.physicalSize = const Size(1080, 4000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const PlantIdApp());
    await tester.tap(find.byKey(const Key('pestGuideButton')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('White powder on leaves'));
    await tester.pumpAndSettle();
    expect(find.text('Powdery mildew'), findsOneWidget);

    await tester.tap(find.text('Powdery mildew'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Milk spray'), findsOneWidget);
  });
}
