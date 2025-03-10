import 'package:flutter/material.dart';

import 'ad_banner.dart';

class AdWrapper extends StatelessWidget {
  final Widget child;

  const AdWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          Expanded(child: child),
          const AdBanner(),
        ],
      ),
    );
  }
}
