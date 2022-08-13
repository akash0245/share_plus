// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ui';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

import 'method_channel_share.dart';

export 'package:share_plus_platform_interface/share_plus_platform_interface.dart' show ShareResult, ShareResultStatus;

/// Plugin for summoning a platform share sheet.
class Share {
  /* @visibleForTesting
  static set disableSharePlatformOverride(bool override) {
    _disablePlatformOverride = override;
  }
  static bool _disablePlatformOverride = false;
    static MethodChannelShare? __platform;
  static MethodChannelShare get _platform {
    if (__platform == null) {
      if (!_disablePlatformOverride && !kIsWeb) {
        if (Platform.isLinux) {
          __platform = ShareLinux() as MethodChannelShare?;
        } else if (Platform.isWindows) {
          __platform = ShareWindows() as MethodChannelShare?;
        }
      }
      __platform ??= MethodChannelShare.instance;
    }
    return __platform!;
  } */

  /// Summons the platform's share sheet to share text.
  ///
  /// Wraps the platform's native share dialog. Can share a text and/or a URL.
  /// It uses the `ACTION_SEND` Intent on Android and `UIActivityViewController`
  /// on iOS.
  ///
  /// The optional [subject] parameter can be used to populate a subject if the
  /// user chooses to send an email.
  ///
  /// The optional [sharePositionOrigin] parameter can be used to specify a global
  /// origin rect for the share sheet to popover from on iPads and Macs. It has no effect
  /// on other devices.
  ///
  /// May throw [PlatformException] or [FormatException]
  /// from [MethodChannel].
  static Future<void> share(
    String text, {
    String? subject,
    String? appPackage,
    Rect? sharePositionOrigin,
  }) {
    assert(text.isNotEmpty);
    return MethodChannelShare().share(
      text,
      subject: subject,
      appPackage: appPackage,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Summons the platform's share sheet to share multiple files.
  ///
  /// Wraps the platform's native share dialog. Can share a file.
  /// It uses the `ACTION_SEND` Intent on Android and `UIActivityViewController`
  /// on iOS.
  ///
  /// The optional `mimeTypes` parameter can be used to specify MIME types for
  /// the provided files.
  /// Android supports all natively available MIME types (wildcards like image/*
  /// are also supported) and it's considered best practice to avoid mixing
  /// unrelated file types (eg. image/jpg & application/pdf). If MIME types are
  /// mixed the plugin attempts to find the lowest common denominator. Even
  /// if MIME types are supplied the receiving app decides if those are used
  /// or handled.
  /// On iOS image/jpg, image/jpeg and image/png are handled as images, while
  /// every other MIME type is considered a normal file.
  ///
  /// The optional `sharePositionOrigin` parameter can be used to specify a global
  /// origin rect for the share sheet to popover from on iPads and Macs. It has no effect
  /// on other devices.
  ///
  /// May throw [PlatformException] or [FormatException]
  /// from [MethodChannel].
  static Future<void> shareFiles(
    List<String> paths, {
    List<String>? mimeTypes,
    String? appPackage,
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) {
    assert(paths.isNotEmpty);
    assert(paths.every((element) => element.isNotEmpty));
    return MethodChannelShare().shareFiles(
      paths,
      mimeTypes: mimeTypes,
      appPackage: appPackage,
      subject: subject,
      text: text,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Behaves exactly like [share] while providing feedback on how the user
  /// interacted with the share-sheet. Until the returned future is completed,
  /// any other call to any share method that returns a result _might_ result in
  /// a [PlatformException] (on Android).
  ///
  /// Because IOS, Android and macOS provide different feedback on share-sheet
  /// interaction, a result on IOS will be more specific than on Android or macOS.
  /// While on IOS the selected action can inform its caller that it was completed
  /// or dismissed midway (_actions are free to return whatever they want_),
  /// Android and macOS only record if the user selected an action or outright
  /// dismissed the share-sheet. It is not guaranteed that the user actually shared
  /// something.
  ///
  /// **Currently only implemented on IOS, Android and macOS.**
  ///
  /// Will gracefully fall back to the non result variant if not implemented
  /// for the current environment and return [ShareResult.unavailable].
  static Future<ShareResult> shareWithResult(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    assert(text.isNotEmpty);
    return MethodChannelShare().shareWithResult(
      text,
      subject: subject,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Behaves exactly like [shareFiles] while providing feedback on how the user
  /// interacted with the share-sheet. Until the returned future is completed,
  /// any other call to any share method that returns a result _might_ result in
  /// a [PlatformException] (on Android).
  ///
  /// Because IOS, Android and macOS provide different feedback on share-sheet
  /// interaction, a result on IOS will be more specific than on Android or macOS.
  /// While on IOS the selected action can inform its caller that it was completed
  /// or dismissed midway (_actions are free to return whatever they want_),
  /// Android and macOS only record if the user selected an action or outright
  /// dismissed the share-sheet. It is not guaranteed that the user actually shared
  /// something.
  ///
  /// **Currently only implemented on IOS, Android and macOS.**
  ///
  /// Will gracefully fall back to the non result variant if not implemented
  /// for the current environment and return [ShareResult.unavailable].
  static Future<ShareResult> shareFilesWithResult(
    List<String> paths, {
    List<String>? mimeTypes,
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) async {
    assert(paths.isNotEmpty);
    assert(paths.every((element) => element.isNotEmpty));
    return MethodChannelShare().shareFilesWithResult(
      paths,
      mimeTypes: mimeTypes,
      subject: subject,
      text: text,
      sharePositionOrigin: sharePositionOrigin,
    );
  }
}
