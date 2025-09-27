import 'dart:convert';
import 'dart:typed_data';

Uint8List base64FromDataUri(String dataUri) {
  final base64Str = dataUri.contains(',') ? dataUri.split(',')[1] : dataUri;
  return base64Decode(base64Str);
}
