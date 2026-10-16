import 'dart:convert';

import 'package:http/http.dart' as http;

/// Supplied at build time with --dart-define=PLANTNET_API_KEY=...
const plantNetApiKey = String.fromEnvironment('PLANTNET_API_KEY');

class PlantMatch {
  PlantMatch({
    required this.scientificName,
    required this.commonNames,
    required this.family,
    required this.score,
  });

  final String scientificName;
  final List<String> commonNames;
  final String family;
  final double score;

  factory PlantMatch.fromJson(Map<String, dynamic> json) {
    final species = json['species'] as Map<String, dynamic>;
    return PlantMatch(
      scientificName: species['scientificNameWithoutAuthor'] as String? ?? '',
      commonNames: (species['commonNames'] as List?)?.cast<String>() ?? [],
      family:
          (species['family'] as Map?)?['scientificNameWithoutAuthor']
              as String? ??
          '',
      score: (json['score'] as num).toDouble(),
    );
  }
}

const maxPhotos = 5;

/// The part of the plant a photo shows. Telling Pl@ntNet improves accuracy.
enum Organ {
  auto('Not sure', 'auto'),
  leaf('Leaf', 'leaf'),
  flower('Flower', 'flower'),
  fruit('Fruit', 'fruit'),
  bark('Bark', 'bark'),
  habit('Whole plant', 'habit');

  const Organ(this.label, this.apiValue);
  final String label;
  final String apiValue;
}

class PlantPhoto {
  PlantPhoto(this.path, [this.organ = Organ.auto]);
  final String path;
  Organ organ;
}

class PlantNetException implements Exception {
  PlantNetException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Identifies a plant from one photo using the Pl@ntNet API.
class PlantNetClient {
  PlantNetClient({http.Client? client, this.apiKey = plantNetApiKey})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String apiKey;

  bool get hasKey => apiKey.isNotEmpty;

  /// Identifies a plant from up to 5 photos of the same plant, each tagged
  /// with the organ it shows.
  Future<List<PlantMatch>> identify(List<PlantPhoto> photos) async {
    if (!hasKey) {
      throw PlantNetException('No Pl@ntNet API key in this build.');
    }
    if (photos.isEmpty || photos.length > maxPhotos) {
      throw PlantNetException('Use between 1 and $maxPhotos photos.');
    }
    final uri = Uri.https('my-api.plantnet.org', '/v2/identify/all', {
      'api-key': apiKey,
      'lang': 'en',
      'nb-results': '5',
      'include-related-images': 'false',
    });
    final request = http.MultipartRequest('POST', uri);
    for (final photo in photos) {
      request.files
        ..add(await http.MultipartFile.fromPath('images', photo.path))
        // One "organs" value per image, in the same order.
        ..add(http.MultipartFile.fromString('organs', photo.organ.apiValue));
    }

    final response = await http.Response.fromStream(await _client.send(request))
        .timeout(const Duration(seconds: 30));

    if (response.statusCode == 404) return [];
    if (response.statusCode != 200) {
      throw PlantNetException(
        'Pl@ntNet error ${response.statusCode}: ${response.body}',
      );
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    return (body['results'] as List)
        .map((r) => PlantMatch.fromJson(r as Map<String, dynamic>))
        .toList();
  }
}
