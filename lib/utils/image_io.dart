import 'dart:io';
import 'dart:convert';

String readImageAsBase64Encode(File image) {
  final bytes = image.readAsBytesSync();
  return base64Encode(bytes);
}