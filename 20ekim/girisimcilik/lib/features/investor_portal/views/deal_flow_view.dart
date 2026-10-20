import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/auth_role_controller.dart';
import '../widgets/deal_evaluation_modal.dart';
import '../widgets/deal_startup_card.dart';

class DealFlowView extends StatefulWidget {
  const DealFlowView({super.key});

  @override
  State<DealFlowView> createState() => _DealFlowViewState();
}

class _DealFlowViewState extends State<DealFlowView> {
  String _selectedFilter = 'Tümü';
  final _filters = ['Tümü', 'Yapay Zeka', 'Fintech', 'Biyoteknoloji', 'Agritech'];

  void _openEvaluation(BuildContext context, DealStartup startup) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DealEvaluationModal(startup: startup),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<DealStartup>>(
      valueListenable: AuthRoleController.instance.dealStartupsNotifier,
      builder: (context, startups, _) {
        final filtered = _selectedFilter == 'Tümü'
            ? startups
            : startups.where((s) => s.sector.contains(_selectedFilter)).toList();

        return ListView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 110),
          children: [
            _buildFilterChips(),
            const SizedBox(height: 12),
            for (final startup in filtered)
              DealStartupCard(
                startup: startup,
                onActionTap: () => _openEvaluation(context, startup),
              ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                filter,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : AppColors.darkTextSecondary,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.investorAccent,
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              side: BorderSide(
                color: isSelected ? AppColors.investorAccentLight : Colors.white.withValues(alpha: 0.12),
              ),
              onSelected: (_) => setState(() => _selectedFilter = filter),
            ),
          );
        }).toList(),
      ),
    );
  }
}
