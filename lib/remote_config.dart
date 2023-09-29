// dart
import 'dart:async';
import 'package:flutter/material.dart' show debugPrint;

// third party
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfig {
  /// FirebaseRemoteConfig を利用するための初期化を行います。
  static initialize() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(minutes: 60),
    ));
    await remoteConfig.setDefaults(const {'is_maintenance': false});
    await remoteConfig.fetchAndActivate();
    await startMonitoring();
  }

  static StreamSubscription<RemoteConfigUpdate>? _subscription;

  /// FirebaseRemoteConfig の更新監視を開始します。
  static Future<void> startMonitoring() async {
    await stopMonitoring();
    _subscription =
        FirebaseRemoteConfig.instance.onConfigUpdated.listen(_onConfigUpdated);
  }

  /// FirebaseRemoteConfig の更新監視を停止します。
  static Future<void> stopMonitoring() async {
    if (_subscription != null) {
      await _subscription!.cancel();
      _subscription = null;
    }
  }

  /// onConfigUpdated listener
  static _onConfigUpdated(RemoteConfigUpdate config) {
    debugPrint('RemoteConfig: 内容が更新されました。');
  }
}

@Deprecated('Please use RemoteConfig.initialize().')
Future<void> initRemoteConfig() => RemoteConfig.initialize();
