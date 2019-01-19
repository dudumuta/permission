library permission;

import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:meta/meta.dart';

part 'package:permission/permission_enums.dart';

part 'package:permission/utils/codec.dart';

class Permission {
  static Permission _instance;
  final MethodChannel _methodChannel;

  factory Permission() {
    if (_instance == null) {
      const MethodChannel methodChannel =
          MethodChannel("com.vdian.flutter.plugin.permission/methods");

      _instance = Permission.private(methodChannel);
    }

    return _instance;
  }

  @visibleForTesting
  Permission.private(this._methodChannel);

  ///检查权限是否被授予
  Future<PermissionStatus> checkPermissionStatus(
      PermissionGroup permission) async {
    final dynamic status = await _methodChannel.invokeMethod(
        "checkPermissionStatus", Codec.encodePermissionGroup(permission));

    return Codec.decodePermissionStatus(status);
  }

  ///打开设置
  Future<bool> openAppSetting() async {
    final bool hasOpend = await _methodChannel.invokeMethod("openAppSettings");

    return hasOpend;
  }

  ///申请权限
  Future<Map<PermissionGroup, PermissionStatus>> requestPermissions(
      List<PermissionGroup> permissions) async {
    final String jsonData = Codec.encodePermissionGroups(permissions);
    final dynamic status =
        await _methodChannel.invokeMethod("requestPermissions", jsonData);

    return Codec.decodePermissionRequestResult(status);
  }

  ///是否显示提示
  Future<bool> shouldShowRequestPermissionRationale(
      PermissionGroup permission) async {
    if (!Platform.isAndroid) {
      return false;
    }

    final bool shouldShowRationale = await _methodChannel.invokeMethod(
        "shouldShowRequestPermissionRationale",
        Codec.encodePermissionGroup(permission));

    return shouldShowRationale;
  }
}
