import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/state/entrepreneur_profile_controller.dart';
import '../../onboarding/models/business_application.dart';
import '../models/legal_step.dart';
import '../models/mentor.dart';
import '../widgets/assigned_specialists_card.dart';
import '../widgets/legal_stepper_widget.dart';
import '../widgets/mentor_card.dart';

class MentorsLegalView extends StatefulWidget {
  const MentorsLegalView({super.key});

  @override
  State<MentorsLegalView> createState() => _MentorsLegalViewState();
}

class _MentorsLegalViewState extends State<MentorsLegalView> {
  final List<LegalStep> _steps = [
    const LegalStep(
      id: '1',
      title: 'Esas Sözleşme & Şirket Türü Seçimi',
      description: 'Avukatınız ile Anonim Şirket (A.Ş.) esas mukavelesi hazırlandı.',
      isCompleted: true,
    ),
    const LegalStep(
      id: '2',
      title: 'MERSİS Başvurusu ve Ticaret Sicil Randevusu',
      description: 'Ticaret Odası potansiyel vergi kimlik numarası alındı.',
      isCompleted: true,
    ),
    const LegalStep(
      id: '3',
      title: 'Banka Sermaye Bloke Dekontu (%25)',
      description: 'Kurucu sermaye payının bankaya yatırılması.',
      isCompleted: false,
    ),
    const LegalStep(
      id: '4',
      title: 'Vergi Dairesi Yoklaması & e-Tebligat',
      description: 'Mali müşaviriniz eşliğinde vergi levhası onayı.',
      isCompleted: false,
    ),
    const LegalStep(
      id: '5',
      title: 'İmza Sirküleri ve Ortaklar Sözleşmesi (SHA)',
      description: 'Noter tasdiki ve yatırımcı koruma maddeleri.',
      isCompleted: false,
    ),
  ];

  final List<Mentor> _mentors = const [
    Mentor(
      id: 'm1',
      name: 'Canan Özdemir',
      title: 'Eski VC Partneri & Seri Girişimci',
      company: 'ScaleX Capital',
      expertise: 'Yatırım Hazırlığı & Değerleme',
      rating: 4.9,
      sessionsCount: 38,
    ),
    Mentor(
      id: 'm2',
      name: 'Burak Tan',
      title: 'Growth & Ürün Lideri',
      company: 'Getir Global',
      expertise: 'B2B Büyüme & Pazar Giriş Stratejisi',
      rating: 4.8,
      sessionsCount: 52,
    ),
    Mentor(
      id: 'm3',
      name: 'Doç. Dr. Kerem Aydın',
      title: 'Teknoloji Transfer Ofisi Direktörü',
      company: 'İTÜ ARI Teknokent',
      expertise: 'TÜBİTAK 1507 & Ar-Ge Hibeleri',
      rating: 5.0,
      sessionsCount: 64,
    ),
  ];

  void _toggleStep(int index) {
    setState(() {
      _steps[index] = _steps[index].copyWith(
        isCompleted: !_steps[index].isCompleted,
      );
    });
  }

  void _bookMentor(Mentor mentor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${mentor.name} ile birebir mentorluk seansı planlandı!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<BusinessApplication>(
      valueListenable: EntrepreneurProfileController.instance.applicationNotifier,
      builder: (context, app, _) {
        return ListView(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 100),
          children: [
            AssignedSpecialistsCard(application: app),
            const SizedBox(height: 18),
            LegalStepperWidget(
              steps: _steps,
              onToggleStep: _toggleStep,
            ),
            const SizedBox(height: 22),
            _buildMentorsSectionHeader(isDark),
            const SizedBox(height: 12),
            for (final mentor in _mentors)
              MentorCard(
                mentor: mentor,
                onBook: () => _bookMentor(mentor),
              ),
          ],
        );
      },
    );
  }

  Widget _buildMentorsSectionHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Sektörel Mentorlar',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        Text(
          '3 Müsait',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
