import 'package:feedback/src/presentation/shared/bloc/bloc.dart';
import 'package:feedback/src/presentation/shared/bloc/bus.dart';
import 'package:flutter/rendering.dart';

part 'device_event.dart';
part 'device_state.dart';

class DeviceBloc extends Bloc<Device> {
  DeviceBloc({required super.eventBus}) : super(Device.desktop) {
    on<DeviceChangedEvent>(_onDeviceChanged);
  }

  void _onDeviceChanged(DeviceChangedEvent event) {
    emit(event.device);
  }
}
