import 'dart:io';
import 'dart:convert';

void main() {
  final dir = Directory('wallpapers/ai');
  if (!dir.existsSync()) return;

  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.jpg') || f.path.endsWith('.png'));

  for (var file in files) {
    final fileName = file.uri.pathSegments.last;
    final id = fileName.split('.').first;
    final jsonFile = File('${file.parent.path}/$id.json');

    if (!jsonFile.existsSync()) {
      final metadata = {
        'id': id,
        'title': 'AI Wallpaper',
        'category': 'ai',
        'author': 'Unknown',
        'source_url': '',
        'license': 'CC0',
        'resolution': 'Unknown',
        'tags': ['ai', 'generated']
      };

      jsonFile.writeAsStringSync(JsonEncoder.withIndent('  ').convert(metadata));
      print('Created metadata for $id');
    }
  }
}
