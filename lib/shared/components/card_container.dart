import 'package:flutter/material.dart';

import '../../theme/theme.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const CardContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: AppTheme.cardBox, // usa o estilo do theme.dart
      child: child,
    );
  }
}
