class TourPackage {
  final int id;
  final String title;
  final String description;
  final int price; // harga per orang (Rupiah)
  final String imageUrl;

  // Informasi tambahan untuk memperkaya tampilan.
  final String location;
  final String duration;
  final double rating;
  final int reviews;
  final String category; // Alam, Bahari, Budaya
  final int? originalPrice; // harga coret (opsional)
  final List<String> images; // galeri foto (opsional)
  final List<String> highlights; // poin pengalaman
  final String openingHours;
  final List<String> tags;

  const TourPackage({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.location = 'Indonesia',
    this.duration = '3 Hari 2 Malam',
    this.rating = 4.8,
    this.reviews = 0,
    this.category = 'Alam',
    this.originalPrice,
    this.images = const [],
    this.highlights = const [],
    this.openingHours = 'Setiap hari',
    this.tags = const [],
  });

  /// Daftar foto untuk carousel; minimal berisi foto utama.
  List<String> get gallery => images.isEmpty ? [imageUrl] : images;

  /// Skor skala 10 (rating 5 x 2).
  double get score => rating * 2;

  String get scoreLabel =>
      score >= 9.5 ? 'Luar Biasa' : (score >= 9 ? 'Sangat Baik' : 'Baik');

  int? get discountPercent => originalPrice == null
      ? null
      : (((originalPrice! - price) / originalPrice!) * 100).round();

  static const List<TourPackage> samples = [
    TourPackage(
      id: 1,
      title: 'Pesona Bali Ubud & Uluwatu',
      description:
          'Jelajahi sawah terasering Tegallalang, Monkey Forest, Pura Uluwatu, dan nikmati sunset di Pantai Jimbaran. Termasuk hotel bintang 4, transportasi pribadi, dan pemandu berbahasa Indonesia.',
      price: 3250000,
      imageUrl: 'assets/images/bali.jpg',
      images: ['assets/images/bali.jpg', 'assets/images/bali_2.jpg', 'assets/images/bali_3.jpg'],
      highlights: [
        'Menyusuri sawah terasering Tegallalang yang ikonik',
        'Bertemu kera jinak di Sacred Monkey Forest Ubud',
        'Menonton tarian Kecak saat matahari terbenam di Uluwatu',
        'Makan malam seafood di tepi Pantai Jimbaran',
        'Hotel bintang 4 dan transportasi pribadi sepanjang trip',
      ],
      openingHours: '07.00 - 20.00 WITA',
      tags: ['Reschedule Mudah', 'Pemandu Lokal'],
      location: 'Bali',
      duration: '4 Hari 3 Malam',
      rating: 4.9,
      reviews: 21100,
      category: 'Budaya',
      originalPrice: 3750000,
    ),
    TourPackage(
      id: 2,
      title: 'Bromo Sunrise Adventure',
      description:
          'Saksikan matahari terbit dari Penanjakan, naik jeep melintasi lautan pasir, dan berdiri di tepi kawah Gunung Bromo. Cocok untuk pecinta alam dan fotografi.',
      price: 1850000,
      imageUrl: 'assets/images/bromo.jpg',
      images: ['assets/images/bromo.jpg', 'assets/images/bromo_2.jpg', 'assets/images/bromo_3.jpg'],
      highlights: [
        'Melihat matahari terbit dari Penanjakan 1',
        'Jeep 4x4 melintasi lautan pasir Bromo',
        'Berdiri di bibir kawah dan melihat asap belerang',
        'Foto di savana Bukit Teletubbies',
        'Sarapan hangat setelah turun gunung',
      ],
      openingHours: '02.30 - 12.00 WIB',
      tags: ['Best Seller', 'Jeep Termasuk'],
      location: 'Jawa Timur',
      duration: '2 Hari 1 Malam',
      rating: 4.7,
      reviews: 8400,
      category: 'Alam',
    ),
    TourPackage(
      id: 3,
      title: 'Raja Ampat Island Hopping',
      description:
          'Snorkeling di surga bawah laut dunia, kunjungi Pianemo dan Wayag, serta menginap di homestay tepi pantai. Termasuk speedboat dan peralatan snorkeling.',
      price: 8900000,
      imageUrl: 'assets/images/raja_ampat.jpg',
      images: ['assets/images/raja_ampat.jpg', 'assets/images/raja_ampat_2.jpg', 'assets/images/raja_ampat_3.jpg'],
      highlights: [
        'Snorkeling di antara terumbu karang warna-warni',
        'Trekking ke puncak Wayag dan Pianemo',
        'Berenang dengan ikan pari manta',
        'Menginap di homestay tepi pantai',
        'Speedboat dan alat snorkeling disediakan',
      ],
      openingHours: 'Jadwal menyesuaikan pasang surut',
      tags: ['Eksklusif', 'Reschedule Mudah'],
      location: 'Papua Barat',
      duration: '5 Hari 4 Malam',
      rating: 5.0,
      reviews: 3200,
      category: 'Bahari',
      originalPrice: 9900000,
    ),
    TourPackage(
      id: 4,
      title: 'Borobudur & Yogyakarta Heritage',
      description:
          'Sunrise di Candi Borobudur, Keraton Yogyakarta, Prambanan, dan kuliner khas Malioboro. Perjalanan budaya yang berkesan untuk keluarga.',
      price: 2150000,
      imageUrl: 'assets/images/borobudur.jpg',
      images: ['assets/images/borobudur.jpg', 'assets/images/borobudur_2.jpg', 'assets/images/borobudur_3.jpg'],
      highlights: [
        'Naik ke Candi Borobudur saat matahari terbit',
        'Mengunjungi Keraton dan Taman Sari Yogyakarta',
        'Menjelajahi kompleks Candi Prambanan',
        'Mencicipi gudeg dan jajanan khas Malioboro',
        'Cocok untuk keluarga dan semua usia',
      ],
      openingHours: '06.00 - 17.00 WIB',
      tags: ['Ramah Keluarga', 'Pemandu Lokal'],
      location: 'Yogyakarta',
      duration: '3 Hari 2 Malam',
      rating: 4.8,
      reviews: 12600,
      category: 'Budaya',
    ),
    TourPackage(
      id: 5,
      title: 'Labuan Bajo & Pulau Komodo',
      description:
          'Berlayar dengan kapal phinisi, trekking Pulau Padar, bertemu komodo, dan berenang bersama manta di Manta Point.',
      price: 6400000,
      imageUrl: 'assets/images/komodo.jpg',
      images: ['assets/images/komodo.jpg', 'assets/images/komodo_2.jpg', 'assets/images/komodo_3.jpg'],
      highlights: [
        'Berlayar dengan kapal phinisi mengelilingi pulau',
        'Trekking ke puncak Pulau Padar',
        'Melihat komodo dari dekat bersama ranger',
        'Berenang di Manta Point dan Pantai Pink',
        'Makan di atas kapal dengan hidangan laut segar',
      ],
      openingHours: 'Berangkat 07.00 WITA',
      tags: ['Best Seller', 'Kapal Phinisi'],
      location: 'Nusa Tenggara Timur',
      duration: '4 Hari 3 Malam',
      rating: 4.9,
      reviews: 5800,
      category: 'Bahari',
      originalPrice: 7200000,
    ),
    TourPackage(
      id: 6,
      title: 'Danau Toba & Samosir Escape',
      description:
          'Menyeberang ke Pulau Samosir, mengenal budaya Batak di Tomok, dan menikmati panorama danau vulkanik terbesar di dunia dari Bukit Holbung.',
      price: 2750000,
      imageUrl: 'assets/images/danau_toba.jpg',
      images: ['assets/images/danau_toba.jpg', 'assets/images/danau_toba_2.jpg', 'assets/images/danau_toba_3.jpg'],
      highlights: [
        'Menyeberang ke Pulau Samosir dengan kapal kayu',
        'Mengenal budaya Batak di Tomok dan Ambarita',
        'Panorama danau dari Bukit Holbung',
        'Menikmati ikan arsik khas Batak',
        'Penginapan dengan pemandangan danau',
      ],
      openingHours: '08.00 - 18.00 WIB',
      tags: ['Pemandu Lokal'],
      location: 'Sumatera Utara',
      duration: '3 Hari 2 Malam',
      rating: 4.6,
      reviews: 2900,
      category: 'Alam',
    ),
  ];
}

/// Hasil pemesanan yang dikembalikan oleh BookingScreen melalui Navigator.pop().
class BookingResult {
  final TourPackage package;
  final String name;
  final int participants;
  final DateTime date;

  const BookingResult({
    required this.package,
    required this.name,
    required this.participants,
    required this.date,
  });

  int get total => package.price * participants;
}

String formatRupiah(int value) {
  final s = value.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp $buf';
}

String formatTanggal(DateTime d) {
  const bulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
  ];
  return '${d.day} ${bulan[d.month - 1]} ${d.year}';
}

String formatReviews(int n) =>
    n >= 1000 ? '${(n / 1000).toStringAsFixed(1)}k ulasan' : '$n ulasan';
