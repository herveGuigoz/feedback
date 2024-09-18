import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<DeviceEvent, Device> {
  DeviceBloc() : super(Device.desktop) {
    on<DeviceChangedEvent>(_onDeviceChanged);
  }

  void _onDeviceChanged(DeviceChangedEvent event, Emitter<Device> emit) {
    emit(event.device);
  }
}
