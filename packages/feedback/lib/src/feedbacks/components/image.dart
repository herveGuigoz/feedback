import 'package:feedback/src/shared/components/image.dart';
import 'package:flutter/material.dart';

class ImageDialog extends StatelessWidget {
  const ImageDialog({
    required this.image,
    super.key,
  });

  static Future<void> show(BuildContext context, {required String image}) async {
    return showDialog(
      context: context,
      builder: (_) => ImageDialog(image: image),
    );
  }

  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: FeedbackImage(image),
      ),
    );
  }
}
