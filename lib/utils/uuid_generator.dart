// lib/utils/id_generator.dart
import 'dart:math';

class IdGenerator {
  static final Random _random = Random();

  static String generate() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final timestamp = DateTime.now().millisecondsSinceEpoch.toRadixString(36);
    final randomPart = List.generate(
      12,
      (_) => chars[_random.nextInt(chars.length)],
    ).join();
    return '$timestamp-$randomPart';
  }
}
