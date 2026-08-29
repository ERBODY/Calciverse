import 'package:flutter/material.dart';
import '../utils/translations.dart';
import '../widgets/unified_page_design.dart';

class PostTaxCalculatorPage extends StatefulWidget {
  final String currentLanguage;

  const PostTaxCalculatorPage({
    super.key,
    required this.currentLanguage,
  });

  @override
  PostTaxCalculatorPageState createState() => PostTaxCalculatorPageState();
}

class PostTaxCalculatorPageState extends State<PostTaxCalculatorPage> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _taxRateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double _finalPrice = 0;
  double _taxAmount = 0;
  bool _hasCalculated = false;
  bool _expandSalaryTax = true;
  bool _expandProductTax = true;
  bool _expandReverseTax = true;

  @override
  void dispose() {
    _priceController.dispose();
    _taxRateController.dispose();
    super.dispose();
  }

  void _resetCalculator() {
    setState(() {
      _priceController.clear();
      _taxRateController.clear();
      _finalPrice = 0;
      _taxAmount = 0;
      _hasCalculated = false;
    });
  }

  void _calculateFinalPrice() {
    if (_formKey.currentState?.validate() ?? false) {
      final price = double.tryParse(_priceController.text) ?? 0;
      final taxRate = double.tryParse(_taxRateController.text) ?? 0;

      setState(() {
        _taxAmount = price * taxRate / 100;
        _finalPrice = price + _taxAmount;
        _hasCalculated = true;
      });
    }
  }

  double _calculatePriceBeforeTax(double finalPrice, double taxRate) {
    return finalPrice / (1 + taxRate / 100);
  }

  Widget _buildInputCard(String title, TextEditingController controller,
      String label, String errorMessage, bool isPrice) {
    return UnifiedInputSection(
      title: title,
      icon: isPrice ? Icons.attach_money : Icons.percent,
      children: [
        UnifiedInputField(
          label: label,
          hintText: label,
          prefixIcon: isPrice ? Icons.monetization_on : Icons.percent,
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return errorMessage;
            }
            final number = double.tryParse(value);
            if (number == null || (isPrice ? number <= 0 : number < 0)) {
              return Translations.getTranslation(widget.currentLanguage,
                  isPrice ? 'invalid price' : 'invalid tax rate');
            }
            return null;
          },
          onChanged: (value) {
            setState(() {
              _hasCalculated = false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildResultCard() {
    final price = double.tryParse(_priceController.text) ?? 0;
    final taxRate = double.tryParse(_taxRateController.text) ?? 0;
    final netSalary = price - _taxAmount;
    final priceBeforeTax = _calculatePriceBeforeTax(_finalPrice, taxRate);

    return Column(
      children: [
        ExpansionTile(
          initiallyExpanded: _expandSalaryTax,
          onExpansionChanged: (expanded) {
            setState(() {
              _expandSalaryTax = expanded;
            });
          },
          title: Row(
            children: [
              Icon(
                Icons.work,
                color: UnifiedPageDesign.primaryColor,
              ),
              const SizedBox(width: 12),
              Text(
                '💼 ${Translations.getTranslation(widget.currentLanguage, 'Salary Tax Calculation')}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: UnifiedPageDesign.primaryColor,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  UnifiedResultCard(
                    title: Translations.getTranslation(
                        widget.currentLanguage, 'Gross Salary'),
                    value: Translations.formatNumber(
                        widget.currentLanguage, price,
                        decimalDigits: 2),
                    icon: Icons.monetization_on,
                  ),
                  const SizedBox(height: 8),
                  UnifiedResultCard(
                    title: Translations.getTranslation(
                        widget.currentLanguage, 'Tax Amount'),
                    value: Translations.formatNumber(
                        widget.currentLanguage, _taxAmount,
                        decimalDigits: 2),
                    icon: Icons.percent,
                  ),
                  const SizedBox(height: 8),
                  UnifiedResultCard(
                    title: Translations.getTranslation(
                        widget.currentLanguage, 'Net Salary'),
                    value: Translations.formatNumber(
                        widget.currentLanguage, netSalary,
                        decimalDigits: 2),
                    icon: Icons.check_circle,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ExpansionTile(
          initiallyExpanded: _expandProductTax,
          onExpansionChanged: (expanded) {
            setState(() {
              _expandProductTax = expanded;
            });
          },
          title: Row(
            children: [
              Icon(
                Icons.shopping_cart,
                color: UnifiedPageDesign.primaryColor,
              ),
              const SizedBox(width: 12),
              Text(
                '🛒 ${Translations.getTranslation(widget.currentLanguage, 'Product Tax Calculation')}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: UnifiedPageDesign.primaryColor,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  UnifiedResultCard(
                    title: Translations.getTranslation(
                        widget.currentLanguage, 'Original Price'),
                    value: Translations.formatNumber(
                        widget.currentLanguage, price,
                        decimalDigits: 2),
                    icon: Icons.monetization_on,
                  ),
                  const SizedBox(height: 8),
                  UnifiedResultCard(
                    title: Translations.getTranslation(
                        widget.currentLanguage, 'Price After Tax'),
                    value: Translations.formatNumber(
                        widget.currentLanguage, _finalPrice,
                        decimalDigits: 2),
                    icon: Icons.trending_up,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ExpansionTile(
          initiallyExpanded: _expandReverseTax,
          onExpansionChanged: (expanded) {
            setState(() {
              _expandReverseTax = expanded;
            });
          },
          title: Row(
            children: [
              Icon(
                Icons.cached,
                color: UnifiedPageDesign.primaryColor,
              ),
              const SizedBox(width: 12),
              Text(
                '🔄 ${Translations.getTranslation(widget.currentLanguage, 'Reverse Tax Calculation')}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: UnifiedPageDesign.primaryColor,
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  UnifiedResultCard(
                    title: Translations.getTranslation(
                        widget.currentLanguage, 'Final Price'),
                    value: Translations.formatNumber(
                        widget.currentLanguage, _finalPrice,
                        decimalDigits: 2),
                    icon: Icons.check_circle,
                  ),
                  const SizedBox(height: 8),
                  UnifiedResultCard(
                    title: Translations.getTranslation(
                        widget.currentLanguage, 'Price Before Tax'),
                    value: Translations.formatNumber(
                        widget.currentLanguage, priceBeforeTax,
                        decimalDigits: 2),
                    icon: Icons.trending_down,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Translations.getTranslation(
              widget.currentLanguage, 'Post Tax Calculator'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetCalculator,
            tooltip:
                Translations.getTranslation(widget.currentLanguage, 'Reset'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInputCard(
                  Translations.getTranslation(widget.currentLanguage, 'Price'),
                  _priceController,
                  Translations.getTranslation(
                      widget.currentLanguage, 'Enter original price'),
                  Translations.getTranslation(
                      widget.currentLanguage, 'price required'),
                  true,
                ),
                const SizedBox(height: 16),
                _buildInputCard(
                  Translations.getTranslation(
                      widget.currentLanguage, 'Tax Rate'),
                  _taxRateController,
                  Translations.getTranslation(
                      widget.currentLanguage, 'Enter tax rate (%)'),
                  Translations.getTranslation(
                      widget.currentLanguage, 'tax rate required'),
                  false,
                ),
                const SizedBox(height: 24),
                UnifiedPrimaryButton(
                  text: Translations.getTranslation(
                      widget.currentLanguage, 'Calculate'),
                  icon: Icons.calculate,
                  onPressed: _calculateFinalPrice,
                ),
                if (_hasCalculated) ...[
                  const SizedBox(height: 24),
                  _buildResultCard(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
