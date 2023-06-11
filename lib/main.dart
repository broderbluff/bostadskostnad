import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      title: 'Bostadskostnad',
      home: Scaffold(
        backgroundColor: Colors.amber.shade100,
        body: LoanCalculatorView(),
      ),
    );
  }
}

class LoanCalculatorView extends StatefulWidget {
  @override
  _LoanCalculatorViewState createState() => _LoanCalculatorViewState();
}

class _LoanCalculatorViewState extends State<LoanCalculatorView> {
  final _loanSizeController = TextEditingController();
  final _currentInterestRateController = TextEditingController();
  final _futureInterestRateController = TextEditingController();
  final _houseValue = TextEditingController();
  final _householdIncome = TextEditingController();

  double _calculateCurrentCost() {
    String loanOutput =
        _loanSizeController.text.replaceAll(RegExp(r'[^0-9]'), '');
    String currentPercent =
        _currentInterestRateController.text.replaceAll(RegExp(r','), '.');

    final loanSize = double.tryParse(loanOutput) ?? 0;
    final currentInterestRate = double.tryParse(currentPercent) ?? 0;

    return (loanSize * currentInterestRate / 100) / 12;
  }

  double _calculateFutureCost() {
    String loanOutput =
        _loanSizeController.text.replaceAll(RegExp(r'[^0-9]'), '');

    String comingPercent =
        _futureInterestRateController.text.replaceAll(RegExp(r','), '.');
    final loanSize = double.tryParse(loanOutput) ?? 0;
    final futureInterestRate = double.tryParse(comingPercent) ?? 0;

    return (loanSize * futureInterestRate / 100) / 12;
  }

  String _calculateCostIncrease() {
    if (_loanSizeController.text.isEmpty ||
        _currentInterestRateController.text.isEmpty ||
        _futureInterestRateController.text.isEmpty) {
      return '0 kr';
    }

    double costIncrease = _calculateFutureCost() - _calculateCurrentCost();

    String costIncreaseString = '';

    if (costIncrease > 0) {
      costIncreaseString = '+${costIncrease.toStringAsFixed(0)} kr';
    } else {
      costIncreaseString = '${costIncrease.toStringAsFixed(0)} kr';
    }
    return costIncreaseString;
  }

  String _amortization() {
    if (_loanSizeController.text.isEmpty ||
        _houseValue.text.isEmpty ||
        _householdIncome.text.isEmpty) {
      return '0 kr';
    }
    String loanOutput =
        _loanSizeController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final loanSize = double.tryParse(loanOutput) ?? 0;

    String houseValueOutput =
        _houseValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final houseValue = double.tryParse(houseValueOutput) ?? 0;

    String householdIncomeOutput =
        _householdIncome.text.replaceAll(RegExp(r'[^0-9]'), '');
    final householdIncome = double.tryParse(householdIncomeOutput) ?? 0;

    double skuldkvot = loanSize / houseValue;

    if (skuldkvot <= 0.5 && loanSize <= householdIncome * 4.5) {
      return "Ingen krav på amortering";
    }

    if (skuldkvot <= 0.7 && loanSize <= householdIncome * 4.5) {
      var output = loanSize * 0.01 / 12;
      return "${output.toStringAsFixed(0)} kr";
    }
    if (skuldkvot <= 0.7 && loanSize > householdIncome * 4.5) {
      var output = loanSize * 0.02 / 12;
      return "${output.toStringAsFixed(0)} kr";
    }

    if (skuldkvot > 0.7 && loanSize <= householdIncome * 4.5) {
      var output = loanSize * 0.02 / 12;
      return "${output.toStringAsFixed(0)} kr";
    }

    if (skuldkvot > 0.7 && loanSize > householdIncome * 4.5) {
      var output = loanSize * 0.03 / 12;
      return "${output.toStringAsFixed(0)} kr";
    }

    return '0 kr';
  }

  @override
  void initState() {
    super.initState();
    _loanSizeController.addListener(_onTextChanged);
    _currentInterestRateController.addListener(_onTextChanged);
    _futureInterestRateController.addListener(_onTextChanged);
    _houseValue.addListener(_onTextChanged);
    _householdIncome.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _loanSizeController.dispose();
    _currentInterestRateController.dispose();
    _futureInterestRateController.dispose();
    _houseValue.dispose();
    _householdIncome.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {});
  }

  bool _includeAmortization = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 600;

    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: isDesktop ? screenWidth / 3 : screenWidth,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                textAlign: TextAlign.center,
                inputFormatters: [
                  CurrencyTextInputFormatter(
                      locale: 'sv_SE', decimalDigits: 0, symbol: '')
                ],
                controller: _loanSizeController,
                keyboardType: TextInputType.number,
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
                keyboardType: TextInputType.number,
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
                keyboardType: TextInputType.number,
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
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Räkna med amortering',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Switch(
                    value: _includeAmortization,
                    onChanged: (value) {
                      setState(() {
                        _includeAmortization = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _includeAmortization
                  ? Column(
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
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
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
                            floatingLabelAlignment:
                                FloatingLabelAlignment.center,
                            labelText: 'Hushållets årsinkomst',
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(height: 16),
              const Divider(),
              Text(
                'Räntekostnad',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const Divider(),
              ResultWidget(
                  currentCost: _calculateCurrentCost(),
                  futureCost: _calculateFutureCost(),
                  costIncrease: _calculateCostIncrease()),
              const Divider(),
              _includeAmortization
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Amorteringskostnad',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(child: Text('Amortering / månad: ')),
                            Flexible(
                              child: Text(
                                _amortization(),
                                maxLines: 3,
                                style: const TextStyle(fontSize: 40),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}

Widget ResultWidget(
    {required double currentCost,
    required double futureCost,
    required String costIncrease}) {
  return Center(
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Dagens räntekostnad / månad: '),
            Text(
              '${currentCost.toStringAsFixed(0)} kr',
              style: const TextStyle(fontSize: 40),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Kommande räntekostnad / månad: '),
            Text(
              '${futureCost.toStringAsFixed(0)} kr',
              style: const TextStyle(fontSize: 40),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Förändring / månad: '),
            Text(
              costIncrease,
              style: const TextStyle(fontSize: 40),
            ),
          ],
        ),
      ],
    ),
  );
}
