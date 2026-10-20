/// Ekip tablosu için üye model sınıfı.
class TeamMember {
  const TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.responsibilities,
  });

  final String id;
  final String name;
  final String role;
  final String responsibilities;

  TeamMember copyWith({
    String? id,
    String? name,
    String? role,
    String? responsibilities,
  }) {
    return TeamMember(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      responsibilities: responsibilities ?? this.responsibilities,
    );
  }
}
