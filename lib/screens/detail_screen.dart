import 'package:flutter/material.dart';

import '../models/tour_package.dart';
import 'booking_screen.dart';
import 'home_screen.dart' show buildPackageImage;

class DetailScreen extends StatefulWidget {
  final TourPackage package;
  const DetailScreen({super.key, required this.package});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  BookingResult? _lastBooking;
  bool _saved = false;
  bool _expanded = false;

  Future<void> _openBooking() async {
    final result = await Navigator.push<BookingResult>(
      context,
      MaterialPageRoute(
        builder: (_) => BookingScreen(package: widget.package),
      ),
    );

    if (result != null && mounted) {
      setState(() => _lastBooking = result);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            width: 520,
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            content: Text(
              'Pemesanan berhasil! ${result.name} • '
              '${result.participants} peserta • ${formatRupiah(result.total)}',
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.package;
    final cs = Theme.of(context).colorScheme;
    final w = MediaQuery.sizeOf(context).width;
    return w >= 900 ? _buildWide(p, cs) : _buildNarrow(p, cs, context);
  }

  // ---------------------------------------------------------------------
  // Layout HP / jendela sempit
  // ---------------------------------------------------------------------
  Widget _buildNarrow(TourPackage p, ColorScheme cs, BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: (h * 0.4).clamp(240.0, 420.0),
            pinned: true,
            backgroundColor: cs.primary,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: _Gallery(package: p),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Container(
                  transform: Matrix4.translationValues(0, -22, 0),
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F8F8),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: _content(p, cs),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 16,
                offset: const Offset(0, -4)),
          ]),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Row(children: [
                _priceBlock(p, cs),
                const SizedBox(width: 20),
                Expanded(
                  child: FilledButton(
                    onPressed: _openBooking,
                    child: const Text('Pesan Sekarang'),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Layout web lebar: dua kolom
  // ---------------------------------------------------------------------
  Widget _buildWide(TourPackage p, ColorScheme cs) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: Colors.white,
        title: const Text('Detail Paket',
            style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: AspectRatio(
                          aspectRatio: 16 / 10,
                          child: _Gallery(package: p, inset: 14),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _content(p, cs),
                    ],
                  ),
                ),
                const SizedBox(width: 28),
                SizedBox(
                  width: 340,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _priceBlock(p, cs, big: true),
                        const SizedBox(height: 4),
                        Text('Harga per orang',
                            style: TextStyle(
                                fontSize: 12.5, color: Colors.grey.shade600)),
                        const SizedBox(height: 18),
                        FilledButton(
                          onPressed: _openBooking,
                          child: const Text('Pesan Sekarang'),
                        ),
                        const SizedBox(height: 14),
                        Row(children: [
                          Icon(Icons.verified_user_rounded,
                              size: 16, color: cs.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text('Jaminan harga terbaik',
                                style: TextStyle(
                                    fontSize: 12.5,
                                    color: cs.primary,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Blok harga (dipakai di bar bawah dan kartu samping)
  // ---------------------------------------------------------------------
  Widget _priceBlock(TourPackage p, ColorScheme cs, {bool big = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (p.originalPrice != null)
          Text(formatRupiah(p.originalPrice!),
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  decoration: TextDecoration.lineThrough))
        else if (!big)
          Text('Harga / orang',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        Text(formatRupiah(p.price),
            style: TextStyle(
                fontSize: big ? 26 : 19,
                fontWeight: FontWeight.w800,
                color: cs.tertiary)),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // Isi informasi (dipakai oleh kedua layout)
  // ---------------------------------------------------------------------
  Widget _content(TourPackage p, ColorScheme cs) {
    final shown = _expanded ? p.highlights : p.highlights.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul + bookmark
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(p.title,
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.w800, height: 1.25)),
            ),
            IconButton.filledTonal(
              tooltip: 'Simpan',
              onPressed: () => setState(() => _saved = !_saved),
              icon: Icon(_saved
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(spacing: 8, runSpacing: 8, children: [
          _Info(Icons.place_rounded, p.location),
          _Info(Icons.schedule_rounded, p.duration),
          _Info(Icons.category_rounded, p.category),
        ]),
        const SizedBox(height: 8),
        _Info(Icons.access_time_rounded, 'Jam operasional: ${p.openingHours}'),

        // Banner jaminan harga
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: cs.primary.withAlpha(18),
            borderRadius: BorderRadius.circular(14),
            border: Border(left: BorderSide(color: cs.primary, width: 4)),
          ),
          child: Row(children: [
            Icon(Icons.verified_user_rounded, color: cs.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Jaminan Harga Terbaik — temukan harga lebih murah, '
                'selisihnya kami ganti.',
                style: TextStyle(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                    height: 1.4),
              ),
            ),
          ]),
        ),

        // Ringkasan rating
        const SizedBox(height: 16),
        _RatingCard(package: p),

        if (_lastBooking != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(children: [
              Icon(Icons.check_circle_rounded, color: Colors.green.shade700),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Pesanan terakhir: ${_lastBooking!.name}, '
                  '${_lastBooking!.participants} peserta, '
                  'berangkat ${formatTanggal(_lastBooking!.date)}',
                  style: TextStyle(color: Colors.green.shade900, height: 1.4),
                ),
              ),
            ]),
          ),
        ],

        // Deskripsi
        const SizedBox(height: 22),
        const _Title('Deskripsi'),
        Text(p.description,
            style: TextStyle(
                fontSize: 15, height: 1.65, color: Colors.grey.shade800)),

        // Highlight (expandable)
        if (p.highlights.isNotEmpty) ...[
          const SizedBox(height: 22),
          const _Title('Yang Akan Kamu Alami'),
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                for (final h in shown)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(Icons.check_circle_rounded,
                              size: 18, color: cs.tertiary),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(h,
                                style: const TextStyle(
                                    fontSize: 15, height: 1.45))),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (p.highlights.length > 3)
            TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              child: Text(
                  _expanded ? 'Lihat lebih sedikit' : 'Lihat selengkapnya'),
            ),
        ],

        // Termasuk
        const SizedBox(height: 18),
        const _Title('Termasuk dalam Paket'),
        const Wrap(spacing: 10, runSpacing: 10, children: [
          _Facility(Icons.flight_rounded, 'Tiket Pesawat'),
          _Facility(Icons.hotel_rounded, 'Hotel'),
          _Facility(Icons.directions_bus_rounded, 'Transportasi'),
          _Facility(Icons.restaurant_rounded, 'Makan'),
          _Facility(Icons.person_pin_rounded, 'Pemandu'),
          _Facility(Icons.shield_rounded, 'Asuransi'),
        ]),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Carousel foto dengan penanda halaman.
/// [inset] = jarak penanda dari tepi bawah (di HP lebih besar karena
/// tertutup lengkungan konten).
class _Gallery extends StatefulWidget {
  final TourPackage package;
  final double inset;
  const _Gallery({required this.package, this.inset = 36});

  @override
  State<_Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<_Gallery> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _go(int i) => _controller.animateToPage(i,
      duration: const Duration(milliseconds: 280), curve: Curves.easeOut);

  @override
  Widget build(BuildContext context) {
    final imgs = widget.package.gallery;
    return Stack(fit: StackFit.expand, children: [
      PageView.builder(
        controller: _controller,
        itemCount: imgs.length,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (_, i) {
          final img = buildPackageImage(imgs[i]);
          return i == 0
              ? Hero(tag: 'pkg-${widget.package.id}', child: img)
              : img;
        },
      ),
      const IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black38, Colors.transparent],
            ),
          ),
        ),
      ),
      // Tombol panah (berguna di web karena tidak bisa swipe dengan mouse).
      if (imgs.length > 1) ...[
        if (_index > 0)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: Colors.black45),
                onPressed: () => _go(_index - 1),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
            ),
          ),
        if (_index < imgs.length - 1)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: Colors.black45),
                onPressed: () => _go(_index + 1),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ),
          ),
      ],
      Positioned(
        right: 16,
        bottom: widget.inset,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.black54, borderRadius: BorderRadius.circular(14)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.photo_library_outlined,
                size: 14, color: Colors.white),
            const SizedBox(width: 5),
            Text('${_index + 1}/${imgs.length}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
          ]),
        ),
      ),
      if (imgs.length > 1)
        Positioned(
          left: 0,
          right: 0,
          bottom: widget.inset + 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < imgs.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _index ? 20 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: i == _index ? Colors.white : Colors.white54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
        ),
    ]);
  }
}

class _RatingCard extends StatelessWidget {
  final TourPackage package;
  const _RatingCard({required this.package});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(children: [
        Text(package.score.toStringAsFixed(1).replaceAll('.', ','),
            style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: cs.primary)),
        Text('/10',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(package.scoreLabel,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 16)),
              const SizedBox(height: 2),
              Text('dari ${formatReviews(package.reviews)}',
                  style: TextStyle(color: cs.primary, fontSize: 13)),
            ],
          ),
        ),
        Row(children: [
          for (var i = 0; i < 5; i++)
            Icon(
              i < package.rating.round()
                  ? Icons.star_rounded
                  : Icons.star_border_rounded,
              color: Colors.amber.shade700,
              size: 20,
            ),
        ]),
      ]),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;
  const _Title(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      );
}

class _Info extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Info(this.icon, this.text);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 5),
          Flexible(
            child: Text(text,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ]),
      );
}

class _Facility extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Facility(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 96,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        Icon(icon, color: cs.primary),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}