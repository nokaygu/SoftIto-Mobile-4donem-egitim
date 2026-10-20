import 'package:flutter/material.dart';
import 'entrepreneur_profile_controller.dart';

/// Kullanıcı rolleri: Girişimci (Yatırım Alan), Yatırımcı (Melek & Fon), Admin (Sistem & Denetçi)
enum UserRole {
  entrepreneur,
  investor,
  admin,
}

/// Yatırımcı için girişim başvurusu değerlendirme durumu
enum PitchEvaluationStatus {
  none,
  pending,
  reviewing,
  meetingScheduled,
  termSheetSent,
  invested,
}

/// Yatırım arayan girişim modeli (Deal Flow)
class DealStartup {
  const DealStartup({
    required this.id,
    required this.name,
    required this.founder,
    required this.sector,
    required this.stage,
    required this.fundingGoal,
    required this.equityOffered,
    required this.valuation,
    required this.summary,
    required this.hasPitchDeck,
    required this.isApprovedByAdmin,
    this.evaluationStatus = PitchEvaluationStatus.none,
    this.investorNotes = '',
  });

  final String id;
  final String name;
  final String founder;
  final String sector;
  final String stage;
  final String fundingGoal;
  final String equityOffered;
  final String valuation;
  final String summary;
  final bool hasPitchDeck;
  final bool isApprovedByAdmin;
  final PitchEvaluationStatus evaluationStatus;
  final String investorNotes;

  DealStartup copyWith({
    PitchEvaluationStatus? evaluationStatus,
    String? investorNotes,
    bool? isApprovedByAdmin,
  }) {
    return DealStartup(
      id: id,
      name: name,
      founder: founder,
      sector: sector,
      stage: stage,
      fundingGoal: fundingGoal,
      equityOffered: equityOffered,
      valuation: valuation,
      summary: summary,
      hasPitchDeck: hasPitchDeck,
      isApprovedByAdmin: isApprovedByAdmin ?? this.isApprovedByAdmin,
      evaluationStatus: evaluationStatus ?? this.evaluationStatus,
      investorNotes: investorNotes ?? this.investorNotes,
    );
  }
}

/// Yatırımcı doğrulama / akreditasyon talep modeli (Admin için)
class InvestorVerificationItem {
  const InvestorVerificationItem({
    required this.id,
    required this.name,
    required this.type,
    required this.organization,
    required this.ticketSize,
    required this.isVerified,
    required this.requestDate,
  });

  final String id;
  final String name;
  final String type;
  final String organization;
  final String ticketSize;
  final bool isVerified;
  final String requestDate;

  InvestorVerificationItem copyWith({bool? isVerified}) {
    return InvestorVerificationItem(
      id: id,
      name: name,
      type: type,
      organization: organization,
      ticketSize: ticketSize,
      isVerified: isVerified ?? this.isVerified,
      requestDate: requestDate,
    );
  }
}

/// Sistem denetim günlüğü kaydı
class SystemAuditLog {
  const SystemAuditLog({
    required this.id,
    required this.action,
    required this.target,
    required this.actor,
    required this.time,
    required this.isImportant,
  });

  final String id;
  final String action;
  final String target;
  final String actor;
  final String time;
  final bool isImportant;
}

/// Rol tabanlı kimlik ve erişim kontrolcüsü (Harici paketsiz ValueNotifier)
final class AuthRoleController {
  AuthRoleController._() {
    _initializeData();
  }

  static final AuthRoleController instance = AuthRoleController._();

  /// Aktif seçili rol (Varsayılan olarak null başlatılabilir veya rol seçilebilir)
  final ValueNotifier<UserRole?> activeRoleNotifier = ValueNotifier<UserRole?>(null);

  /// Yatırımcı havuzu için girişimler (Deal Flow)
  late final ValueNotifier<List<DealStartup>> dealStartupsNotifier;

  /// Admin için doğrulanacak yatırımcılar listesi
  late final ValueNotifier<List<InvestorVerificationItem>> investorVerificationsNotifier;

  /// Admin denetim günlüğü
  late final ValueNotifier<List<SystemAuditLog>> auditLogsNotifier;

  UserRole? get currentRole => activeRoleNotifier.value;

  void _initializeData() {
    dealStartupsNotifier = ValueNotifier<List<DealStartup>>([
      const DealStartup(
        id: 'startup-1',
        name: 'NovaTech AI',
        founder: 'Arda Yılmaz',
        sector: 'Yapay Zeka & RegTech',
        stage: 'Tohum Öncesi (Pre-Seed)',
        fundingGoal: '2.500.000 ₺',
        equityOffered: '%8',
        valuation: '31.250.000 ₺',
        summary: 'Girişimler için otonom regülasyon ve finansal uyumluluk asistanı platformu.',
        hasPitchDeck: true,
        isApprovedByAdmin: true,
        evaluationStatus: PitchEvaluationStatus.pending,
      ),
      const DealStartup(
        id: 'startup-2',
        name: 'BioGen Lab',
        founder: 'Dr. Zeynep Kaya',
        sector: 'Biyoteknoloji & Onkoloji',
        stage: 'Tohum (Seed)',
        fundingGoal: '6.000.000 ₺',
        equityOffered: '%12',
        valuation: '50.000.000 ₺',
        summary: 'Kişiselleştirilmiş gen tedavisi ve yapay zeka destekli molekül analiz altyapısı.',
        hasPitchDeck: true,
        isApprovedByAdmin: true,
        evaluationStatus: PitchEvaluationStatus.none,
      ),
      const DealStartup(
        id: 'startup-3',
        name: 'FinFlow Pay',
        founder: 'Can Berk',
        sector: 'Fintech & Açık Bankacılık',
        stage: 'Seri A',
        fundingGoal: '15.000.000 ₺',
        equityOffered: '%10',
        valuation: '150.000.000 ₺',
        summary: 'KOBİ’ler için sınır ötesi anlık çoklu para birimi tahsilat ve mutabakat omurgası.',
        hasPitchDeck: true,
        isApprovedByAdmin: true,
        evaluationStatus: PitchEvaluationStatus.termSheetSent,
      ),
      const DealStartup(
        id: 'startup-4',
        name: 'AgriSense IoT',
        founder: 'Selin Akın',
        sector: 'Agritech & İklim Teknolojisi',
        stage: 'Tohum Öncesi',
        fundingGoal: '3.000.000 ₺',
        equityOffered: '%9',
        valuation: '33.300.000 ₺',
        summary: 'Hassas tarım sensörleri ile su ve gübre tüketimini %45 azaltan yapay zeka sistemi.',
        hasPitchDeck: false,
        isApprovedByAdmin: false,
        evaluationStatus: PitchEvaluationStatus.none,
      ),
    ]);

    investorVerificationsNotifier = ValueNotifier<List<InvestorVerificationItem>>([
      const InvestorVerificationItem(
        id: 'inv-ver-1',
        name: 'Nevzat Aydın',
        type: 'Melek Yatırımcı',
        organization: 'Galata Business Angels',
        ticketSize: '1.000.000 ₺ - 4.000.000 ₺',
        isVerified: true,
        requestDate: '18 Ekim 2026',
      ),
      const InvestorVerificationItem(
        id: 'inv-ver-2',
        name: 'ScaleX Ventures',
        type: 'VC Girişim Sermayesi',
        organization: 'ScaleX Erken Aşama Fonu',
        ticketSize: '5.000.000 ₺ - 20.000.000 ₺',
        isVerified: false,
        requestDate: '19 Ekim 2026',
      ),
      const InvestorVerificationItem(
        id: 'inv-ver-3',
        name: 'Hande Enes',
        type: 'Melek Yatırımcı',
        organization: 'Arya Women Investment',
        ticketSize: '750.000 ₺ - 2.500.000 ₺',
        isVerified: true,
        requestDate: '15 Ekim 2026',
      ),
    ]);

    auditLogsNotifier = ValueNotifier<List<SystemAuditLog>>([
      const SystemAuditLog(
        id: 'log-1',
        action: 'Hukuk Danışmanı Atandı',
        target: 'NovaTech AI',
        actor: 'Admin (Sistem)',
        time: '10:45',
        isImportant: true,
      ),
      const SystemAuditLog(
        id: 'log-2',
        action: 'Akreditasyon Belgesi Doğrulandı',
        target: 'Nevzat Aydın',
        actor: 'Admin (Denetim)',
        time: '09:20',
        isImportant: false,
      ),
      const SystemAuditLog(
        id: 'log-3',
        action: 'Yeni Girişim Başvurusu Alındı',
        target: 'AgriSense IoT',
        actor: 'Selin Akın (Girişimci)',
        time: 'Dün',
        isImportant: false,
      ),
    ]);
  }

  /// Aktif rolü değiştirir
  void setRole(UserRole? role) {
    activeRoleNotifier.value = role;
  }

  /// Giriş portalına geri dön
  void logout() {
    activeRoleNotifier.value = null;
  }

  /// Yatırımcı: Girişime durum güncellemesi (Örn: Toplantı Planla, Term Sheet İlet)
  void updateDealStatus(String startupId, PitchEvaluationStatus status, {String? notes}) {
    final list = List<DealStartup>.from(dealStartupsNotifier.value);
    final index = list.indexWhere((s) => s.id == startupId);
    if (index != -1) {
      list[index] = list[index].copyWith(
        evaluationStatus: status,
        investorNotes: notes ?? list[index].investorNotes,
      );
      dealStartupsNotifier.value = list;

      // Denetim günlüğüne ekle
      addAuditLog(
        action: 'Yatırımcı Aksiyonu: ${status.name}',
        target: list[index].name,
        actor: 'Yatırımcı Portalı',
      );
    }
  }

  /// Admin: Girişimi onayla veya askıya al
  void toggleStartupAdminApproval(String startupId) {
    final list = List<DealStartup>.from(dealStartupsNotifier.value);
    final index = list.indexWhere((s) => s.id == startupId);
    if (index != -1) {
      final updatedApproval = !list[index].isApprovedByAdmin;
      list[index] = list[index].copyWith(isApprovedByAdmin: updatedApproval);
      dealStartupsNotifier.value = list;

      // Girişimci profili de NovaTech AI ise senkronize et
      if (list[index].name == 'NovaTech AI') {
        EntrepreneurProfileController.instance.toggleApprovalSimulation();
      }

      addAuditLog(
        action: updatedApproval ? 'Girişim Onaylandı' : 'Girişim İncelemeye Alındı',
        target: list[index].name,
        actor: 'Admin Masası',
        isImportant: true,
      );
    }
  }

  /// Admin: Yatırımcı akreditasyonunu doğrula / iptal et
  void toggleInvestorVerification(String id) {
    final list = List<InvestorVerificationItem>.from(investorVerificationsNotifier.value);
    final index = list.indexWhere((i) => i.id == id);
    if (index != -1) {
      final newStatus = !list[index].isVerified;
      list[index] = list[index].copyWith(isVerified: newStatus);
      investorVerificationsNotifier.value = list;

      addAuditLog(
        action: newStatus ? 'Akreditasyon Onaylandı' : 'Akreditasyon Askıya Alındı',
        target: list[index].name,
        actor: 'Admin Masası',
      );
    }
  }

  /// Admin: Uzman ata (Hukukçu & Mali Danışman)
  void assignSpecialistsToStartup({
    required String startupName,
    required String lawyerName,
    required String accountantName,
  }) {
    EntrepreneurProfileController.instance.applicationNotifier.value =
        EntrepreneurProfileController.instance.currentApplication.copyWith(
      assignedLawyer: lawyerName,
      assignedAccountant: accountantName,
    );

    addAuditLog(
      action: 'Uzmanlar Atandı ($lawyerName, $accountantName)',
      target: startupName,
      actor: 'Admin Masası',
      isImportant: true,
    );
  }

  /// Denetim günlüğüne yeni kayıt ekle
  void addAuditLog({
    required String action,
    required String target,
    required String actor,
    bool isImportant = false,
  }) {
    final currentLogs = List<SystemAuditLog>.from(auditLogsNotifier.value);
    final newLog = SystemAuditLog(
      id: 'log-${DateTime.now().millisecondsSinceEpoch}',
      action: action,
      target: target,
      actor: actor,
      time: 'Şimdi',
      isImportant: isImportant,
    );
    auditLogsNotifier.value = [newLog, ...currentLogs];
  }
}
