enum GrantCategory {
  all,
  kosgeb,
  tubitak,
  international,
}

enum GrantApplicationStatus {
  notApplied,
  applied,
  underReview,
  approved,
}

class Grant {
  const Grant({
    required this.id,
    required this.provider,
    required this.programName,
    required this.category,
    required this.maxAmount,
    required this.supportRatio,
    required this.deadline,
    required this.description,
    required this.status,
  });

  final String id;
  final String provider; // KOSGEB, TÜBİTAK, Horizon Europe vb.
  final String programName;
  final GrantCategory category;
  final String maxAmount;
  final String supportRatio; // %75 Geri Ödemesiz Hibe
  final String deadline;
  final String description;
  final GrantApplicationStatus status;

  Grant copyWith({
    String? id,
    String? provider,
    String? programName,
    GrantCategory? category,
    String? maxAmount,
    String? supportRatio,
    String? deadline,
    String? description,
    GrantApplicationStatus? status,
  }) {
    return Grant(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      programName: programName ?? this.programName,
      category: category ?? this.category,
      maxAmount: maxAmount ?? this.maxAmount,
      supportRatio: supportRatio ?? this.supportRatio,
      deadline: deadline ?? this.deadline,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}
