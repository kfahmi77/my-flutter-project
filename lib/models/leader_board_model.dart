class LeaderboardEntry {
  final int? id;
  final String name;
  final int score;

  LeaderboardEntry({this.id, required this.name, required this.score});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'score': score,
    };
  }

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      id: map['id'],
      name: map['name'],
      score: map['score'],
    );
  }
}