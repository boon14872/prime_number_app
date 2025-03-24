class PrimeResponse {
  final int? number;
  final bool? isPrime;
  final int? executionTimeMicroseconds;

  PrimeResponse({this.number, this.isPrime, this.executionTimeMicroseconds});

  PrimeResponse copyWith({
    int? number,
    bool? isPrime,
    int? executionTimeMicroseconds,
  }) {
    return PrimeResponse(
      number: number ?? this.number,
      isPrime: isPrime ?? this.isPrime,
      executionTimeMicroseconds:
          executionTimeMicroseconds ?? this.executionTimeMicroseconds,
    );
  }
}
