part of 'layout.dart';

class RightPane extends StatefulWidget {
  const RightPane({
    required this.controller,
    required this.child,
    super.key,
  });

  final FeedbackController controller;

  final Widget child;

  @override
  State<RightPane> createState() => _RightPaneState();
}

class _RightPaneState extends State<RightPane> {
  /// The key to access the repaint boundary
  final _key = GlobalKey();

  /// The previous state of the feedback controller.
  FeedbackState? _previousState;

  /// The size of the child widget.
  late Size _childSize;

  FeedbackController get controller => widget.controller;

  /// Capture the screenshot
  Future<void> _takeScreenshot() async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final boundary = _key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    controller.screenshot = Screenshot(image: pngBytes, size: _childSize);
  }

  void _handleChange() {
    if (controller.state == _previousState) {
      return;
    }

    if (widget.controller.state == FeedbackState.comment) {
      _takeScreenshot();
    }

    setState(() {
      _previousState = controller.state;
    });
  }

  @override
  void initState() {
    _previousState = controller.state;
    controller.addListener(_handleChange);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant RightPane oldWidget) {
    if (oldWidget.controller != widget.controller) {
      _previousState = widget.controller.state;
      oldWidget.controller.removeListener(_handleChange);
      widget.controller.addListener(_handleChange);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.removeListener(_handleChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final device = context.select((DeviceController controller) => controller.current);

    Widget child = Measurer(
      onMeasure: (size, constraints) => setState(() => _childSize = size),
      child: RepaintBoundary(
        key: _key,
        child: widget.child,
      ),
    );

    if (device != null) {
      child = ColoredBox(
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
      );
    }

    return IgnorePointer(
      ignoring: controller.state == FeedbackState.comment,
      child: child,
    );
  }
}
