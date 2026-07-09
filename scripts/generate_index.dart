import 'dart:io';
import 'dart:convert';

void main() {
  final wallpapersDir = Directory('wallpapers');
  if (!wallpapersDir.existsSync()) {
    print('wallpapers directory not found');
    return;
  }

  final List<Map<String, dynamic>> allWallpapers = [];

  final categories = wallpapersDir.listSync().whereType<Directory>();
  for (var category in categories) {
    final categoryName = category.uri.pathSegments[category.uri.pathSegments.length - 2];
    
    final jsonFiles = category.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));
    for (var jsonFile in jsonFiles) {
      try {
        final content = jsonFile.readAsStringSync();
        final Map<String, dynamic> metadata = jsonDecode(content);
        metadata['url'] = 'https://raw.githubusercontent.com/Firebrick-Studio/magicwall-data/main/wallpapers/$categoryName/${metadata['id']}.jpg';
        allWallpapers.add(metadata);
      } catch (e) {
        print('Error reading ${jsonFile.path}: $e');
      }
    }
  }

  final indexFile = File('index.json');
  indexFile.writeAsStringSync(JsonEncoder.withIndent('  ').convert(allWallpapers));
  print('Generated index.json with ${allWallpapers.length} wallpapers.');
}
