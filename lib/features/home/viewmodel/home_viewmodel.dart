import 'dart:io';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' show Left, Right;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/home/repositories/home_repository.dart';

part 'home_viewmodel.g.dart';

@riverpod
class HomeViewmodel extends _$HomeViewmodel {
  late HomeRepository _homeRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }

  Future<void> uploadSong({
    required File song,
    required File thumbnail,
    required String songName,
    required String artist,
    required Color color,
  }) async {
    state = const AsyncValue.loading();

    final response = await _homeRepository.uploadSong(
      songFile: song,
      thumbnailFile: thumbnail,
      songName: songName,
      artist: artist,
      hexCode: color.hex,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (response) {
      Left(value: final l) => AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => AsyncValue.data(r),
    };

    print('Upload song response: $val');
  }
}
