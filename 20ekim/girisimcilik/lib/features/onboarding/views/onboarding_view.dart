import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/entrepreneur_profile_controller.dart';
import '../../../core/widgets/ambient_background.dart';
import '../../../core/widgets/liquid_glass_container.dart';
import '../models/business_application.dart';
import '../widgets/has_plan_form.dart';
import '../widgets/no_plan_form.dart';
import '../widgets/plan_choice_card.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  BusinessPlanStatus _selectedStatus = BusinessPlanStatus.hasPlan;

  @override
  void initState() {
    super.initState();
    _selectedStatus =
        EntrepreneurProfileController.instance.currentApplication.planStatus;
  }

  void _onSaveSuccess() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        content: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A).withValues(alpha: 0.95) : Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (isDark ? AppColors.darkSuccess : AppColors.lightSuccess).withValues(alpha: 0.3),
                blurRadius: 20,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (isDark ? AppColors.darkSuccess : AppColors.lightSuccess).withValues(alpha: 0.20),
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: isDark ? AppColors.darkSuccess : AppColors.lightSuccess,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Başvuru Alındı',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: isDark ? Colors.white : AppColors.lightTextPrimary,
                      ),
                    ),
                    Text(
                      'İş planınız güncellendi ve uzman incelemesine alındı!',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: isDark ? const Color(0xFFE2E8F0) : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AmbientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Girişim Başvurusu & Plan'),
          actions: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ],
        ),
        body: SafeArea(
          child: ValueListenableBuilder<BusinessApplication>(
            valueListenable:
                EntrepreneurProfileController.instance.applicationNotifier,
            builder: (context, app, _) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildIntroCard(isDark),
                    const SizedBox(height: 18),
                    _buildChoiceCards(),
                    const SizedBox(height: 20),
                    if (_selectedStatus == BusinessPlanStatus.hasPlan)
                      HasPlanForm(initialApp: app, onSaved: _onSaveSuccess)
                    else
                      NoPlanForm(initialApp: app, onSaved: _onSaveSuccess),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildIntroCard(bool isDark) {
    return LiquidGlassContainer(
      borderRadius: BorderRadius.circular(24),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.darkAccent : AppColors.lightAccent)
                      .withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.rocket_launch_rounded,
                  color: isDark ? AppColors.darkAccent : AppColors.lightAccent,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Girişimci Yol Haritası',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'İş planınızın olup olmamasına göre size en uygun danışmanlık, avukat, mali müşavir ve yatırımcı eşleşmelerini kurguluyoruz.',
            style: TextStyle(
              fontSize: 13.5,
              height: 1.45,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceCards() {
    return Column(
      children: [
        PlanChoiceCard(
          title: 'İş Planım Var',
          subtitle: 'Projem net, ekibim veya şirketleşme aşaması hazır.',
          icon: Icons.assignment_turned_in_rounded,
          isSelected: _selectedStatus == BusinessPlanStatus.hasPlan,
          onTap: () => setState(() => _selectedStatus = BusinessPlanStatus.hasPlan),
        ),
        const SizedBox(height: 12),
        PlanChoiceCard(
          title: 'İş Planım Yok / Fikir Aşamasındayım',
          subtitle: 'Rehberliğe, şirketleşme desteğine ve mentora ihtiyacım var.',
          icon: Icons.lightbulb_rounded,
          isSelected: _selectedStatus == BusinessPlanStatus.noPlan,
          onTap: () => setState(() => _selectedStatus = BusinessPlanStatus.noPlan),
        ),
      ],
    );
  }
}
