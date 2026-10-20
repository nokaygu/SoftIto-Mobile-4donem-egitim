import 'team_member.dart';

enum BusinessPlanStatus {
  notSelected,
  hasPlan,
  noPlan,
}

enum ApplicationReviewStatus {
  draft,
  underReview,
  approved,
}

/// Girişimcinin başvuru ve profil verilerini tutan model.
class BusinessApplication {
  const BusinessApplication({
    required this.founderName,
    required this.startupName,
    required this.planStatus,
    required this.reviewStatus,
    required this.sector,
    required this.summary,
    required this.financialNeed,
    required this.teamMembers,
    required this.needsMentorship,
    this.assignedLawyer,
    this.assignedAccountant,
  });

  final String founderName;
  final String startupName;
  final BusinessPlanStatus planStatus;
  final ApplicationReviewStatus reviewStatus;
  final String sector;
  final String summary;
  final String financialNeed;
  final List<TeamMember> teamMembers;
  final bool needsMentorship;
  final String? assignedLawyer;
  final String? assignedAccountant;

  bool get isApproved => reviewStatus == ApplicationReviewStatus.approved;

  BusinessApplication copyWith({
    String? founderName,
    String? startupName,
    BusinessPlanStatus? planStatus,
    ApplicationReviewStatus? reviewStatus,
    String? sector,
    String? summary,
    String? financialNeed,
    List<TeamMember>? teamMembers,
    bool? needsMentorship,
    String? assignedLawyer,
    String? assignedAccountant,
  }) {
    return BusinessApplication(
      founderName: founderName ?? this.founderName,
      startupName: startupName ?? this.startupName,
      planStatus: planStatus ?? this.planStatus,
      reviewStatus: reviewStatus ?? this.reviewStatus,
      sector: sector ?? this.sector,
      summary: summary ?? this.summary,
      financialNeed: financialNeed ?? this.financialNeed,
      teamMembers: teamMembers ?? this.teamMembers,
      needsMentorship: needsMentorship ?? this.needsMentorship,
      assignedLawyer: assignedLawyer ?? this.assignedLawyer,
      assignedAccountant: assignedAccountant ?? this.assignedAccountant,
    );
  }
}
