import 'package:flutter/material.dart';
class CustomOffsetRoute<T> extends MaterialPageRoute<T> {
  final Offset offset;

  CustomOffsetRoute(
      {WidgetBuilder builder,
        this.offset: const Offset(1.0, 0.0),
        RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;

    return SlideTransition(
      position: new Tween<Offset>(
        begin: offset,
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }
}