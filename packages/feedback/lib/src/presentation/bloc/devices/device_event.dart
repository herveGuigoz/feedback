part of 'device_bloc.dart';

sealed class DeviceEvent {
  const DeviceEvent();
}

final class DeviceChangedEvent extends DeviceEvent {
  const DeviceChangedEvent(this.device);

  final Device device;
}
