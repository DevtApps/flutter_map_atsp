import 'dart:async';
import 'dart:developer';
import 'dart:ui';


import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart';

import 'astp_tile_storage.dart';

class ASTPImageProvider extends ImageProvider<ASTPImageProvider> {


  String tileId;
  String? domain;
  String url;

  ASTPImageProvider({required this.url, required this.tileId, this.domain});

  @override
  Future<ASTPImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<ASTPImageProvider>(this);
  }

  @override
  ImageStreamCompleter loadImage(
      ASTPImageProvider key, ImageDecoderCallback decode) {

     final StreamController<ImageChunkEvent> chunkEvents =
        StreamController<ImageChunkEvent>();

    return MultiFrameImageStreamCompleter(
      codec: _computeTileImage(key: key, decode: decode, chunkEvents: chunkEvents, tileId: tileId),
      chunkEvents: chunkEvents.stream,
      scale: 1,
      debugLabel: tileId,
      informationCollector: () => [DiagnosticsProperty('tileId', tileId)],
    );
   
  }
  
  Future<Codec> _computeTileImage({required ASTPImageProvider key, required ImageDecoderCallback decode, required StreamController<ImageChunkEvent> chunkEvents, required String tileId})async {

    Uint8List bytes = Uint8List.fromList([]);

    if(await ASTPTileStorage.instance.existsTile(tileId: tileId, domain: Uri.parse(url).host)){
      bytes = await ASTPTileStorage.instance.getTile(tileId:tileId, domain: domain);
     
    }else{

      Response response = await get(Uri.parse(url));
     
      if(response.statusCode == 200){
        
         bytes = response.bodyBytes;
         ASTPTileStorage.instance.putTile(bytes:bytes, tileId: tileId, domain: domain);
    
      }else{
        throw new Exception("Não foi possível encontrar o tile");
      }
    }

    return await decode(await ImmutableBuffer.fromUint8List(bytes));
  }



  
}
