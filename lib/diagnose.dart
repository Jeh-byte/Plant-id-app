import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Supplied at build time with --dart-define=ANTHROPIC_API_KEY=...
const anthropicApiKey = String.fromEnvironment('ANTHROPIC_API_KEY');

const _systemPrompt = '''
You are a practical plant health adviser for a home gardener in Australia who
grows herbs, medicinal plants and edible weeds. Look at the photo and give a
short diagnosis in plain text (no markdown symbols), using these headings on
their own lines:

PLANT
Your best identification, noting the Pl@ntNet suggestion if given.

HEALTH
Healthy, or the most likely diseases, pests or deficiencies you can see, and
the visible signs that point to each. Say how sure you are. If the photo
cannot show enough, say what close-up would help.

NATURAL REMEDIES
Organic, home-garden treatments for each problem (for example pruning, hosing
off, neem or white oil, garlic or chilli spray, milk spray, companion planting,
beneficial insects, soil and watering changes), with how often to apply.

PREVENTION
Two or three habits that stop it coming back.

If the plant is a herb or medicinal plant, add one line on whether the
affected leaves are still safe to harvest. Keep it under 250 words.
''';

class DiagnoseException implements Exception {
  DiagnoseException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Asks Claude to diagnose diseases and pests in a plant photo.
class PlantDoctor {
  PlantDoctor({http.Client? client, this.apiKey = anthropicApiKey})
      : _client = client ?? http.Client();

  final http.Client _client;
  final String apiKey;

  bool get hasKey => apiKey.isNotEmpty;

  Future<String> diagnose(String imagePath, {String? plantNetGuess}) async {
    if (!hasKey) {
      throw DiagnoseException('No Anthropic API key in this build.');
    }
    final image = base64Encode(await File(imagePath).readAsBytes());
    final body = jsonEncode({
      'model': 'claude-opus-5-5',
      'max_tokens': 4000,
      'fallbacks': 'default',
      'system': _systemPrompt,
      'messages': [
        {
          'role': 'user',
          'content': [
            {
              'type': 'image',
              'source': {
                'type': 'base64',
                'media_type': 'image/jpeg',
                'data': image,
              },
            },
            {
              'type': 'text',
              'text': plantNetGuess == null
                  ? 'Diagnose this plant.'
                  : 'Pl@ntNet suggests: $plantNetGuess. Diagnose this plant.',
            },
          ],
        },
      ],
    });

    final response = await _client
        .post(
          Uri.https('api.anthropic.com', '/v1/messages'),
          headers: {
            'x-api-key': apiKey,
            'anthropic-version': '2023-06-01',
            'anthropic-beta': 'server-side-fallback-2026-07-01',
            'content-type': 'application/json',
          },
          body: body,
        )
        .timeout(const Duration(seconds: 120));

    if (response.statusCode != 200) {
      throw DiagnoseException(
          'Diagnosis failed (${response.statusCode}): ${response.body}');
    }
    final json = jsonDecode(utf8.decode(response.bodyBytes))
        as Map<String, dynamic>;
    if (json['stop_reason'] == 'refusal') {
      throw DiagnoseException('Claude declined to diagnose this photo.');
    }
    final text = (json['content'] as List)
        .where((b) => b['type'] == 'text')
        .map((b) => b['text'] as String)
        .join('\n')
        .trim();
    if (text.isEmpty) throw DiagnoseException('Empty diagnosis returned.');
    return text;
  }
}
