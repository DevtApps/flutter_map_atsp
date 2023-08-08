import 'dart:io';


import 'package:flutter/src/painting/image_provider.dart';
import 'package:flutter_map/plugin_api.dart';

import 'package:path_provider/path_provider.dart';

import 'astp_image_provider.dart';

class ASTPTileProvider extends TileProvider {

  bool useDomain;

  ASTPTileProvider({this.useDomain = true});

  @override
  ImageProvider<Object> getImage(
      TileCoordinates coordinates, TileLayer options) {
    var imageId = "${coordinates.x}-${coordinates.y}-${coordinates.z}.png";

    var domain = Uri.parse(getTileUrl(coordinates, options));

    return ASTPImageProvider(
      domain: useDomain? domain.host: null,
      url: getTileUrl(coordinates, options),
      tileId: imageId
    );
  }

  Future<Directory?> get directory async => await getExternalStorageDirectory();
}
