part of 'models.dart';

/// {@template device}
/// The device to display the app on
/// {@endtemplate}
enum Device {
  desktop._(1, ui.Size(1024, 1366)),
  iPhoneSE._(2, ui.Size(375, 667));
  // iPhone12._(2, Size(1024, 1366), EdgeInsets.only(top: 24, bottom: 20));
  // iPhone12Mini._(),
  // iPhone12ProMax._(),
  // iPhone13._(),
  // iPhone13Mini._(),
  // iPhone13Max._(),
  // iPadMini._(),
  // galaxyA50._(TargetPlatform.android),
  // galaxyNote20._(TargetPlatform.android),
  // galaxyS20._(TargetPlatform.android),
  // onePlusPro._(TargetPlatform.android);

  const Device._(this.pixelRatio, this.screenSize);

  final double pixelRatio;

  final ui.Size screenSize;
}
