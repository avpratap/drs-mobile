import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Stores queued proof-of-delivery photos in the app's private documents
/// directory until they are uploaded, then deletes them (DPDP: doorstep
/// photos are personal data; keep them no longer than needed).
class PodFiles {
  PodFiles({Future<Directory> Function()? baseDir})
    : _baseDir = baseDir ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _baseDir;

  Future<Directory> _dir() async {
    final d = Directory(p.join((await _baseDir()).path, 'pod'));
    if (!d.existsSync()) await d.create(recursive: true);
    return d;
  }

  /// Copies a captured photo into private storage under [id].
  Future<String> keep(String sourcePath, String id) async {
    final ext = p.extension(sourcePath).isEmpty
        ? '.jpg'
        : p.extension(sourcePath);
    final dest = p.join((await _dir()).path, '$id$ext');
    await File(sourcePath).copy(dest);
    return dest;
  }

  Future<void> discard(String? path) async {
    if (path == null) return;
    final f = File(path);
    if (f.existsSync()) await f.delete();
  }

  Future<void> discardAll() async {
    final d = await _dir();
    if (d.existsSync()) await d.delete(recursive: true);
  }
}
