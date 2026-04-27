import 'package:client_app/config/routes/app_router.dart';
import 'package:client_app/core/utils/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashPageBodyState();
}

class _SplashPageBodyState extends State<SplashBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final location = AppRouter.returnFullPath();
        setState(() {
          GoRouter.of(context).go(AppRouter.kLogin);
          if (location != "/") {
            AppRouter.router.push(location);
          }
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: theme.surface,
      // child:
      // Lottie.asset(
      //   Assets.animations.splashAnimation.path,
      //   fit: BoxFit.contain,
      //   animate: true,
      //   repeat: false,
      //   controller: _controller,
      //   onLoaded: (comp) {
      //     _controller.duration = comp.duration;
      //     _controller.forward();
      //   },
      // ),
    );
  }
}
