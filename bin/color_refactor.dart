import 'dart:io';

// Exact mapping of literal hex values to descriptive, premium AppColors names
const hexToNameMap = {
  '1E140C': 'sceDarkBrownBg',
  '2A1B0D': 'sceBrownBg',
  '005662': 'sceTealDark',
  'FFB300': 'sceOrangeLight',
  'E65100': 'sceOrangeDark',
  '4A5568': 'sceSlateGrey',
  '0F1B1A': 'sceDarkTealBg',
  'D4A843': 'sceGoldNotification',
  '64B5F6': 'sceBlueNotification',
  'FF9800': 'sceOrange',
  'E53935': 'sceRed',
  '1E1E2E': 'sceDarkPurpleBg',
  'B0B0C3': 'sceMutedGrey',
  '7C7C9A': 'sceMutedBlueGrey',
  '7C6FF7': 'sceIndigo',
  '4CAF50': 'sceGreen',
  '4F46E5': 'scePurple',
  '2E9CCA': 'sceCyan',
  '1976D2': 'sceBlue',
  '99A1AF': 'sceGrey99', // Maps to existing
  'A0AABF': 'sceGreyA0', // Maps to existing
  '0A0A0A': 'sceDarkBg', // Maps to existing
};

// Existing variables in AppColors (mapped to avoid duplicate additions)
const existingColors = {
  'sceGrey99': '0xFF99A1AF',
  'sceGreyA0': '0xFFA0AABF',
  'sceDarkBg': '0xFF0A0A0A',
  'sceTeal': '0xFF00D5BE',
  'sceGold': '0xFFF59E0B',
  'primaryColor': '0xFF181818',
  'white': '0xFFFFFFFF',
  'black': '0xFF000000',
  'darkGrey': '0xFF1F2937',
  'grey': '0xFF848484',
  'warning': '0xFFFDC300',
  'errorRed': '0xFFEF4444',
  'error': '0xFFFF0040',
  'success': '0xFF28A745',
};

void main() async {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('Error: lib directory not found.');
    return;
  }

  final appColorsFile = File('lib/app_utils/utils/app_colors.dart');
  if (!appColorsFile.existsSync()) {
    print('Error: lib/app_utils/utils/app_colors.dart not found.');
    return;
  }

  var appColorsContent = appColorsFile.readAsStringSync();

  // Find all hex color literals in Dart files recursively (excluding app_colors.dart)
  final dartFiles = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where(
        (f) => f.path.endsWith('.dart') && !f.path.contains('app_colors.dart'),
      )
      .toList();

  final colorRegex = RegExp(r'(const\s+)?Color\(0x([a-fA-F0-9]{8})\)');
  final Map<String, String> resolvedHexToVar = {};

  // First pass: scan files and determine variable name mappings
  for (final file in dartFiles) {
    final content = file.readAsStringSync();
    for (final match in colorRegex.allMatches(content)) {
      final fullHex = match.group(2)!.toUpperCase(); // e.g. FF1E140C
      final rgbHex = fullHex.substring(2); // e.g. 1E140C

      // Check if already mapped
      if (resolvedHexToVar.containsKey(fullHex)) continue;

      // Check if exact hex matches an existing name in existingColors
      String? foundName;
      existingColors.forEach((name, hexVal) {
        if (hexVal.substring(2).toUpperCase() == rgbHex) {
          foundName = name;
        }
      });

      if (foundName != null) {
        resolvedHexToVar[fullHex] = foundName!;
        continue;
      }

      // Check hexToNameMap
      if (hexToNameMap.containsKey(rgbHex)) {
        resolvedHexToVar[fullHex] = hexToNameMap[rgbHex]!;
      } else {
        // Fallback to generated name based on hex
        resolvedHexToVar[fullHex] = 'sceHex$rgbHex';
      }
    }
  }

  // Second pass: add missing variables to app_colors.dart
  final List<String> newDeclarations = [];
  resolvedHexToVar.forEach((fullHex, varName) {
    // If it's already in app_colors.dart variable definitions, skip adding
    if (appColorsContent.contains('static const Color $varName =') ||
        appColorsContent.contains('static const Color $varName=')) {
      return;
    }

    // Prepare declaration
    newDeclarations.add('  static const Color $varName = Color(0x$fullHex);');
  });

  if (newDeclarations.isNotEmpty) {
    final insertionIndex = appColorsContent.lastIndexOf('}');
    if (insertionIndex != -1) {
      final buffer = StringBuffer();
      buffer.write(appColorsContent.substring(0, insertionIndex));
      buffer.writeln(
        '\n  /* ==================== Automatically Extracted Colors ==================== */',
      );
      for (final dec in newDeclarations) {
        buffer.writeln(dec);
      }
      buffer.write('}');
      appColorsContent = buffer.toString();
      appColorsFile.writeAsStringSync(appColorsContent);
      print('Added ${newDeclarations.length} new colors to app_colors.dart');
    }
  }

  // Third pass: replace all literals in files and add imports if needed
  var totalReplacements = 0;
  for (final file in dartFiles) {
    var content = file.readAsStringSync();
    var fileModified = false;

    final matches = colorRegex.allMatches(content).toList();
    if (matches.isEmpty) continue;

    // We replace backwards to preserve string indices
    for (final match in matches.reversed) {
      final fullMatch = match.group(0)!;
      final fullHex = match.group(2)!.toUpperCase();
      final varName = resolvedHexToVar[fullHex];

      if (varName != null) {
        content = content.replaceRange(
          match.start,
          match.end,
          'AppColors.$varName',
        );
        fileModified = true;
        totalReplacements++;
      }
    }

    if (fileModified) {
      // Ensure import is present
      const importString =
          "import 'package:rionydo/app_utils/utils/app_colors.dart';";
      if (!content.contains("app_colors.dart'")) {
        // Find first import and insert it right before or after
        final firstImportIndex = content.indexOf('import ');
        if (firstImportIndex != -1) {
          content = content.insert(firstImportIndex, '$importString\n');
        } else {
          content = '$importString\n$content';
        }
      }
      file.writeAsStringSync(content);
      print('Updated colors in: ${file.path}');
    }
  }

  print('Done! Made $totalReplacements replacements.');
}

extension InsertString on String {
  String insert(int index, String other) {
    return substring(0, index) + other + substring(index);
  }
}
