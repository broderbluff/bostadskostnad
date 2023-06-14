double calculateCurrentCost(String loanInput, String inputCurrentInterestRate) {
  final loanSize =
      double.tryParse(loanInput.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
  final currentInterestRate =
      double.tryParse(inputCurrentInterestRate.replaceAll(RegExp(r','), '.')) ??
          0;

  return (loanSize * currentInterestRate / 100) / 12;
}

double calculateFutureCost(
    String loanInput, String inputFutureInterestRateInput) {
  final loanSize =
      double.tryParse(loanInput.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

  final futureInterestRate = double.tryParse(
          inputFutureInterestRateInput.replaceAll(RegExp(r','), '.')) ??
      0;

  return (loanSize * futureInterestRate / 100) / 12;
}

String calculateCostIncrease({
  double? currentCost,
  double? futureCost,
}) {
  if (currentCost == 0 || futureCost == 0) {
    return '0 kr';
  }

  double costIncrease = futureCost! - currentCost!;

  String costIncreaseString = '';

  if (costIncrease > 0) {
    costIncreaseString = '+${costIncrease.toStringAsFixed(0)} kr';
  } else {
    costIncreaseString = '${costIncrease.toStringAsFixed(0)} kr';
  }
  return costIncreaseString;
}

// String _amortization() {
//   if (_loanSizeController.text.isEmpty ||
//       _houseValue.text.isEmpty ||
//       _householdIncome.text.isEmpty) {
//     return '0 kr';
//   }
//   String loanOutput =
//       _loanSizeController.text.replaceAll(RegExp(r'[^0-9]'), '');
//   final loanSize = double.tryParse(loanOutput) ?? 0;

//   String houseValueOutput = _houseValue.text.replaceAll(RegExp(r'[^0-9]'), '');
//   final houseValue = double.tryParse(houseValueOutput) ?? 0;

//   String householdIncomeOutput =
//       _householdIncome.text.replaceAll(RegExp(r'[^0-9]'), '');
//   final householdIncome = double.tryParse(householdIncomeOutput) ?? 0;

//   double skuldkvot = loanSize / houseValue;

//   if (skuldkvot <= 0.5 && loanSize <= householdIncome * 4.5) {
//     return "Ingen krav på amortering";
//   }

//   if (skuldkvot <= 0.7 && loanSize <= householdIncome * 4.5) {
//     var output = loanSize * 0.01 / 12;
//     return "${output.toStringAsFixed(0)} kr";
//   }
//   if (skuldkvot <= 0.7 && loanSize > householdIncome * 4.5) {
//     var output = loanSize * 0.02 / 12;
//     return "${output.toStringAsFixed(0)} kr";
//   }

//   if (skuldkvot > 0.7 && loanSize <= householdIncome * 4.5) {
//     var output = loanSize * 0.02 / 12;
//     return "${output.toStringAsFixed(0)} kr";
//   }

//   if (skuldkvot > 0.7 && loanSize > householdIncome * 4.5) {
//     var output = loanSize * 0.03 / 12;
//     return "${output.toStringAsFixed(0)} kr";
//   }

//   return '0 kr';
// }
