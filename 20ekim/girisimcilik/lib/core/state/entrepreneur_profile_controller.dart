import 'package:flutter/material.dart';
import '../../features/onboarding/models/business_application.dart';
import '../../features/onboarding/models/team_member.dart';

/// Girişimcinin durumunu, başvuru bilgilerini ve onay simülasyonunu
/// harici paket olmadan ValueNotifier ile yöneten reaktif kontrolcü.
final class EntrepreneurProfileController {
  EntrepreneurProfileController._() {
    _initializeDefaultState();
  }
  static final EntrepreneurProfileController instance =
      EntrepreneurProfileController._();

  late final ValueNotifier<BusinessApplication> applicationNotifier;

  void _initializeDefaultState() {
    applicationNotifier = ValueNotifier<BusinessApplication>(
      const BusinessApplication(
        founderName: 'Arda Yılmaz',
        startupName: 'NovaTech AI',
        planStatus: BusinessPlanStatus.hasPlan,
        reviewStatus: ApplicationReviewStatus.underReview,
        sector: 'Yapay Zeka & Derin Teknoloji',
        summary:
            'Girişimler için otonom regülasyon ve finansal uyumluluk asistanı platformu.',
        financialNeed: '2.500.000 ₺ Tohum Öncesi (Pre-Seed)',
        teamMembers: [
          TeamMember(
            id: '1',
            name: 'Arda Yılmaz',
            role: 'Kurucu Ortak & CEO',
            responsibilities: 'İş Geliştirme, Ürün Vizyonu ve Yatırımcı İlişkileri',
          ),
          TeamMember(
            id: '2',
            name: 'Elif Demir',
            role: 'Kurucu Ortak & CTO',
            responsibilities: 'Yapay Zeka Mimarisi ve Altyapı Yönetimi',
          ),
          TeamMember(
            id: '3',
            name: 'Mert Aksoy',
            role: 'Kıdemli Mobil Geliştirici',
            responsibilities: 'Flutter & iOS İstemci Mimarisi',
          ),
        ],
        needsMentorship: true,
        assignedLawyer: null,
        assignedAccountant: null,
      ),
    );
  }

  BusinessApplication get currentApplication => applicationNotifier.value;
  bool get isApproved => currentApplication.isApproved;

  /// Üst bardaki "Uzman Onayını Simüle Et (Onayla / Beklet)" anahtarı
  void toggleApprovalSimulation() {
    final current = applicationNotifier.value;
    if (current.isApproved) {
      // Bekletme durumuna geri al
      applicationNotifier.value = current.copyWith(
        reviewStatus: ApplicationReviewStatus.underReview,
        assignedLawyer: null,
        assignedAccountant: null,
      );
    } else {
      // Uzman onayladı: Onaylı girişimci rozeti, avukat ve mali müşavir ata
      applicationNotifier.value = current.copyWith(
        reviewStatus: ApplicationReviewStatus.approved,
        assignedLawyer: 'Av. Selin Kaya (Kıdemli Teknoloji & Start-up Hukukçusu)',
        assignedAccountant:
            'SMMM Emre Demir (Girişimci & Teknokent Finans Danışmanı)',
      );
    }
  }

  /// Ekip tablosuna yeni üye ekleme
  void addTeamMember(TeamMember member) {
    final current = applicationNotifier.value;
    final updatedList = List<TeamMember>.from(current.teamMembers)..add(member);
    applicationNotifier.value = current.copyWith(teamMembers: updatedList);
  }

  /// Ekip tablosundan üye silme
  void removeTeamMember(String id) {
    final current = applicationNotifier.value;
    final updatedList =
        current.teamMembers.where((m) => m.id != id).toList();
    applicationNotifier.value = current.copyWith(teamMembers: updatedList);
  }

  /// Başvuru formunu güncelleme
  void updateApplication({
    required String startupName,
    required String sector,
    required String summary,
    required String financialNeed,
    required BusinessPlanStatus planStatus,
  }) {
    final current = applicationNotifier.value;
    applicationNotifier.value = current.copyWith(
      startupName: startupName,
      sector: sector,
      summary: summary,
      financialNeed: financialNeed,
      planStatus: planStatus,
      reviewStatus: ApplicationReviewStatus.underReview,
    );
  }
}
