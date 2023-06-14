import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';

class AmortizationWidget extends StatelessWidget {
  const AmortizationWidget({
    super.key,
    required TextEditingController houseValue,
    required TextEditingController householdIncome,
  })  : _houseValue = houseValue,
        _householdIncome = householdIncome;

  final TextEditingController _houseValue;
  final TextEditingController _householdIncome;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          textAlign: TextAlign.center,
          controller: _houseValue,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
          inputFormatters: [
            CurrencyTextInputFormatter(
                locale: 'sv_SE', decimalDigits: 0, symbol: '')
          ],
          decoration: const InputDecoration(
            prefixText: 'kr',
            floatingLabelAlignment: FloatingLabelAlignment.center,
            labelText: 'Bostadens värde',
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          inputFormatters: [
            CurrencyTextInputFormatter(
                locale: 'sv_SE', decimalDigits: 0, symbol: '')
          ],
          textAlign: TextAlign.center,
          controller: _householdIncome,
          keyboardType: TextInputType.number,
          style: const TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
          decoration: const InputDecoration(
            prefixText: 'kr',
            floatingLabelAlignment: FloatingLabelAlignment.center,
            labelText: 'Hushållets årsinkomst',
          ),
        ),
      ],
    );
  }
}
