import 'package:feedback_client/feedback_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedbackImage extends StatelessWidget {
  const FeedbackImage(this.screenshot, {super.key});

  final String screenshot;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      Uri.parse(context.read<FeedbackClient>().baseUrl).resolve(screenshot).toString(),
    );
  }
}
