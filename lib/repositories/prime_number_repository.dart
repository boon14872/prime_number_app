import 'dart:async';
import 'dart:math';

import 'package:prime_number_app/models/prime_response.dart';

class PrimeNumberRepository {
  final Map<int, PrimeResponse> _cache = {};

  Future<PrimeResponse> isPrime(int number) async {
    final stopwatch = Stopwatch()..start();
    if (_cache.containsKey(number)) {
      stopwatch.stop();
      final result = _cache[number]!.copyWith(
        executionTimeMicroseconds: stopwatch.elapsedMicroseconds,
      );
      return result;
    }
    final isPrime = isPrimeNumber(number);
    stopwatch.stop();
    if (!isPrime) {
      final result = PrimeResponse(
        number: number,
        isPrime: false,
        executionTimeMicroseconds: stopwatch.elapsedMicroseconds,
      );
      _cache[number] = result;
      return result;
    }
    final result = PrimeResponse(
      number: number,
      isPrime: true,
      executionTimeMicroseconds: stopwatch.elapsedMicroseconds,
    );
    _cache[number] = result;
    return result;
  }

  bool isPrimeNumber(int number) {
    if (number < 2) {
      return false;
    }
    if (number == 2 || number == 3) {
      return true;
    }
    if (number % 2 == 0) {
      return false;
    }
    for (int i = 3; i <= sqrt(number); i += 2) {
      if (number % i == 0) {
        return false;
      }
    }
    return true;
  }
}
