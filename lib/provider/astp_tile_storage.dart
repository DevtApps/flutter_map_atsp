import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_map_astp/service/database_service.dart';
import 'package:path_provider/path_provider.dart';

class ASTPTileStorage {
  Directory? _dir;
  static final ASTPTileStorage _instance = ASTPTileStorage();
  static ASTPTileStorage get instance => _instance;

  init() async {
    await DatabaseService.instance.init();
    var documents = await getApplicationDocumentsDirectory();
    _dir = Directory("${documents.path}/tiles");
    if (!_dir!.existsSync()) _dir!.createSync();
  }

  Future<Uint8List> getTile(
      {String? domain = 'default', required String tileId}) {
    return File("${_dir!.path}/$domain/$tileId").readAsBytes();
  }

  Future putTile(
      {String? domain = "default",
      required Uint8List bytes,
      required String tileId}) async {
    var tile = File("${_dir!.path}/$domain/$tileId");
    DatabaseService.instance
        .insert(table: "tiles", values: {"tileId": tileId, "domain": domain});
    tile.create(recursive: true).then(
          (value) => tile.writeAsBytes(bytes),
        );
  }

  Future<bool> existsTile(
      {required String domain, required String tileId}) async {
    var tile = await DatabaseService.instance.select(
        table: "tiles",
        where: "tileId = ? and domain = ?",
        args: [tileId, domain]);
    log("$tileId ${tile.isNotEmpty ? 'Found' : 'Not Found'}",
        name: "TILE SEARCH");
    return tile.isNotEmpty;
  }
}
