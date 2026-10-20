class LegalStep {
  const LegalStep({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  LegalStep copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return LegalStep(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
