import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart' show Left, Right, Either;
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:client/core/failure/failure.dart';
import 'package:client/core/constants/server_constants.dart';

part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> uploadSong({
    required String songName,
    required String artist,
    required String hexCode,
    required File songFile,
    required File thumbnailFile,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstants.serverUrl}/song/upload'),
      );

      request
        ..files.addAll([
          await http.MultipartFile.fromPath(
            'songFile',
            songFile.path,
            contentType: MediaType('audio', 'mpeg'),
          ),
          await http.MultipartFile.fromPath(
            'thumbnailFile',
            thumbnailFile.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        ])
        ..fields.addAll({
          'songName': songName,
          'artist': artist,
          'hexCode': hexCode,
        })
        ..headers.addAll({'Authorization': 'Bearer $token'});

      final response = await request.send();

      if (response.statusCode != 201) {
        return Left(AppFailure(await response.stream.bytesToString()));
      }

      return Right(await response.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
