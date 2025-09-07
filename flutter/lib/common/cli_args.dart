// Simple global storage for command-line arguments parsed at startup.
// Access from anywhere in Flutter code.

Map<String, dynamic> globalCommandLineArgs = {};

bool cliArgBool(String key, {bool defaultValue = false}) {
  final v = globalCommandLineArgs[key];
  if (v is bool) return v;
  return defaultValue;
}


