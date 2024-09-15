import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WebAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WebAppBar({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final parentRoute = ModalRoute.of(context);

    Widget leading = Center(child: Text(title, style: theme.textTheme.headlineSmall));
    if (parentRoute?.impliesAppBarDismissal ?? false) {
      leading = const BackButton();
    }

    return NavigationToolbar(
      leading: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 100),
        child: leading,
      ),
      middle: OverflowBar(
        children: [
          TextButton(
            onPressed: () => context.go('/'),
            child: const Text('counter'),
          ),
          TextButton(
            onPressed: () => context.go('/blog'),
            child: const Text('blog'),
          ),
        ],
      ),
    );
  }
}
