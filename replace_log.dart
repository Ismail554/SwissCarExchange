import 'dart:io';

void main() {
  final file = File('lib/controllers/auth/register_provider.dart');
  String content = file.readAsStringSync();

  content = content.replaceAll("import 'dart:developer';", "import 'package:flutter/foundation.dart';");
  
  content = content.replaceAllMapped(
    RegExp(r"log\('(.+?)',\s*name:\s*'REGISTER'\);"),
    (match) {
      final msg = match.group(1);
      return "debugPrint('REGISTER: $msg');";
    }
  );

  file.writeAsStringSync(content);
  print('Done replacing log with debugPrint.');
}
