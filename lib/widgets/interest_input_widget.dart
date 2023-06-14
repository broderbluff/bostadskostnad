import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InterestInputWidget extends StatelessWidget {
  const InterestInputWidget({
    super.key,
    required TextEditingController loanSizeController,
    required TextEditingController currentInterestRateController,
    required TextEditingController futureInterestRateController,
  })  : _loanSizeController = loanSizeController,
        _currentInterestRateController = currentInterestRateController,
        _futureInterestRateController = futureInterestRateController;

  final TextEditingController _loanSizeController;
  final TextEditingController _currentInterestRateController;
  final TextEditingController _futureInterestRateController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          textAlign: TextAlign.center,
          inputFormatters: [
            CurrencyTextInputFormatter(
                locale: 'sv_SE', decimalDigits: 0, symbol: '')
          ],
          controller: _loanSizeController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
          decoration: const InputDecoration(
            prefixText: 'kr',
            floatingLabelAlignment: FloatingLabelAlignment.center,
            labelText: 'Ditt bostadslån',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          textAlign: TextAlign.center,
          controller: _currentInterestRateController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
                RegExp(r'^\d{0,2}([.,]\d{0,2})?$'))
          ],
          style: const TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
          decoration: const InputDecoration(
              prefixText: '%',
              floatingLabelAlignment: FloatingLabelAlignment.center,
              labelText: 'Nuvarande ränta?',
              alignLabelWithHint: true),
        ),
        const SizedBox(height: 16),
        TextField(
          inputFormatters: [
            FilteringTextInputFormatter.allow(
                RegExp(r'^\d{0,2}([.,]\d{0,2})?$'))
          ],
          textAlign: TextAlign.center,
          controller: _futureInterestRateController,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
          decoration: const InputDecoration(
            prefixText: '%',
            floatingLabelAlignment: FloatingLabelAlignment.center,
            labelText: 'Kommande ränta?',
          ),
        ),
      ],
    );
  }
}
