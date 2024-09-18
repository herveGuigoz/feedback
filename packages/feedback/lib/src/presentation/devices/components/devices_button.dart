import 'package:feedback/src/presentation/app/bloc/app_bloc.dart';
import 'package:feedback/src/presentation/authentication/bloc/authentication_bloc.dart';
import 'package:feedback/src/presentation/devices/bloc/device_bloc.dart';
import 'package:feedback/src/presentation/shared/bloc/bus.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DevicesButton extends StatefulWidget {
  const DevicesButton({super.key});

  @override
  State<DevicesButton> createState() => _DevicesButtonState();
}

class _DevicesButtonState extends State<DevicesButton> {
  final popoverController = ShadPopoverController();

  @override
  void dispose() {
    popoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc auth) => auth.state);
    final state = context.select((AppBloc app) => app.state);
    final currentDevice = context.select((DeviceBloc device) => device.state);

    return ShadPopover(
      controller: popoverController,
      popover: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final device in Device.values) ...[
            ShadCheckbox(
              value: currentDevice == device,
              onChanged: (value) {
                if (value) {
                  context.read<EventBus>().add(DeviceChangedEvent(device));
                }
              },
              label: Text(
                switch (device) { Device.desktop => 'Desktop', _ => device.name },
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
              ),
              sublabel: switch (device) {
                Device.desktop => null,
                _ => Text(
                    '${device.screenSize.width}x${device.screenSize.height}',
                    style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w300, color: Colors.grey),
                  )
              },
            ),
            const Gap(8),
          ],
        ],
      ),
      child: ShadButton.outline(
        enabled: user == null || state != AppState.comment,
        onPressed: popoverController.toggle,
        child: const Icon(FluentIcons.laptop_16_regular),
      ),
    );
  }
}
