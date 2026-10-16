import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:plant_id_app/plantnet.dart';

void main() {
  late File image;

  setUp(() async {
    image = File('${Directory.systemTemp.createTempSync().path}/leaf.jpg')
      ..writeAsBytesSync([0xFF, 0xD8, 0xFF]);
  });

  test('parses Pl@ntNet matches', () async {
    final client = MockClient((request) async {
      expect(request.url.host, 'my-api.plantnet.org');
      expect(request.url.queryParameters['api-key'], 'test-key');
      return http.Response('''
        {"results": [{
          "score": 0.82,
          "species": {
            "scientificNameWithoutAuthor": "Sambucus nigra",
            "commonNames": ["Elder", "Black elder"],
            "family": {"scientificNameWithoutAuthor": "Adoxaceae"}
          }
        }]}''', 200);
    });

    final matches = await PlantNetClient(
      client: client,
      apiKey: 'test-key',
    ).identify([PlantPhoto(image.path)]);

    expect(matches, hasLength(1));
    expect(matches.first.scientificName, 'Sambucus nigra');
    expect(matches.first.commonNames, ['Elder', 'Black elder']);
    expect(matches.first.family, 'Adoxaceae');
    expect(matches.first.score, closeTo(0.82, 1e-9));
  });

  test('returns no matches when species is not found', () async {
    final client = MockClient(
      (_) async => http.Response('{"message":"Species not found"}', 404),
    );
    final matches = await PlantNetClient(
      client: client,
      apiKey: 'k',
    ).identify([PlantPhoto(image.path)]);
    expect(matches, isEmpty);
  });

  test('fails clearly without an API key', () {
    expect(
      PlantNetClient(apiKey: '').identify([PlantPhoto(image.path)]),
      throwsA(isA<PlantNetException>()),
    );
  });

  test('sends one organ per photo, in order', () async {
    final client = MockClient((request) async {
      final body = latin1.decode(request.bodyBytes);
      final leaf = body.indexOf('name="organs"');
      final flower = body.indexOf('name="organs"', leaf + 1);
      expect(body.indexOf('leaf', leaf), lessThan(flower));
      expect(body.indexOf('flower', flower), greaterThan(flower));
      expect('name="images"'.allMatches(body), hasLength(2));
      return http.Response('{"results": []}', 200);
    });
    await PlantNetClient(client: client, apiKey: 'k').identify([
      PlantPhoto(image.path, Organ.leaf),
      PlantPhoto(image.path, Organ.flower),
    ]);
  });
}
