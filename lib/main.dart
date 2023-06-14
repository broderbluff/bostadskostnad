import 'package:bostadskostnad/logic.dart';
import 'package:bostadskostnad/widgets/amortization_input_widget.dart';
import 'package:bostadskostnad/widgets/interest_input_widget.dart';
import 'package:bostadskostnad/widgets/result_widget.dart';
import 'package:flutter/material.dart';

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
              InterestInputWidget(
                  loanSizeController: _loanSizeController,
                  currentInterestRateController: _currentInterestRateController,
                  futureInterestRateController: _futureInterestRateController),
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
                  ? AmortizationWidget(
                      houseValue: _houseValue,
                      householdIncome: _householdIncome)
                  : const SizedBox(),
              const SizedBox(height: 16),
              const Divider(),
              Text(
                'Räntekostnad',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const Divider(),
              ResultWidget(
                currentCost: calculateCurrentCost(_loanSizeController.text,
                    _currentInterestRateController.text),
                futureCost: calculateFutureCost(_loanSizeController.text,
                    _futureInterestRateController.text),
                costIncrease: calculateCostIncrease(
                  currentCost: calculateCurrentCost(_loanSizeController.text,
                      _currentInterestRateController.text),
                  futureCost: calculateFutureCost(_loanSizeController.text,
                      _futureInterestRateController.text),
                ),
              ),
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
