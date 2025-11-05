// lib/domain/entities/user_settings.dart

class UserSettings {
  final String defaultCourtName;
  final double defaultCourtRate;
  final double shuttleCockPrice;
  final bool divideCourtEqually;

  UserSettings({
    required this.defaultCourtName,
    required this.defaultCourtRate,
    required this.shuttleCockPrice,
    required this.divideCourtEqually,
  });

  UserSettings copyWith({
    String? defaultCourtName,
    double? defaultCourtRate,
    double? shuttleCockPrice,
    bool? divideCourtEqually,
  }) {
    return UserSettings(
      defaultCourtName: defaultCourtName ?? this.defaultCourtName,
      defaultCourtRate: defaultCourtRate ?? this.defaultCourtRate,
      shuttleCockPrice: shuttleCockPrice ?? this.shuttleCockPrice,
      divideCourtEqually: divideCourtEqually ?? this.divideCourtEqually,
    );
  }

  static UserSettings get defaultSettings => UserSettings(
        defaultCourtName: 'Court A',
        defaultCourtRate: 200.0,
        shuttleCockPrice: 60.0,
        divideCourtEqually: true,
      );
}
