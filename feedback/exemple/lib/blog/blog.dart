import 'package:example/shared/appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WebAppBar(
        title: 'Blog',
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.push('/');
          },
          child: const Text('Counter Page'),
        ),
      ),
    );
  }
}
