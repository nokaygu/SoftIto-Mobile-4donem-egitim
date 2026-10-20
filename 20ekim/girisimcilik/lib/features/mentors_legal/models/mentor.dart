class Mentor {
  const Mentor({
    required this.id,
    required this.name,
    required this.title,
    required this.company,
    required this.expertise,
    required this.rating,
    required this.sessionsCount,
  });

  final String id;
  final String name;
  final String title;
  final String company;
  final String expertise;
  final double rating;
  final int sessionsCount;
}
