part of 'device_bloc.dart';

final class DeviceChangedEvent implements Event {
  const DeviceChangedEvent(this.device);

  final Device device;
}
