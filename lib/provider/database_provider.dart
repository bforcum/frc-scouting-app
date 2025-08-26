import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:scouting_app/database/database.dart';
import 'package:scouting_app/provider/directory_provider.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
class Database extends _$Database {
  @override
  AppDatabase build() {
    ref.watch(appDirectoryProvider.future);
    return AppDatabase(directory: dbPath());
  }

  Future<Directory> dbPath() async {
    final Directory? dir = await ref.watch(appDirectoryProvider.future);
    debugPrint(dir.toString());
    return dir!;
  }
}
