import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../routes/app_routes.dart';
import 'splash_screen.dart' show NusaEmblem, kNavy, kGold, kSky;

const Color _cream = Color(0xFFFAF8EE);
const Color _muted = Color(0xFF627D98);
const Color _orange = Color(0xFFF97316);

class NotFoundScreen extends StatefulWidget {
  final String? routeName;
  const NotFoundScreen({super.key, this.routeName});

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _goHome() => Navigator.pushNamedAndRemoveUntil(
      context, AppRoutes.home, (route) => false);

  void _goBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      _goHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: _cream,
        body: Stack(
          children: [
            // Watermark "404" raksasa
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Text(
                  '404',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 220,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -8,
                    color: kNavy.withAlpha(9),
                  ),
                ),
              ),
            ),
            // Glow sky & emas
            Positioned(
              top: -120,
              right: -120,
              child: _Glow(color: kSky.withAlpha(34), size: 320),
            ),
            Positioned(
              bottom: -140,
              left: -100,
              child: _Glow(color: kGold.withAlpha(45), size: 320),
            ),
            SafeArea(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                builder: (_, v, child) => Opacity(
                  opacity: v,
                  child: Transform.translate(
                      offset: Offset(0, (1 - v) * 24), child: child),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const _BrandHeader(),
                      const SizedBox(height: 8),
                      _Illustration(controller: _c),
                      const SizedBox(height: 4),
                      _codeBadge(),
                      const SizedBox(height: 14),
                      const Text.rich(
                        TextSpan(
                          style: TextStyle(
                              fontSize: 33,
                              height: 1.15,
                              fontWeight: FontWeight.w900,
                              color: kNavy,
                              letterSpacing: -0.5),
                          children: [
                            TextSpan(text: 'Ups! Kamu\n'),
                            TextSpan(
                              text: 'Tersesat.',
                              style: TextStyle(
                                color: kSky,
                                decoration: TextDecoration.underline,
                                decorationStyle: TextDecorationStyle.wavy,
                                decorationColor: kGold,
                                decorationThickness: 2,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Tujuan ini tidak ada di radar kami. Tenang, '
                        'yuk kembali ke jalur menuju petualangan berikutnya!',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 15, height: 1.55, color: _muted),
                      ),
                      const SizedBox(height: 20),
                      _infoCard(),
                      const SizedBox(height: 22),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: kNavy,
                          foregroundColor: Colors.white,
                          elevation: 5,
                          shadowColor: kNavy.withAlpha(80),
                        ),
                        onPressed: _goHome,
                        icon: const Icon(Icons.home_rounded),
                        label: const Text('Kembali ke Beranda'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(54),
                          foregroundColor: kNavy,
                          backgroundColor: Colors.white,
                          side: BorderSide(color: kNavy.withAlpha(40), width: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          textStyle: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        onPressed: _goBack,
                        icon: const Icon(Icons.arrow_back_rounded, color: kSky),
                        label: const Text('Halaman Sebelumnya'),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                  color: Color(0xFF10B981),
                                  shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          const Text('Sistem Navigasi NusaTravel Aktif',
                              style: TextStyle(fontSize: 12, color: _muted)),
                        ],
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

  Widget _codeBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: kNavy.withAlpha(26)),
        ),
        child: const Row(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(radius: 4, backgroundColor: _orange),
          SizedBox(width: 8),
          Text('NUSA TRAVEL • FLIGHT 404',
              style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: kNavy)),
        ]),
      );

  Widget _infoCard() => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(235),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kNavy.withAlpha(26)),
        ),
        child: Row(children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: kSky.withAlpha(28),
                borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.warning_amber_rounded,
                size: 20, color: kSky),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Titik Singgah #404',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: kNavy)),
                Text('Rute "${widget.routeName ?? '-'}" tidak ditemukan',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11.5, color: _muted)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _cream,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kNavy.withAlpha(14)),
            ),
            child: Text('HTTP 404',
                style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'monospace',
                    color: kNavy.withAlpha(150))),
          ),
        ]),
      );
}

class _Glow extends StatelessWidget {
  final Color color;
  final double size;
  const _Glow({required this.color, required this.size});

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [color, color.withAlpha(0)]),
          ),
        ),
      );
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const NusaEmblem(height: 46),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text.rich(
              TextSpan(
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1),
                children: [
                  TextSpan(text: 'NUSA', style: TextStyle(color: kNavy)),
                  TextSpan(text: ' • ', style: TextStyle(color: kGold)),
                  TextSpan(text: 'TRAVEL', style: TextStyle(color: kSky)),
                ],
              ),
            ),
            const SizedBox(height: 3),
            Text('FLIGHT & ADVENTURE',
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.8,
                    color: kNavy.withAlpha(150))),
          ],
        ),
      ],
    );
  }
}

/// Ilustrasi penjelajah dengan tanda tanya melayang, bintang berkelip,
/// dan pesawat kertas yang mengorbit.
class _Illustration extends StatelessWidget {
  final Animation<double> controller;
  const _Illustration({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 310,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final t = controller.value * 2 * math.pi;
          double twinkle(double phase) =>
              0.25 + 0.75 * (0.5 + 0.5 * math.sin(t * 2 + phase));

          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Glow emas di belakang karakter
              Transform.scale(
                scale: 1 + 0.04 * math.sin(t * 2),
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                        colors: [kGold.withAlpha(75), kGold.withAlpha(0)]),
                  ),
                ),
              ),
              // Karakter (bergoyang halus)
              Transform.rotate(
                angle: math.sin(t) * 0.025,
                alignment: Alignment.bottomCenter,
                child: Image.asset('assets/images/explorer.png', height: 270),
              ),
              // Tanda tanya melayang
              Positioned(
                top: 6 + 7 * math.sin(t * 2),
                right: 62,
                child: Transform.rotate(
                  angle: -0.07 + 0.14 * math.sin(t * 2),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: kNavy, width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: kNavy.withAlpha(36),
                            blurRadius: 8,
                            offset: const Offset(0, 4)),
                      ],
                    ),
                    child: const Center(
                      child: Text('?',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: _orange)),
                    ),
                  ),
                ),
              ),
              // Bintang berkelip
              Positioned(
                top: 40,
                left: 18,
                child: Opacity(
                    opacity: twinkle(0),
                    child: const Icon(Icons.auto_awesome, color: kSky, size: 20)),
              ),
              Positioned(
                top: 120,
                right: 6,
                child: Opacity(
                    opacity: twinkle(2),
                    child: const Icon(Icons.auto_awesome, color: kGold, size: 24)),
              ),
              Positioned(
                bottom: 70,
                left: 6,
                child: Opacity(
                    opacity: twinkle(4),
                    child: const Icon(Icons.circle, color: _orange, size: 8)),
              ),
              // Pesawat kertas mengorbit
              Positioned(
                left: 210 + 80 * math.cos(t) - 14,
                top: 120 + 34 * math.sin(t * 2) - 14,
                child: Transform.rotate(
                  angle: -0.6 + 0.4 * math.sin(t),
                  child: const Icon(Icons.send_rounded, color: kNavy, size: 26),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
