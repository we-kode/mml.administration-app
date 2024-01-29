import 'dart:async';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';

/// An extended [MultipartFile]. Includes the file path.
class MultipartFileExtended extends MultipartFile {
  /// File path of the file to be uploaded.
  final String? filePath;

  MultipartFileExtended(
    Stream<List<int>> stream,
    length, {
    filename,
    this.filePath,
    contentType,
  }) : super.fromStream(() => stream, length, filename: filename, contentType: contentType);

  /// Create instance of [MultipartFileExtended] from file.
  static MultipartFileExtended fromFileSync(
    String filePath, {
    String? filename,
    MediaType? contentType,
  }) =>
      multipartFileFromPathSync(
        filePath,
        filename: filename,
        contentType: contentType,
      );
}

/// Creates a [MultipartFileExtended] from a file.
MultipartFileExtended multipartFileFromPathSync(
  String filePath, {
  String? filename,
  MediaType? contentType,
}) {
  filename ??= filePath.split(Platform.pathSeparator).last;
  var file = File(filePath);
  var length = file.lengthSync();
  var stream = file.openRead();
  return MultipartFileExtended(
    stream,
    length,
    filename: filename,
    contentType: contentType,
    filePath: filePath,
  );
}
