import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking/core/routing/app_routes.dart';
import 'package:order_tracking/core/styling/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startApp();
    });
  }

  Future<void> _startApp() async {
    await Future.wait([
      precacheImage(
        const AssetImage(AppAssets.order),
        context,
      ),
      precacheImage(
        const AssetImage(AppAssets.logo),
        context,
      ),
    ]);
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      context.go(AppRoutes.loginScreen);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RepaintBoundary(
          child: FadeTransition(
            opacity: _animation,
            child: Image.asset(
              AppAssets.logo,
              width: 200.w,
              height: 200.w,
              filterQuality: FilterQuality.none,
            ),
          ),
        ),
      ),
    );
  }
}
