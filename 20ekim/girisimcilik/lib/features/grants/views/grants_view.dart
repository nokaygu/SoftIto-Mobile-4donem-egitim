import 'package:flutter/material.dart';
import '../models/grant.dart';
import '../widgets/grant_card.dart';
import '../widgets/grant_filter_bar.dart';

class GrantsView extends StatefulWidget {
  const GrantsView({super.key});

  @override
  State<GrantsView> createState() => _GrantsViewState();
}

class _GrantsViewState extends State<GrantsView> {
  GrantCategory _selectedCategory = GrantCategory.all;

  final List<Grant> _grants = [
    const Grant(
      id: 'g1',
      provider: 'KOSGEB',
      programName: 'İleri Girişimci Destek Programı',
      category: GrantCategory.kosgeb,
      maxAmount: '1.500.000 ₺',
      supportRatio: '%75 Hibe (Geri Ödemesiz)',
      deadline: 'Sürekli Açık',
      description: 'Yüksek teknoloji alanında şirket kuran girişimcilerin makine, yazılım ve personel giderleri.',
      status: GrantApplicationStatus.notApplied,
    ),
    const Grant(
      id: 'g2',
      provider: 'TÜBİTAK',
      programName: '1507 KOBİ Ar-Ge Başlangıç Programı',
      category: GrantCategory.tubitak,
      maxAmount: '2.400.000 ₺',
      supportRatio: '%75 Ar-Ge Hibesi',
      deadline: '15 Kasım 2026',
      description: 'Yeni bir ürün üretilmesi veya mevcut ürünün geliştirilmesine yönelik teknoloji projeleri.',
      status: GrantApplicationStatus.underReview,
    ),
    const Grant(
      id: 'g3',
      provider: 'Avrupa Birliği (AB)',
      programName: 'Horizon Europe EIC Accelerator',
      category: GrantCategory.international,
      maxAmount: '2.500.000 €',
      supportRatio: '%70 Hibe + Özkaynak Yatırımı',
      deadline: '4 Aralık 2026',
      description: 'Küresel pazara hitap eden derin teknoloji (DeepTech) ölçeklenme desteği.',
      status: GrantApplicationStatus.notApplied,
    ),
    const Grant(
      id: 'g4',
      provider: 'KOSGEB',
      programName: 'Ar-Ge, Ür-Ge ve İnovasyon Destek Programı',
      category: GrantCategory.kosgeb,
      maxAmount: '6.000.000 ₺',
      supportRatio: '%75 Hibe + Faizsiz Kredi',
      deadline: 'Sürekli Açık',
      description: 'Teknolojik prototip geliştirme ve ticarileştirme süreçleri.',
      status: GrantApplicationStatus.notApplied,
    ),
  ];

  void _onApply(int index) {
    setState(() {
      _grants[index] = _grants[index].copyWith(
        status: _grants[index].status == GrantApplicationStatus.notApplied
            ? GrantApplicationStatus.underReview
            : GrantApplicationStatus.notApplied,
      );
    });

    final isNowApplied = _grants[index].status == GrantApplicationStatus.underReview;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isNowApplied
              ? '${_grants[index].programName} başvurunuz doğrudan KOSGEB/TÜBİTAK portföyüne aktarıldı!'
              : 'Başvuru geri çekildi.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategory == GrantCategory.all
        ? _grants
        : _grants.where((g) => g.category == _selectedCategory).toList();

    return ListView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 100),
      children: [
        GrantFilterBar(
          selectedCategory: _selectedCategory,
          onSelect: (cat) => setState(() => _selectedCategory = cat),
        ),
        for (int i = 0; i < filtered.length; i++)
          GrantCard(
            grant: filtered[i],
            onApply: () {
              final originalIndex = _grants.indexWhere((g) => g.id == filtered[i].id);
              _onApply(originalIndex);
            },
          ),
      ],
    );
  }
}
