import 'package:flutter/material.dart';

import 'features/home_shell_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _displayDuration = Duration(milliseconds: 1800);

  @override
  void initState() {
    super.initState();
    _openHome();
  }

  Future<void> _openHome() async {
    await Future<void>.delayed(_displayDuration);
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeShellScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logoSize =
        (MediaQuery.sizeOf(context).shortestSide * 0.62).clamp(160.0, 250.0);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF07152F), Color(0xFF102D5E), Color(0xFF111B47)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -100,
              right: -90,
              child: _glow(const Color(0xFF0DE0C1)),
            ),
            Positioned(
              bottom: -130,
              left: -100,
              child: _glow(const Color(0xFF685BFF)),
            ),
            SafeArea(
              child: Center(
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.92, end: 1),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOutCubic,
                  builder: (context, scale, child) => Opacity(
                    opacity: ((scale - 0.92) / 0.08).clamp(0, 1),
                    child: Transform.scale(scale: scale, child: child),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/splash-icon.png',
                        width: logoSize,
                        height: logoSize,
                        fit: BoxFit.contain,
                        semanticLabel: 'Age Calculator logo',
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Age Calculator',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Make every moment count',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.72),
                          fontSize: 15,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _glow(Color color) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.25),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );
  }
}
