import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../core/app_constants.dart';

class CnSlide extends StatefulWidget {
  final Widget child;
  final Duration? duration;
  final Offset begin;
  final Offset end;
  // final Curve curve;
  final double intervalBegin;
  final double intervalEnd;
  final bool forward;
  final Duration delay;
  final int delayInMilliSeconds;
  final AnimationController? controller;
  final bool reverseControllerValue;

  const CnSlide({
    required this.child,
    this.duration,
    this.begin = const Offset(0, 0.5),
    this.end = Offset.zero,
    // this.curve = defaultCurve,
    this.intervalBegin = 0.0,
    this.intervalEnd = 1.0,
    this.forward = true,
    this.delay = const Duration(),
    this.delayInMilliSeconds = 0,
    this.controller,
    this.reverseControllerValue = false,
    Key? key,
  }) : super(key: key);

  @override
  _CnSlideState createState() => _CnSlideState();
}

class _CnSlideState extends State<CnSlide> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      duration: widget.duration ?? const Duration(milliseconds: 300),
      vsync: this,
    );

    Future.delayed(
      Duration(milliseconds: widget.delayInMilliSeconds),
      () {
        if (mounted) _controller.forward();
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double intervalBegin =
        widget.intervalBegin < 1.0 ? widget.intervalBegin : 1.0;
    double intervalEnd = widget.intervalEnd > 0.0 ? widget.intervalEnd : 0.0;

    _slideAnimation = Tween<Offset>(
      begin: widget.forward ? widget.begin : widget.end,
      end: widget.forward ? widget.end : widget.begin,
    ).animate(
      CurvedAnimation(
        parent: widget.controller ?? _controller,
        curve: Interval(
          intervalBegin,
          intervalEnd,
          // curve: widget.curve,
        ),
      ),
    );

    return SlideTransition(
      position: _slideAnimation,
      child: widget.child,
    );
  }
}

class CnFade extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool forward;
  final double fadeStartValue;
  final double fadeEndValue;
  final int delayInMilliseconds;
  final Duration delay;

  const CnFade({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.forward = true,
    this.fadeStartValue = 0,
    this.fadeEndValue = 1,
    this.delayInMilliseconds = 10,
    this.delay = const Duration(),
    Key? key,
  }) : super(key: key);

  @override
  _CnFadeState createState() => _CnFadeState();
}

class _CnFadeState extends State<CnFade> with SingleTickerProviderStateMixin {
  late double opacity;

  @override
  void initState() {
    opacity = widget.forward ? widget.fadeStartValue : widget.fadeEndValue;

    super.initState();
  }

  /// since we're handling this with setState inside the build method
  /// we need to stop it somehow.
  bool done = false;

  @override
  void didUpdateWidget(CnFade oldWidget) {
    // dprint('DID UPDATE WIDGET CALLED', priority: 4);

    if (widget.forward != oldWidget.forward) {
      done = false;
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(milliseconds: math.max(0, widget.delayInMilliseconds)),
      () {
        if (done) return;

        if (mounted) {
          setState(() {
            done = true;
            opacity =
                widget.forward ? widget.fadeEndValue : widget.fadeStartValue;
          });
        }
      },
    );

    return AnimatedOpacity(
      child: widget.child,
      duration: widget.duration,
      opacity: opacity,
    );
  }
}

class CnDottedLoadingAnimation extends StatelessWidget {
  final Color? color;
  final double size;

  const CnDottedLoadingAnimation({
    Key? key,
    this.color,
    this.size = 14,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: appTextDirection,
      child: SpinKitThreeBounce(
        color: color ?? Theme.of(context).primaryColor,
        size: size,
      ),
    );
  }
}
