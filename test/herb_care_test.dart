import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_id_app/herb_care_data.dart';
import 'package:plant_id_app/main.dart';

void main() {
  test('matches Pl@ntNet names to herb cards on genus and species', () {
    expect(herbCardFor('Ocimum basilicum L.')?.name, 'Basil');
    expect(herbCardFor('centella asiatica')?.name, contains('Gotu kola'));
    expect(herbCardFor('Sambucus nigra'), isNull);
  });

  testWidgets('herb care cards open from the home screen', (tester) async {
    await tester.pumpWidget(const PlantIdApp());
    await tester.tap(find.byKey(const Key('herbCareButton')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'rosemary');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rosemary'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Hates wet feet'), findsOneWidget);
  });
}
