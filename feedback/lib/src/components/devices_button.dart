import 'package:feedback/src/components/theme.dart';
import 'package:feedback/src/core/devices.dart';
import 'package:feedback/src/core/feedback.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DevicesButton extends StatefulWidget {
  const DevicesButton({super.key});

  @override
  State<DevicesButton> createState() => _DevicesButtonState();
}

class _DevicesButtonState extends State<DevicesButton> {
  final _overlaypController = OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    final theme = FeedbackTheme.of(context);
    final media = MediaQuery.of(context);
    final state = context.select((FeedbackController controller) => controller.state);

    return ListTileTheme(
      data: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        dense: true,
        minVerticalPadding: 0,
        titleTextStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        subtitleTextStyle: TextStyle(fontSize: 4, fontWeight: FontWeight.w300, color: Colors.grey),
      ),
      child: IconButton.outlined(
        onPressed: switch (state) {
          FeedbackState.comment => null,
          _ => _overlaypController.toggle,
        },
        icon: OverlayPortal(
          controller: _overlaypController,
          overlayChildBuilder: (BuildContext context) => Positioned(
            bottom: media.padding.bottom + 54,
            left: 35,
            child: Material(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.backgroundColor,
                  border: Border.all(color: theme.border.color, width: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                constraints: const BoxConstraints.tightFor(
                  width: 120,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final device in Device.values)
                      ListTile(
                        title: Text(device.name),
                        subtitle: Text('${device.screenSize.width}x${device.screenSize.height}'),
                        onTap: () {
                          _overlaypController.toggle();
                          context.read<DeviceController>().changeDevice(device);
                        },
                      ),
                    ListTile(
                      title: const Text('Desktop'),
                      onTap: () {
                        _overlaypController.toggle();
                        context.read<DeviceController>().removeDevice();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          child: const Icon(Icons.devices),
        ),
        // icon: const Icon(Icons.devices),
      ),
    );
  }
}
