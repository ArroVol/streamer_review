import 'package:flutter/material.dart';

/// This class handles the page routing throughout the app.
class FadePageRoute<T> extends MaterialPageRoute<T> {
  FadePageRoute({
    WidgetBuilder builder,
    RouteSettings settings,
  }) : super(
    builder: builder,
    settings: settings,
  );

  @override Duration get transitionDuration => const Duration(milliseconds: 600);

  /// This transitions widgets from another.
  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    if (settings.name == '/') {
      return child;
    }

    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
