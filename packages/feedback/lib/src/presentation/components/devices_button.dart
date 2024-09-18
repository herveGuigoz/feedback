import 'package:feedback/src/presentation/bloc/app/app_bloc.dart';
import 'package:feedback/src/presentation/bloc/devices/device_bloc.dart';
import 'package:feedback/src/presentation/bloc/feedbacks_old/feedback.dart';
import 'package:feedback/src/presentation/components/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final state = context.select((AppBloc app) => app.state);

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
          AppState.comment => null,
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
                          context.read<DeviceBloc>().add(DeviceChangedEvent(device));
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
