import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ImageDialog extends StatelessWidget {
  const ImageDialog({
    required this.imageUrl,
    super.key,
  });

  static Future<void> show(BuildContext context, {required Uri imageUrl}) {
    return showShadDialog<void>(context: context, builder: (_) => ImageDialog(imageUrl: imageUrl));
  }

  final Uri imageUrl;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);

    return ShadDialog.raw(
      variant: ShadDialogVariant.primary,
      constraints: BoxConstraints.tightFor(width: media.size.width * 0.8),
      child: Image.network(imageUrl.toString()),
    );
  }
}
