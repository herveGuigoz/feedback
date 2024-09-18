part of 'layout.dart';

class RightPane extends StatefulWidget {
  const RightPane({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<RightPane> createState() => _RightPaneState();
}

class _RightPaneState extends State<RightPane> {
  /// The key to access the repaint boundary
  final _key = GlobalKey();

  /// The size of the child widget.
  late Size _childSize;

  /// Capture the screenshot
  Future<void> _takeScreenshot() async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final boundary = _key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    log('Screenshot taken', name: 'RightPane');
    // ignore: use_build_context_synchronously
    context.read<EventBus>().add(ScreenshotEvent(image: pngBytes, screenSize: _childSize));
  }

  @override
  Widget build(BuildContext context) {
    final device = context.select((DeviceBloc controller) => controller.state);

    final child = Measurer(
      onMeasure: (size, constraints) => setState(() => _childSize = size),
      child: RepaintBoundary(
        key: _key,
        child: widget.child,
      ),
    );

    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) => current == AppState.comment,
      listener: (context, state) => _takeScreenshot(),
      child: Builder(
        builder: (context) {
          final state = context.select((AppBloc app) => app.state);

          return IgnorePointer(
            ignoring: switch (state) { AppState.comment => true, _ => false },
            child: switch (device) {
              Device.desktop => child,
              _ => ColoredBox(
                  color: Colors.grey.shade100,
                  child: Center(
                    child: SizedBox(
                      width: device.screenSize.width,
                      height: device.screenSize.height,
                      child: MediaQuery(
                        data: MediaQuery.of(context).copyWith(
                          size: device.screenSize,
                          padding: device.safeAreas,
                          viewInsets: EdgeInsets.zero,
                          viewPadding: device.safeAreas,
                          devicePixelRatio: device.pixelRatio,
                        ),
                        child: child,
                      ),
                    ),
                  ),
                )
            },
          );
        },
      ),
    );
  }
}
