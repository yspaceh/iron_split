class SplitResult {
  final double perPerson;
  final double remainder;

  const SplitResult(this.perPerson, this.remainder);
}

class CalculationService {
  /// Calculate Base Total (Anchor)
  /// BaseTotal = Round(Amount * Rate)
  /// This fixes the total cost in base currency to an integer (if using standard rounding).
  /// Note: Ideally we should check if the currency supports decimals, but per Project Bible 5.6
  /// we round to fix the base total.
  static double calculateBaseTotal(double amount, double? rate) {
    return (amount * (rate ?? 1.0)).roundToDouble();
  }

  /// Calculate Even Split
  /// perPerson = Floor(BaseTotal / Count)
  /// remainder = BaseTotal - (perPerson * Count)
  static SplitResult calculateEvenSplit(double baseTotal, int memberCount) {
    if (memberCount <= 0) return const SplitResult(0.0, 0.0);

    final double perPerson = (baseTotal / memberCount).floorToDouble();
    final double remainder = baseTotal - (perPerson * memberCount);

    return SplitResult(perPerson, remainder);
  }
}
