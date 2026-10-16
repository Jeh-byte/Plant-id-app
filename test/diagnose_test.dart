import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:plant_id_app/diagnose.dart';

void main() {
  late File image;

  setUp(() {
    image = File('${Directory.systemTemp.createTempSync().path}/leaf.jpg')
      ..writeAsBytesSync([0xFF, 0xD8, 0xFF]);
  });

  test('sends the photo and returns the diagnosis text', () async {
    final client = MockClient((request) async {
      expect(request.url.toString(), 'https://api.anthropic.com/v1/messages');
      expect(request.headers['x-api-key'], 'test-key');
      final body = jsonDecode(request.body) as Map<String, dynamic>;
      expect(body['model'], 'claude-opus-5-5');
      final content = body['messages'][0]['content'] as List;
      expect(content[0]['type'], 'image');
      expect(content[1]['text'], contains('Sambucus nigra'));
      return http.Response(
          jsonEncode({
            'stop_reason': 'end_turn',
            'content': [
              {'type': 'text', 'text': 'PLANT\nElder\nHEALTH\nAphids'}
            ],
          }),
          200);
    });

    final text = await PlantDoctor(client: client, apiKey: 'test-key')
        .diagnose(image.path, plantNetGuess: 'Sambucus nigra (82%)');

    expect(text, contains('Aphids'));
  });

  test('reports API errors', () {
    final client =
        MockClient((_) async => http.Response('{"error":"bad key"}', 401));
    expect(
      PlantDoctor(client: client, apiKey: 'k').diagnose(image.path),
      throwsA(isA<DiagnoseException>()),
    );
  });
}
