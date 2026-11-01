class const Rating({required final double rate, required final int count}) {
  factory Rating.fromJson(Map<String, dynamic> json) => Rating(
    rate: (json['rate'] as num).toDouble(),
    count: json['count'] as int,
  );
}
