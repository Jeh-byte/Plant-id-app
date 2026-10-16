import 'package:flutter_test/flutter_test.dart';
import 'package:plant_id_app/main.dart';

void main() {
  testWidgets('Home screen shows the camera button', (tester) async {
    await tester.pumpWidget(const PlantIdApp());

    expect(find.text('Plant ID'), findsOneWidget);
    expect(find.text('Take photo'), findsOneWidget);
    expect(find.text('Gallery'), findsOneWidget);
  });
}
