enum InvestorType {
  angel,
  vc,
}

class Investor {
  const Investor({
    required this.id,
    required this.name,
    required this.type,
    required this.fundName,
    required this.focusSectors,
    required this.ticketSize,
    required this.portfolioCount,
    required this.isMatched,
    this.avatarUrl,
  });

  final String id;
  final String name;
  final InvestorType type;
  final String fundName;
  final List<String> focusSectors;
  final String ticketSize;
  final int portfolioCount;
  final bool isMatched;
  final String? avatarUrl;

  Investor copyWith({
    String? id,
    String? name,
    InvestorType? type,
    String? fundName,
    List<String>? focusSectors,
    String? ticketSize,
    int? portfolioCount,
    bool? isMatched,
    String? avatarUrl,
  }) {
    return Investor(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      fundName: fundName ?? this.fundName,
      focusSectors: focusSectors ?? this.focusSectors,
      ticketSize: ticketSize ?? this.ticketSize,
      portfolioCount: portfolioCount ?? this.portfolioCount,
      isMatched: isMatched ?? this.isMatched,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
