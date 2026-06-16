import 'dart:io';

void main() {
  final dir = Directory('lib');
  final files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  final replacements = {
    r'Colors\.white': 'AppColors.white',
    r'Colors\.black87': 'AppColors.neutral',
    r'Colors\.black': 'AppColors.neutral',
    r'Colors\.grey\[200\]': 'AppColors.border',
    r'Colors\.grey\.shade200': 'AppColors.border',
    r'Colors\.grey\.shade300': 'AppColors.border',
    r'Colors\.grey\[300\]': 'AppColors.border',
    r'Colors\.grey\[600\]': 'AppColors.textSecondary',
    r'Colors\.grey\.shade600': 'AppColors.textSecondary',
    r'Colors\.grey\.shade800': 'AppColors.neutral',
    r'Colors\.grey': 'AppColors.textSecondary',
    r'Colors\.orange': 'AppColors.primary',
    r'Colors\.red': 'AppColors.error',
    r'Colors\.blue': 'AppColors.primary',
    r'Color\(0xFFF77F00\)': 'AppColors.primary',
    r'Color\(0xFFD30000\)': 'AppColors.error',
    r'Color\(0xFF003049\)': 'AppColors.secondary',
    r'Color\(0XFF006B5C\)': 'AppColors.tertiary',
    r'const Color\(0xFFF77F00\)': 'AppColors.primary',
    r'const Color\(0xFF003049\)': 'AppColors.secondary',
    r'const Color\(0XFF006B5C\)': 'AppColors.tertiary',
    r'const Color\(0xFFD30000\)': 'AppColors.error',
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
      if (!content.contains('core/theme/app_colors.dart')) {
        content = "import 'package:sesan_travel/core/theme/app_colors.dart';\n" + content;
      }
      file.writeAsStringSync(content);
      print('Updated: ${file.path}');
    }
  }
}
