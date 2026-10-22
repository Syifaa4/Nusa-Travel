import 'package:flutter/material.dart';

import '../models/tour_package.dart';
import '../routes/app_routes.dart';

/// Gambar paket dari assets, dengan fallback gradasi jika file belum ada.
Widget buildPackageImage(String path, {BoxFit fit = BoxFit.cover}) {
  return Image.asset(
    path,
    fit: fit,
    errorBuilder: (context, error, stack) => Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF173A74), Color(0xFF2F6DB5)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.landscape_rounded, color: Colors.white70, size: 48),
      ),
    ),
  );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _categories = ['Semua', 'Alam', 'Bahari', 'Budaya'];
  static const double _maxContent = 1100;
  static const double _gap = 20;

  final _searchC = TextEditingController();
  String _query = '';
  String _category = 'Semua';
  final Set<int> _saved = {};

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Keluar dari aplikasi?'),
        content: const Text('Anda akan kembali ke halaman awal.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(
                minimumSize: const Size(96, 44), backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      Navigator.pushNamedAndRemoveUntil(
          context, AppRoutes.splash, (route) => false);
    }
  }

  List<TourPackage> _filtered() {
    final q = _query.trim().toLowerCase();
    return TourPackage.samples.where((p) {
      final okCat = _category == 'Semua' || p.category == _category;
      if (!okCat) return false;
      if (q.isEmpty) return true;
      final haystack = [
        p.title,
        p.location,
        p.category,
        p.description,
        ...p.tags,
      ].join(' ').toLowerCase();
      return haystack.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final w = MediaQuery.sizeOf(context).width;

    // Lebar konten & margin samping (rata tengah di layar lebar).
    final contentW = w > _maxContent + 40 ? _maxContent : w - 40;
    final pad = (w - contentW) / 2;

    // Jumlah kolom mengikuti lebar layar.
    final cols = w >= 900 ? 3 : (w >= 600 ? 2 : 1);
    final cardW = (contentW - _gap * (cols - 1)) / cols;
    // Tinggi kartu = tinggi gambar (rasio 16:10) + area teks.
    final cardH = cardW * 10 / 16 + 172;

    final items = _filtered();
    final q = _query.trim();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: cs.primary,
            foregroundColor: Colors.white,
            automaticallyImplyLeading: false,
            centerTitle: false,
            titleSpacing: pad,
            title: const Text('NusaTravel',
                style: TextStyle(fontWeight: FontWeight.w800)),
            actions: [
              TextButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout_rounded,
                    color: Colors.white, size: 20),
                label: const Text('Logout',
                    style: TextStyle(color: Colors.white)),
              ),
              SizedBox(width: pad > 14 ? pad - 8 : 6),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.fromLTRB(pad, 4, pad, 24),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(24)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Halo, Traveler! 👋',
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 2),
                  const Text('Mau liburan ke mana?',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(height: 14),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: TextField(
                      controller: _searchC,
                      onChanged: (v) => setState(() => _query = v),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Cari destinasi atau paket...',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                icon: const Icon(Icons.close_rounded),
                                onPressed: () {
                                  _searchC.clear();
                                  setState(() => _query = '');
                                },
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.fromLTRB(pad, 14, pad, 4),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) => ChoiceChip(
                  label: Text(_categories[i]),
                  selected: _category == _categories[i],
                  showCheckmark: false,
                  selectedColor: cs.primary,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _category == _categories[i]
                        ? Colors.white
                        : cs.primary,
                  ),
                  onSelected: (_) =>
                      setState(() => _category = _categories[i]),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(pad, 8, pad, 6),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      q.isEmpty ? 'Paket Wisata Populer' : 'Hasil untuk "$q"',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('${items.length} paket',
                      style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          ),
          if (items.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 8),
                    const Text('Paket tidak ditemukan'),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(pad, 10, pad, 32),
              sliver: SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: _gap,
                  mainAxisSpacing: _gap,
                  mainAxisExtent: cardH,
                ),
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final p = items[i];
                  return _PackageCard(
                    package: p,
                    saved: _saved.contains(p.id),
                    onSave: () => setState(() {
                      _saved.contains(p.id)
                          ? _saved.remove(p.id)
                          : _saved.add(p.id);
                    }),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final TourPackage package;
  final bool saved;
  final VoidCallback onSave;
  const _PackageCard({
    required this.package,
    required this.saved,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final p = package;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () =>
            Navigator.pushNamed(context, AppRoutes.detail, arguments: p),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'pkg-${p.id}',
                    child: buildPackageImage(p.imageUrl),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _Pill(
                      icon: Icons.place_rounded,
                      text: p.location,
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: IconButton(
                      tooltip: 'Simpan',
                      onPressed: onSave,
                      visualDensity: VisualDensity.compact,
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withAlpha(235)),
                      icon: Icon(
                        saved
                            ? Icons.bookmark_rounded
                            : Icons.bookmark_border_rounded,
                        size: 20,
                        color: cs.primary,
                      ),
                    ),
                  ),
                  if (p.discountPercent != null)
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: cs.tertiary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('Hemat ${p.discountPercent}%',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 11.5)),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 15.5,
                          height: 1.25,
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Row(children: [
                      Text('${p.score.toStringAsFixed(1)}/10',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: cs.primary)),
                      Flexible(
                        child: Text(' • ${formatReviews(p.reviews)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12.5, color: Colors.grey.shade600)),
                      ),
                    ]),
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(Icons.schedule_rounded,
                          size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      Text(p.duration,
                          style: TextStyle(
                              fontSize: 12.5, color: Colors.grey.shade700)),
                    ]),
                    const Spacer(),
                    if (p.originalPrice != null)
                      Text(formatRupiah(p.originalPrice!),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                              decoration: TextDecoration.lineThrough))
                    else
                      Text('Mulai dari',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600)),
                    Text(formatRupiah(p.price),
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: cs.tertiary)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Pill({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.black54, borderRadius: BorderRadius.circular(20)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700)),
        ]),
      );
}