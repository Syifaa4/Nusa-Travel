import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../routes/app_routes.dart';

const Color kNavy = Color(0xFF102A50);
const Color kGold = Color(0xFFF9B936);
const Color kSky = Color(0xFF4A9BD6);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animasi masuk (sekali) dan animasi berulang (pesawat, dot, glow).
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..forward();
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 8),
  )..repeat();

  bool _ready = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Setelah animasi masuk selesai, loader berganti menjadi tombol.
    _timer = Timer(const Duration(milliseconds: 2000), () {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _intro.dispose();
    _loop.dispose();
    super.dispose();
  }

  /// Memunculkan child (fade + naik) pada rentang waktu [begin, end].
  Widget _reveal(double begin, double end, Widget child,
      {double dy = 14, bool scale = false}) {
    final curve = Interval(begin, end, curve: Curves.easeOutCubic);
    return AnimatedBuilder(
      animation: _intro,
      child: child,
      builder: (_, c) {
        final v = curve.transform(_intro.value);
        Widget w = Opacity(opacity: v, child: c);
        w = scale
            ? Transform.scale(scale: 0.85 + 0.15 * v, child: w)
            : Transform.translate(offset: Offset(0, (1 - v) * dy), child: w);
        return w;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFCFE),
        body: Stack(
          children: [
            _Background(loop: _loop),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _reveal(0.12, 0.45, const NusaEmblem(height: 190),
                                scale: true),
                            const SizedBox(height: 28),
                            _reveal(0.30, 0.58, const _BrandTitle()),
                            const SizedBox(height: 12),
                            _reveal(0.40, 0.68, const _FlightPill(), dy: 10),
                            const SizedBox(height: 20),
                            _reveal(0.60, 0.88, const _Tagline()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 120,
                    child: _reveal(
                      0.65,
                      1.0,
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 450),
                        child: _ready
                            ? Padding(
                                key: const ValueKey('btn'),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 28),
                                child: FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: kNavy,
                                    foregroundColor: Colors.white,
                                    elevation: 6,
                                    shadowColor: kNavy.withAlpha(90),
                                  ),
                                  onPressed: () =>
                                      Navigator.pushReplacementNamed(
                                          context, AppRoutes.home),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Mulai Eksplorasi'),
                                      SizedBox(width: 10),
                                      Icon(Icons.flight_takeoff_rounded,
                                          color: kGold),
                                    ],
                                  ),
                                ),
                              )
                            : _Loader(key: const ValueKey('loader'), loop: _loop),
                      ),
                      dy: 8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Latar: glow, cincin orbit, rute penerbangan + pesawat yang melintas.
// ---------------------------------------------------------------------------
class _Background extends StatelessWidget {
  final Animation<double> loop;
  const _Background({required this.loop});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: loop,
        builder: (context, _) {
          final pulse = 1 + 0.06 * math.sin(loop.value * math.pi * 4);
          return Stack(
            fit: StackFit.expand,
            children: [
              // Langit biru lembut
              Align(
                alignment: const Alignment(0, -0.1),
                child: Container(
                  width: 520,
                  height: 520,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0xFFE6F3FB), Color(0x00F0F8FF)],
                    ),
                  ),
                ),
              ),
              // Glow emas di belakang paspor
              Align(
                alignment: const Alignment(0, -0.28),
                child: Transform.scale(
                  scale: pulse,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [kGold.withAlpha(70), kGold.withAlpha(0)],
                      ),
                    ),
                  ),
                ),
              ),
              // Cincin orbit kanan atas
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kSky.withAlpha(38)),
                  ),
                ),
              ),
              Positioned(
                top: -24,
                right: -24,
                child: Container(
                  width: 168,
                  height: 168,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: kGold.withAlpha(50)),
                  ),
                ),
              ),
              CustomPaint(painter: _RoutePainter(loop.value)),
            ],
          );
        },
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  final double progress;
  _RoutePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 1000;
    final sy = size.height / 700;

    final path = Path()
      ..moveTo(-80 * sx, 560 * sy)
      ..cubicTo(220 * sx, 540 * sy, 340 * sx, 370 * sy, 510 * sx, 320 * sy)
      ..cubicTo(690 * sx, 268 * sy, 810 * sx, 200 * sy, 1080 * sx, 150 * sy);

    // Garis putus-putus yang bergerak pelan.
    final dash = Paint()
      ..color = kSky.withAlpha(97)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;
    for (final m in path.computeMetrics()) {
      var d = -(progress * 260 % 13);
      while (d < m.length) {
        final s = d < 0 ? 0.0 : d;
        final e = math.min(d + 6, m.length);
        if (e > s) canvas.drawPath(m.extractPath(s, e), dash);
        d += 13;
      }
    }

    // Titik singgah.
    void node(double x, double y, Color c, double r) {
      final p = Offset(x * sx, y * sy);
      canvas.drawCircle(p, r, Paint()..color = c.withAlpha(210));
      canvas.drawCircle(
          p,
          r + 5,
          Paint()
            ..color = c.withAlpha(100)
            ..style = PaintingStyle.stroke);
    }

    node(280, 480, kGold, 4);
    node(510, 320, kSky, 3.5);
    node(760, 245, kGold, 4);

    // Pesawat mengikuti rute.
    final metric = path.computeMetrics().first;
    final t = Curves.easeInOut.transform(progress);
    final tangent = metric.getTangentForOffset(metric.length * t);
    if (tangent == null) return;

    const icon = Icons.flight;
    final tp = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 30,
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          color: kNavy.withAlpha(215),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    canvas.save();
    canvas.translate(tangent.position.dx, tangent.position.dy);
    canvas.rotate(tangent.vector.direction + math.pi / 2);
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _RoutePainter old) => old.progress != progress;
}

// ---------------------------------------------------------------------------
// Emblem: paspor navy + boarding pass emas (dipakai juga di halaman 404).
// ---------------------------------------------------------------------------
class NusaEmblem extends StatelessWidget {
  final double height;
  const NusaEmblem({super.key, this.height = 180});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: FittedBox(
        child: SizedBox(
          width: 210,
          height: 176,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 10,
                child: Transform.rotate(
                    angle: -4 * math.pi / 180, child: const _Ticket()),
              ),
              Positioned(
                left: 70,
                top: 4,
                child: Transform.rotate(
                    angle: 4 * math.pi / 180, child: const _Passport()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Ticket extends StatelessWidget {
  const _Ticket();

  @override
  Widget build(BuildContext context) {
    const navy = kNavy;
    Widget bar(double w) => Container(
        width: w, height: 13, margin: const EdgeInsets.only(right: 2), color: navy);
    return Container(
      width: 150,
      height: 92,
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [kGold, Color(0xFFFFCA58), Color(0xFFEEA514)],
        ),
        border: Border.all(color: Colors.white.withAlpha(100)),
        boxShadow: [
          BoxShadow(
              color: kGold.withAlpha(90), blurRadius: 14, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(children: [
            Icon(Icons.flight, size: 13, color: kNavy),
            SizedBox(width: 4),
            Text('BOARDING PASS',
                style: TextStyle(
                    fontSize: 9, fontWeight: FontWeight.w900, color: navy)),
          ]),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('JKT',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w900, color: navy)),
                Text('CGK',
                    style: TextStyle(
                        fontSize: 7.5, fontWeight: FontWeight.w700, color: navy)),
              ]),
              Icon(Icons.horizontal_rule_rounded, size: 18, color: navy),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('DPS',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w900, color: navy)),
                Text('BALI',
                    style: TextStyle(
                        fontSize: 7.5, fontWeight: FontWeight.w700, color: navy)),
              ]),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [bar(2), bar(1), bar(3), bar(1), bar(2)]),
              const Text('GATE 04 • SEAT 2A',
                  style: TextStyle(
                      fontSize: 7.5, fontWeight: FontWeight.w800, color: navy)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Passport extends StatelessWidget {
  const _Passport();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 158,
      padding: const EdgeInsets.fromLTRB(14, 14, 12, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF183B6D), kNavy, Color(0xFF0A1B33)],
        ),
        border: Border.all(color: kSky.withAlpha(90)),
        boxShadow: [
          BoxShadow(
              color: kNavy.withAlpha(100),
              blurRadius: 24,
              offset: const Offset(0, 12)),
        ],
      ),
      child: Column(
        children: [
          const Text('PASSPORT',
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: kGold)),
          const SizedBox(height: 2),
          const Text('REPUBLIC OF INDONESIA',
              style: TextStyle(
                  fontSize: 6.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: Color(0xFF79BFEA))),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 62,
                height: 62,
                child: Stack(
                  children: [
                    CustomPaint(size: const Size(62, 62), painter: _GlobePainter()),
                    Positioned(
                      top: 2,
                      right: 0,
                      child: Transform.rotate(
                        angle: 42 * math.pi / 180,
                        child: const Icon(Icons.flight,
                            size: 15, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 26,
            height: 17,
            decoration: BoxDecoration(
              color: kGold.withAlpha(40),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: kGold.withAlpha(200)),
            ),
            child: Center(
              child: Container(
                width: 15,
                height: 6,
                decoration: BoxDecoration(
                    color: kGold.withAlpha(230),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlobePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;
    final c = Offset(size.width / 2, size.height / 2);
    final p = Paint()
      ..color = kGold
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2 * s;
    canvas.drawCircle(c, 42 * s, p);
    canvas.drawOval(
        Rect.fromCenter(center: c, width: 84 * s, height: 32 * s), p..strokeWidth = 1.7 * s);
    canvas.drawOval(
        Rect.fromCenter(center: c, width: 40 * s, height: 84 * s), p);
    canvas.drawLine(Offset(8 * s, 50 * s), Offset(92 * s, 50 * s), p);
    canvas.drawLine(Offset(50 * s, 8 * s), Offset(50 * s, 92 * s), p);
    canvas.drawCircle(c, 3 * s, Paint()..color = kGold);
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}

// ---------------------------------------------------------------------------
// Teks merek.
// ---------------------------------------------------------------------------
class _BrandTitle extends StatelessWidget {
  const _BrandTitle();

  @override
  Widget build(BuildContext context) {
    return const Text.rich(
      TextSpan(
        style: TextStyle(
            fontSize: 38, fontWeight: FontWeight.w900, letterSpacing: -0.5),
        children: [
          TextSpan(text: 'NUSA', style: TextStyle(color: kNavy)),
          TextSpan(text: '  •  ', style: TextStyle(color: kGold, fontSize: 28)),
          TextSpan(text: 'TRAVEL', style: TextStyle(color: kSky)),
        ],
      ),
    );
  }
}

class _FlightPill extends StatelessWidget {
  const _FlightPill();

  @override
  Widget build(BuildContext context) {
    Widget dot(Color c) => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: c, shape: BoxShape.circle));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: kNavy.withAlpha(13),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: kNavy.withAlpha(26)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        dot(kGold),
        const SizedBox(width: 8),
        Text('FLIGHT & ADVENTURE',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 2.4,
                color: kNavy.withAlpha(230))),
        const SizedBox(width: 8),
        dot(kSky),
      ]),
    );
  }
}

class _Tagline extends StatelessWidget {
  const _Tagline();

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: 15, color: kNavy.withAlpha(190)),
        children: const [
          TextSpan(text: 'Your Journey, '),
          TextSpan(
              text: 'Our Adventure',
              style: TextStyle(fontWeight: FontWeight.w800, color: kNavy)),
          TextSpan(text: ' •', style: TextStyle(color: kGold)),
        ],
      ),
    );
  }
}

/// Tiga titik yang memantul bergantian (navy, emas, biru).
class _Loader extends StatelessWidget {
  final Animation<double> loop;
  const _Loader({super.key, required this.loop});

  @override
  Widget build(BuildContext context) {
    const colors = [kNavy, kGold, kSky];
    return AnimatedBuilder(
      animation: loop,
      builder: (_, __) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < 3; i++)
            Builder(builder: (_) {
              final t = ((loop.value * 8000 / 1350) - i * 0.13) % 1.0;
              final b = math.sin(math.pi * t);
              return Transform.translate(
                offset: Offset(0, -8 * b),
                child: Transform.scale(
                  scale: 1 + 0.2 * b,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: colors[i].withAlpha((100 + 155 * b).round()),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
