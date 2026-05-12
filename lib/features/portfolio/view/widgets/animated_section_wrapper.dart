import 'package:flutter/material.dart';

class AnimatedSectionWrapper extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset slideOffset;

  const AnimatedSectionWrapper({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 700),
    this.slideOffset = const Offset(0, 0.1),
  });

  @override
  State<AnimatedSectionWrapper> createState() => _AnimatedSectionWrapperState();
}

class _AnimatedSectionWrapperState extends State<AnimatedSectionWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.slideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // Auto-start after delay (for initial sections)
    Future.delayed(widget.delay, () {
      if (mounted && !_hasAnimated) {
        _triggerAnimation();
      }
    });
  }

  void _triggerAnimation() {
    if (!_hasAnimated) {
      _hasAnimated = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _checkVisibility();
        return false;
      },
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: widget.child,
        ),
      ),
    );
  }

  void _checkVisibility() {
    if (_hasAnimated) return;
    final renderObject = context.findRenderObject();
    if (renderObject is RenderBox) {
      final position = renderObject.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      if (position.dy < screenHeight * 0.9) {
        _triggerAnimation();
      }
    }
  }
}

/// Scroll-triggered animation widget
class ScrollAnimatedWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset slideFrom;

  const ScrollAnimatedWidget({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.slideFrom = const Offset(0, 40),
  });

  @override
  State<ScrollAnimatedWidget> createState() => _ScrollAnimatedWidgetState();
}

class _ScrollAnimatedWidgetState extends State<ScrollAnimatedWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _translateY;
  bool _triggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _translateY = Tween<double>(
      begin: widget.slideFrom.dy,
      end: 0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    // For web, trigger after short delay
    Future.delayed(widget.delay + const Duration(milliseconds: 300), () {
      if (mounted) _trigger();
    });
  }

  void _trigger() {
    if (!_triggered) {
      _triggered = true;
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.translate(
            offset: Offset(0, _translateY.value),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}
