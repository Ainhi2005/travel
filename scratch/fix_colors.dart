import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  final replacements = {
    r'const AppColors\.': 'AppColors.', // Fix const AppColors.something
    r'AppAppColors\.': 'AppColors.', // Fix AppAppColors
    r'AppColors\.textSecondary\.shade\d+': 'AppColors.textSecondary', // Fix shade on Color
    r'AppColors\.border\.shade\d+': 'AppColors.border', // Fix shade on Color
    r'AppColors\.neutral54': 'AppColors.textSecondary', // Fix neutral54
    r'Colors\.grey\.shade500': 'AppColors.textSecondary',
    r'Colors\.grey\.shade50': 'AppColors.background',
    r'Colors\.grey\.shade700': 'AppColors.textSecondary',
    r'Colors\.grey\.shade400': 'AppColors.textSecondary',
    r'Colors\.black54': 'AppColors.textSecondary',
  };

  for (final file in files) {
    if (file.path.contains('app_colors.dart')) continue;

    String content = file.readAsStringSync();
    bool changed = false;

    for (final entry in replacements.entries) {
      if (RegExp(entry.key).hasMatch(content)) {
        content = content.replaceAll(RegExp(entry.key), entry.value);
        changed = true;
      }
    }

    if (changed) {
      file.writeAsStringSync(content);
      print('Fixed: ${file.path}');
    }
  }
}
