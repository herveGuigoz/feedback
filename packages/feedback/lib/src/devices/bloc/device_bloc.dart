import 'package:feedback/src/shared/bloc/bloc.dart';
import 'package:feedback/src/shared/events/events.dart';
import 'package:feedback_client/feedback_client.dart';

part 'device_event.dart';

class DeviceBloc extends Bloc<Device> {
  DeviceBloc({required super.eventBus}) : super(Device.desktop) {
    on<DeviceChangedEvent>(_onDeviceChanged);
  }

  void _onDeviceChanged(DeviceChangedEvent event) {
    emit(event.device);
  }
}
