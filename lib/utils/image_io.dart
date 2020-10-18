// Ref - https://bezkoder.com/dart-base64-image/

import 'dart:io';
import 'dart:convert';

import 'dart:typed_data';

// Convert image to base64 string
String readImageAsBase64Encode(File image) {
  final bytes = image.readAsBytesSync();
  return base64Encode(bytes);
}

// Convert base64 string to image
Uint8List base64Decode(String source) => base64.decode(source);