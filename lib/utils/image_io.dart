// Ref - https://bezkoder.com/dart-base64-image/

import 'dart:io';
import 'dart:convert';

import 'dart:typed_data';

String readImageAsBase64Encode(File image) {
  final bytes = image.readAsBytesSync();
  return base64Encode(bytes);
}

Uint8List base64Decode(String source) => base64.decode(source);