import 'package:flutter/material.dart';
import '../models/investor.dart';
import '../widgets/investor_card.dart';
import '../widgets/investor_filter_bar.dart';
import '../widgets/pitch_bottom_sheet.dart';

class InvestorsView extends StatefulWidget {
  const InvestorsView({super.key});

  @override
  State<InvestorsView> createState() => _InvestorsViewState();
}

class _InvestorsViewState extends State<InvestorsView> {
  InvestorType? _selectedType;

  final List<Investor> _investors = [
    const Investor(
      id: 'inv1',
      name: 'Nevzat Aydın',
      type: InvestorType.angel,
      fundName: 'Bireysel Melek Yatırımcı / Galata Business Angels',
      focusSectors: ['SaaS', 'E-Ticaret', 'Fintech', 'Yapay Zeka'],
      ticketSize: '1.000.000 ₺ - 4.000.000 ₺',
      portfolioCount: 42,
      isMatched: false,
    ),
    const Investor(
      id: 'inv2',
      name: 'ScaleX Ventures',
      type: InvestorType.vc,
      fundName: 'Erken Aşama & Seri A Teknoloji Fonu',
      focusSectors: ['Derin Teknoloji', 'Yapay Zeka', 'B2B SaaS'],
      ticketSize: '5.000.000 ₺ - 20.000.000 ₺',
      portfolioCount: 28,
      isMatched: false,
    ),
    const Investor(
      id: 'inv3',
      name: 'Hande Enes',
      type: InvestorType.angel,
      fundName: 'TR Angels & Arya Women Investment',
      focusSectors: ['HealthTech', 'Fintech', 'Yapay Zeka'],
      ticketSize: '750.000 ₺ - 2.500.000 ₺',
      portfolioCount: 35,
      isMatched: true,
    ),
    const Investor(
      id: 'inv4',
      name: '212 Capital Partners',
      type: InvestorType.vc,
      fundName: 'Bölgesel Büyüme & VC Fonu',
      focusSectors: ['Fintech', 'Siber Güvenlik', 'B2B Yazılım'],
      ticketSize: '10.000.000 ₺+',
      portfolioCount: 31,
      isMatched: false,
    ),
  ];

  void _onPitchSent(int index) {
    setState(() {
      _investors[index] = _investors[index].copyWith(isMatched: true);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${_investors[index].name} yatırımcısına sunumunuz başarıyla iletildi!')),
    );
  }

  void _openPitchSheet(int index) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PitchBottomSheet(
        investor: _investors[index],
        onSent: () => _onPitchSent(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _selectedType == null
        ? _investors
        : _investors.where((i) => i.type == _selectedType).toList();

    return ListView(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 100),
      children: [
        InvestorFilterBar(
          selectedType: _selectedType,
          onSelect: (type) => setState(() => _selectedType = type),
        ),
        for (int i = 0; i < filteredList.length; i++)
          InvestorCard(
            investor: filteredList[i],
            onSendPitch: () {
              final originalIndex = _investors.indexWhere((inv) => inv.id == filteredList[i].id);
              _openPitchSheet(originalIndex);
            },
            onContact: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${filteredList[i].name} ile doğrudan mesaj kanalı açıldı.')),
              );
            },
          ),
      ],
    );
  }
}
