part of 'models.dart';

/// {@template device}
/// The device to display the app on
/// {@endtemplate}
enum Device {
  desktop._(1, ui.Size(1024, 1366)),
  iPhoneSE._(2, ui.Size(375, 667)),
  iPhone16Pro._(3, ui.Size(402, 874)),
  ipad._(2, ui.Size(810, 1080));

  const Device._(this.pixelRatio, this.screenSize);

  final double pixelRatio;

  final ui.Size screenSize;
}
