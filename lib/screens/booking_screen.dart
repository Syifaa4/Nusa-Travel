import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/tour_package.dart';

class BookingScreen extends StatefulWidget {
  final TourPackage package;
  const BookingScreen({super.key, required this.package});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameC = TextEditingController();
  final _countC = TextEditingController(text: '1');
  final _dateC = TextEditingController();
  DateTime? _date;

  @override
  void dispose() {
    _nameC.dispose();
    _countC.dispose();
    _dateC.dispose();
    super.dispose();
  }

  int get _count => int.tryParse(_countC.text) ?? 0;
  int get _total => widget.package.price * _count;

  void _changeCount(int delta) {
    final next = (_count + delta).clamp(1, 20);
    setState(() => _countC.text = next.toString());
  }

  void _setDate(DateTime d) => setState(() {
        _date = d;
        _dateC.text = formatTanggal(d);
      });

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      helpText: 'Pilih tanggal keberangkatan',
    );
    if (picked != null) _setDate(picked);
  }

  /// Dialog konfirmasi saat pengguna menekan tombol Back.
  Future<void> _confirmExit() async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: const Icon(Icons.warning_amber_rounded,
            size: 40, color: Colors.orange),
        title: const Text('Batalkan pemesanan?'),
        content: const Text(
            'Data yang sudah Anda isi akan hilang jika keluar dari halaman ini.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Lanjut Mengisi')),
          FilledButton(
            style: FilledButton.styleFrom(
                minimumSize: const Size(96, 44), backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (leave == true && mounted) Navigator.pop(context); // result = null
  }

  /// Validasi form -> tampilkan rincian pembayaran -> kirim hasil jika setuju.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final p = widget.package;
    final cs = Theme.of(context).colorScheme;
    final saving = p.originalPrice == null
        ? 0
        : (p.originalPrice! - p.price) * _count;

    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      constraints: const BoxConstraints(maxWidth: 560),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Rincian Pembayaran',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              Text(p.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 10),
              _SummaryRow('Pemesan', _nameC.text.trim()),
              _SummaryRow('Tanggal berangkat', formatTanggal(_date!)),
              _SummaryRow('Durasi', p.duration),
              const Divider(height: 26),
              _SummaryRow('Harga / orang', formatRupiah(p.price)),
              _SummaryRow('Jumlah peserta', '$_count orang'),
              if (saving > 0)
                _SummaryRow('Anda hemat', '- ${formatRupiah(saving)}',
                    valueColor: Colors.green.shade700),
              const Divider(height: 26),
              _SummaryRow('Total Pembayaran', formatRupiah(_total),
                  bold: true, valueColor: cs.primary),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Ubah'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Pesan Sekarang'),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && mounted) {
      Navigator.pop(
        context,
        BookingResult(
          package: p,
          name: _nameC.text.trim(),
          participants: _count,
          date: _date!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.package;
    final cs = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _confirmExit();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Form Pemesanan',
              style: TextStyle(fontWeight: FontWeight.w800)),
          backgroundColor: cs.primary,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cs.primary.withAlpha(22),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(children: [
                        Icon(Icons.card_travel_rounded,
                            color: cs.primary, size: 30),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15)),
                              const SizedBox(height: 2),
                              Text('${formatRupiah(p.price)} / orang',
                                  style:
                                      TextStyle(color: Colors.grey.shade700)),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    const SizedBox(height: 24),
                    const _Label('Nama Lengkap'),
                    TextFormField(
                      controller: _nameC,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Masukkan nama pemesan',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Nama wajib diisi';
                        }
                        if (v.trim().length < 3) {
                          return 'Nama minimal 3 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    const _Label('Jumlah Peserta'),
                    TextFormField(
                      controller: _countC,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: '1 - 20',
                        prefixIcon: const Icon(Icons.group_outlined),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () => _changeCount(-1),
                                icon: const Icon(Icons.remove_circle_outline)),
                            IconButton(
                                onPressed: () => _changeCount(1),
                                icon: const Icon(Icons.add_circle_outline)),
                          ],
                        ),
                      ),
                      validator: (v) {
                        final n = int.tryParse(v ?? '');
                        if (n == null) return 'Jumlah peserta wajib diisi';
                        if (n < 1 || n > 20) {
                          return 'Jumlah peserta 1 - 20 orang';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    const _Label('Tanggal Keberangkatan'),
                    TextFormField(
                      controller: _dateC,
                      readOnly: true,
                      onTap: _pickDate,
                      decoration: const InputDecoration(
                        hintText: 'Pilih tanggal',
                        prefixIcon: Icon(Icons.calendar_month_outlined),
                      ),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Tanggal keberangkatan wajib dipilih'
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Wrap(spacing: 8, children: [
                      for (final e
                          in {'Besok': 1, '+7 hari': 7, '+14 hari': 14}.entries)
                        ActionChip(
                          label: Text(e.key),
                          onPressed: () => _setDate(
                              DateTime.now().add(Duration(days: e.value))),
                        ),
                    ]),
                    const SizedBox(height: 26),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Total Pembayaran',
                                  style: TextStyle(fontSize: 13)),
                              Text('$_count peserta',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600)),
                            ],
                          ),
                          Text(formatRupiah(_total),
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w800,
                                  color: cs.primary)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    FilledButton(
                        onPressed: _submit,
                        child: const Text('Konfirmasi Pesanan')),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      );
}

/// Satu baris "label ........ nilai" untuk pop-up rincian pembayaran.
class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;
  const _SummaryRow(this.label, this.value,
      {this.bold = false, this.valueColor});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: bold ? null : Colors.grey.shade700,
                    fontWeight: bold ? FontWeight.w800 : FontWeight.w500)),
            const SizedBox(width: 16),
            Flexible(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
                      fontSize: bold ? 18 : 14,
                      color: valueColor)),
            ),
          ],
        ),
      );
}