import 'dart:io';
import 'dart:convert';

void main() {
  final dir = Directory('Wallpapers/Ai Generated');
  if (!dir.existsSync()) {
    print('Directory not found');
    return;
  }

  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.jpg') || f.path.endsWith('.png'));

  for (var file in files) {
    final fileName = file.uri.pathSegments.last;
    final id = fileName.split('.').first;
    final jsonFile = File('${file.parent.path}/$id.json');

    if (!jsonFile.existsSync()) {
      final metadata = {
        'id': id,
        'title': 'AI Wallpaper',
        'category': 'Ai Generated',
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
