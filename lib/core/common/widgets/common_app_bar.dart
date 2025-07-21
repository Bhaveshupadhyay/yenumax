import 'package:flutter/material.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  const CommonAppBar({
    super.key,
    this.title = '',
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme= Theme.of(context);
    return AppBar(
      automaticallyImplyLeading: showBackButton,
      title: Text(title,
        style: theme.textTheme.titleMedium,
      ),
      centerTitle: false,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
