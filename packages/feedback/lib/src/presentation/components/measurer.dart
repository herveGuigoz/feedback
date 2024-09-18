import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Measure the size of its [child].
class Measurer extends SingleChildRenderObjectWidget {
  /// The given [onMeasure] callback is called after each new rendering of its
  /// child and provides its layout size.
  const Measurer({
    required super.child,
    this.onMeasure,
    super.key,
  });

  /// A callback that is called after each new rendering of its child and provides
  /// its layout size.
  final OnMeasure? onMeasure;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _MeasureSizeRenderObject(
      onMeasure: onMeasure,
    );
  }
}

/// When a [size] or its associated [constraints] changed.
typedef OnMeasure = void Function(
  Size size,
  BoxConstraints? constraints,
);

/// An element that notifies whenever its size changes.
class _MeasureSizeRenderObject extends RenderProxyBox {
  _MeasureSizeRenderObject({
    required this.onMeasure,
  });

  final OnMeasure? onMeasure;

  Size? _size;
  
  BoxConstraints? _constraints;

  @override
  void performLayout() {
    super.performLayout();

    var measureChanged = false;

    final newSize = child?.size ?? Size.zero;
    if (_size != newSize) {
      _size = newSize;
      measureChanged = true;
    }

    measureChanged = onMeasure != null && measureChanged;

    if (measureChanged) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (measureChanged) {
          onMeasure?.call(_size!, _constraints);
        }
      });
    }
  }
}
