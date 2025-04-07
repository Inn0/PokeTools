import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:poke_tools/models/nuzlocke_run.dart';

class NuzlockeRunRepository {
  static const String _fileName = 'nuzlocke_runs.json';

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<List<NuzlockeRun>> loadRuns() async {
    try {
      final file = await _getFile();
      if (!await file.exists()) return [];

      final content = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(content);

      return jsonList.map((e) => NuzlockeRun.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error loading runs: $e');
      return [];
    }
  }

  Future<void> saveRuns(List<NuzlockeRun> runs) async {
    try {
      final file = await _getFile();
      final jsonList = runs.map((run) => run.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
    } catch (e) {
      debugPrint('Error saving runs: $e');
    }
  }

  Future<void> saveRun(NuzlockeRun updatedRun) async {
    try {
      final runs = await loadRuns();

      final index = runs.indexWhere((run) => run.id == updatedRun.id);
      if (index != -1) {
        runs[index] = updatedRun;
        await saveRuns(runs);
      }
    } catch (e) {
      debugPrint('Error saving individual run: $e');
    }
  }
}
