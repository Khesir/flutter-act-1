import 'player.dart';

class GameSchedule {
  final DateTime startTime;
  final DateTime endTime;

  GameSchedule({required this.startTime, required this.endTime});

  double get hours => endTime.difference(startTime).inMinutes / 60.0;

  Map<String, dynamic> toJson() => {
    'startTime': startTime.toIso8601String(),
    'endTime': endTime.toIso8601String(),
  };

  factory GameSchedule.fromJson(Map<String, dynamic> json) => GameSchedule(
    startTime: DateTime.parse(json['startTime']),
    endTime: DateTime.parse(json['endTime']),
  );
}

class Game {
  final String id;
  final String title;
  final String courtName;
  final List<GameSchedule> schedules;
  final double courtRate;
  final double shuttleCockPrice;
  final bool divideEqually;
  final List<Player> players;

  Game({
    required this.id,
    required this.title,
    required this.courtName,
    required this.schedules,
    required this.courtRate,
    required this.shuttleCockPrice,
    required this.divideEqually,
    required this.players,
  });

  /// Total number of hours from all schedules.
  double get totalHours => schedules.fold(0, (sum, s) => sum + s.hours);

  /// Total cost = (courtRate * totalHours) + shuttleCockPrice
  double get totalCost {
    final totalCourtCost = courtRate * totalHours;
    final totalShuttleCost = shuttleCockPrice;
    final total = totalCourtCost + totalShuttleCost;
    if (divideEqually && players.isNotEmpty) {
      return total / players.length;
    }
    return total;
  }

  int get numberOfPlayers => players.length;

  Game copyWith({
    String? id,
    String? title,
    String? courtName,
    List<GameSchedule>? schedules,
    double? courtRate,
    double? shuttleCockPrice,
    bool? divideEqually,
    List<Player>? players,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      courtName: courtName ?? this.courtName,
      schedules: schedules ?? this.schedules,
      courtRate: courtRate ?? this.courtRate,
      shuttleCockPrice: shuttleCockPrice ?? this.shuttleCockPrice,
      divideEqually: divideEqually ?? this.divideEqually,
      players: players ?? this.players,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'courtName': courtName,
      'schedules': schedules.map((s) => s.toJson()).toList(),
      'courtRate': courtRate,
      'shuttleCockPrice': shuttleCockPrice,
      'divideEqually': divideEqually,
      'players': players.map((p) => p.toJson()).toList(),
    };
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      title: json['title'],
      courtName: json['courtName'],
      schedules: (json['schedules'] as List<dynamic>)
          .map((s) => GameSchedule.fromJson(s))
          .toList(),
      courtRate: (json['courtRate'] as num).toDouble(),
      shuttleCockPrice: (json['shuttleCockPrice'] as num).toDouble(),
      divideEqually: json['divideEqually'],
      players: (json['players'] as List<dynamic>)
          .map((p) => Player.fromJson(p))
          .toList(),
    );
  }
}
