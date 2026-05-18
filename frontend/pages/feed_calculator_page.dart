import 'package:flutter/material.dart';
import 'package:aqa_shrimp_ai/l10n/app_localizations.dart';

/// Feed Calculator Page
/// Calculate daily feed requirements based on pond parameters
class FeedCalculatorPage extends StatefulWidget {
  const FeedCalculatorPage({super.key});

  @override
  State<FeedCalculatorPage> createState() => _FeedCalculatorPageState();
}

class _FeedCalculatorPageState extends State<FeedCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _pondAreaController = TextEditingController();
  final _shrimpCountController = TextEditingController();
  final _avgSizeController = TextEditingController();
  
  Map<String, dynamic>? _feedResult;
  bool _isCalculating = false;

  @override
  void dispose() {
    _pondAreaController.dispose();
    _shrimpCountController.dispose();
    _avgSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.feedCalculator,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF4A90E2),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4A90E2),
              Color(0xFFE8F4F8),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: Color(0xFF4A90E2), size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.enterPondDetails,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Input Fields Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.pondInformation,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Pond Area
                      _buildInputField(
                        controller: _pondAreaController,
                        label: AppLocalizations.of(context)!.pondArea,
                        hint: AppLocalizations.of(context)!.enterPondArea,
                        icon: Icons.square_foot,
                        suffix: 'm²',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.pleaseEnterPondArea;
                          }
                          if (double.tryParse(value) == null) {
                            return AppLocalizations.of(context)!.pleaseEnterValidNumber;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Shrimp Count
                      _buildInputField(
                        controller: _shrimpCountController,
                        label: AppLocalizations.of(context)!.shrimpCount,
                        hint: AppLocalizations.of(context)!.enterShrimpCount,
                        icon: Icons.water_drop,
                        suffix: 'pcs',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.pleaseEnterShrimpCount;
                          }
                          if (int.tryParse(value) == null) {
                            return AppLocalizations.of(context)!.pleaseEnterValidNumber;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Average Size
                      _buildInputField(
                        controller: _avgSizeController,
                        label: AppLocalizations.of(context)!.averageSize,
                        hint: AppLocalizations.of(context)!.enterAverageSize,
                        icon: Icons.straighten,
                        suffix: 'g',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.pleaseEnterAverageSize;
                          }
                          if (double.tryParse(value) == null) {
                            return AppLocalizations.of(context)!.pleaseEnterValidNumber;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Calculate Button
                ElevatedButton(
                  onPressed: _isCalculating ? null : _calculateFeed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4A90E2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isCalculating
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          AppLocalizations.of(context)!.calculateFeed,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),

                // Feed Result
                if (_feedResult != null) ...[
                  const SizedBox(height: 20),
                  
                  // Pond Status Overview
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade400, Colors.blue.shade600],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.water, color: Colors.white, size: 28),
                            SizedBox(width: 12),
                            Text(
                              'Pond Status Overview',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _buildQuickStat(
                                'Total Biomass',
                                '${_feedResult!['totalBiomass']} kg',
                                Icons.scale,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildQuickStat(
                                'Stocking Density',
                                '${_feedResult!['stockingDensity']} pcs/m²',
                                Icons.grid_4x4,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _feedResult!['densityStatus'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Feed Recommendation Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.restaurant_menu, color: Color(0xFF4A90E2), size: 28),
                            const SizedBox(width: 12),
                            const Text(
                              'Feed Recommendation',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _feedResult!['feedType'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange.shade900,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _buildResultCard(
                          icon: Icons.today,
                          label: 'Daily Feed Amount',
                          value: '${_feedResult!['dailyFeed']} kg',
                          color: const Color(0xFF5CB85C),
                        ),
                        const SizedBox(height: 12),
                        _buildResultCard(
                          icon: Icons.schedule,
                          label: 'Feeding Frequency',
                          value: '${_feedResult!['frequency']} times/day',
                          color: const Color(0xFFF0AD4E),
                        ),
                        const SizedBox(height: 12),
                        _buildResultCard(
                          icon: Icons.science,
                          label: 'Feed Per Meal (Avg)',
                          value: '${_feedResult!['perMeal']} kg',
                          color: const Color(0xFF5BC0DE),
                        ),
                        const SizedBox(height: 12),
                        _buildResultCard(
                          icon: Icons.calendar_today,
                          label: 'Weekly Feed Estimate',
                          value: '${_feedResult!['weeklyFeed']} kg',
                          color: const Color(0xFF9B59B6),
                        ),
                        const SizedBox(height: 12),
                        _buildResultCard(
                          icon: Icons.calendar_month,
                          label: 'Monthly Feed Estimate',
                          value: '${_feedResult!['monthly']} kg',
                          color: const Color(0xFF9B59B6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Performance Metrics Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.trending_up, color: Color(0xFF4A90E2), size: 28),
                            SizedBox(width: 12),
                            Text(
                              'Performance Metrics',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricCard(
                                'Feeding Rate',
                                '${_feedResult!['feedingRate']}%',
                                'of biomass/day',
                                Icons.percent,
                                Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMetricCard(
                                'Est. FCR',
                                _feedResult!['estimatedFCR'],
                                'Target: 1.2-1.5',
                                Icons.analytics,
                                Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMetricCard(
                                'Weekly Growth',
                                '${_feedResult!['weeklyGrowth']} kg',
                                'Expected gain',
                                Icons.arrow_upward,
                                Colors.purple,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildMetricCard(
                                'Survival Rate',
                                _feedResult!['survivalRate'],
                                'Expected range',
                                Icons.favorite,
                                Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Cost Analysis Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.account_balance_wallet, color: Color(0xFF4A90E2), size: 28),
                            SizedBox(width: 12),
                            Text(
                              'Cost Analysis',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.amber.shade700, size: 16),
                              const SizedBox(width: 8),
                              Text(
                                'Based on average feed cost: ₹80/kg',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.amber.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.orange.shade300, Colors.orange.shade400],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.today, color: Colors.white, size: 28),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Daily Cost',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${_feedResult!['dailyCost']}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade400],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(Icons.calendar_month, color: Colors.white, size: 28),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Monthly Cost',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${_feedResult!['monthlyCost']}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Feeding Schedule Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.schedule, color: Color(0xFF4A90E2), size: 28),
                            SizedBox(width: 12),
                            Text(
                              'Suggested Feeding Schedule',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lightbulb_outline, color: Colors.green.shade700, size: 16),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Feed during shrimp active periods for better consumption',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.green.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._buildScheduleList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Recommendations Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.tips_and_updates, color: Color(0xFF4A90E2), size: 28),
                            SizedBox(width: 12),
                            Text(
                              'Expert Recommendations',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...(_feedResult!['recommendations'] as List<String>).map((rec) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  width: 6,
                                  height: 6,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF4A90E2),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    rec,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      height: 1.5,
                                      color: Color(0xFF333333),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Disclaimer
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning_amber, color: Colors.amber.shade700, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'These calculations are estimates based on industry standards. Actual feed requirements may vary based on water quality, shrimp health, temperature, and other environmental factors. Monitor feed consumption regularly and adjust accordingly.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.amber.shade900,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String suffix,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF4A90E2)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffix,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildResultCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildScheduleList() {
    if (_feedResult == null) return [];
    
    final schedules = _feedResult!['schedule'] as List<Map<String, dynamic>>;
    
    return schedules.map((schedule) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.access_time, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule['time']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    Text(
                      schedule['period']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    schedule['amount']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A90E2),
                    ),
                  ),
                  Text(
                    '${schedule['percentage']}%',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Future<void> _calculateFeed() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isCalculating = true;
    });

    // Simulate calculation delay
    await Future.delayed(const Duration(milliseconds: 800));

    try {
      final pondArea = double.parse(_pondAreaController.text);
      final shrimpCount = int.parse(_shrimpCountController.text);
      final avgSize = double.parse(_avgSizeController.text);

      // Calculate stocking density (pieces per m²)
      final stockingDensity = shrimpCount / pondArea;
      
      // Calculate total biomass (kg)
      final totalBiomass = (shrimpCount * avgSize) / 1000;
      
      // Calculate biomass per m² (kg/m²)
      final biomassPerArea = totalBiomass / pondArea;
      
      // Determine feeding rate based on shrimp size (industry standard)
      // Smaller shrimp need higher % of body weight as feed
      double feedingRate;
      String feedType;
      int feedingFrequency;
      
      if (avgSize < 3) {
        // Juvenile stage (0-3g)
        feedingRate = 0.08; // 8% of biomass
        feedType = 'Starter Feed (38-40% protein)';
        feedingFrequency = 6; // 6 times per day
      } else if (avgSize < 8) {
        // Early growth (3-8g)
        feedingRate = 0.05; // 5% of biomass
        feedType = 'Grower Feed (35-38% protein)';
        feedingFrequency = 5; // 5 times per day
      } else if (avgSize < 15) {
        // Mid growth (8-15g)
        feedingRate = 0.04; // 4% of biomass
        feedType = 'Grower Feed (32-35% protein)';
        feedingFrequency = 4; // 4 times per day
      } else if (avgSize < 25) {
        // Late growth (15-25g)
        feedingRate = 0.03; // 3% of biomass
        feedType = 'Finisher Feed (30-32% protein)';
        feedingFrequency = 4; // 4 times per day
      } else {
        // Harvest size (>25g)
        feedingRate = 0.025; // 2.5% of biomass
        feedType = 'Finisher Feed (28-30% protein)';
        feedingFrequency = 3; // 3 times per day
      }
      
      // Calculate daily feed requirement (kg)
      final dailyFeed = totalBiomass * feedingRate;
      
      // Calculate per meal amount (kg)
      final perMeal = dailyFeed / feedingFrequency;
      
      // Calculate weekly and monthly estimates
      final weeklyFeed = dailyFeed * 7;
      final monthlyFeed = dailyFeed * 30;
      
      // Calculate feed conversion ratio (FCR) estimate
      // Good FCR for shrimp is 1.2-1.5
      final estimatedFCR = 1.35;
      
      // Calculate expected weight gain per week (assuming 7% weekly growth)
      final weeklyGrowthRate = 0.07;
      final expectedWeeklyGain = totalBiomass * weeklyGrowthRate;
      
      // Calculate survival rate based on stocking density
      String survivalRate;
      String densityStatus;
      if (stockingDensity < 30) {
        survivalRate = '90-95%';
        densityStatus = 'Low density - Optimal conditions';
      } else if (stockingDensity < 60) {
        survivalRate = '85-90%';
        densityStatus = 'Medium density - Good conditions';
      } else if (stockingDensity < 100) {
        survivalRate = '75-85%';
        densityStatus = 'High density - Monitor closely';
      } else {
        survivalRate = '60-75%';
        densityStatus = 'Very high density - Risk of disease';
      }
      
      // Generate feeding schedule based on frequency
      List<Map<String, dynamic>> schedule = [];
      
      if (feedingFrequency == 6) {
        // Juvenile: 5:00, 8:00, 11:00, 14:00, 17:00, 20:00
        schedule = [
          {'time': '05:00 AM', 'period': 'Early Morning', 'amount': '${(perMeal * 0.15).toStringAsFixed(3)} kg', 'percentage': '15'},
          {'time': '08:00 AM', 'period': 'Morning', 'amount': '${(perMeal * 0.20).toStringAsFixed(3)} kg', 'percentage': '20'},
          {'time': '11:00 AM', 'period': 'Late Morning', 'amount': '${(perMeal * 0.18).toStringAsFixed(3)} kg', 'percentage': '18'},
          {'time': '02:00 PM', 'period': 'Afternoon', 'amount': '${(perMeal * 0.17).toStringAsFixed(3)} kg', 'percentage': '17'},
          {'time': '05:00 PM', 'period': 'Evening', 'amount': '${(perMeal * 0.18).toStringAsFixed(3)} kg', 'percentage': '18'},
          {'time': '08:00 PM', 'period': 'Night', 'amount': '${(perMeal * 0.12).toStringAsFixed(3)} kg', 'percentage': '12'},
        ];
      } else if (feedingFrequency == 5) {
        // Early growth: 6:00, 9:30, 13:00, 16:30, 20:00
        schedule = [
          {'time': '06:00 AM', 'period': 'Morning', 'amount': '${(perMeal * 0.20).toStringAsFixed(3)} kg', 'percentage': '20'},
          {'time': '09:30 AM', 'period': 'Mid-Morning', 'amount': '${(perMeal * 0.20).toStringAsFixed(3)} kg', 'percentage': '20'},
          {'time': '01:00 PM', 'period': 'Afternoon', 'amount': '${(perMeal * 0.20).toStringAsFixed(3)} kg', 'percentage': '20'},
          {'time': '04:30 PM', 'period': 'Evening', 'amount': '${(perMeal * 0.25).toStringAsFixed(3)} kg', 'percentage': '25'},
          {'time': '08:00 PM', 'period': 'Night', 'amount': '${(perMeal * 0.15).toStringAsFixed(3)} kg', 'percentage': '15'},
        ];
      } else if (feedingFrequency == 4) {
        // Standard: 6:00, 11:00, 16:00, 20:00
        schedule = [
          {'time': '06:00 AM', 'period': 'Morning', 'amount': '${(perMeal * 0.25).toStringAsFixed(3)} kg', 'percentage': '25'},
          {'time': '11:00 AM', 'period': 'Late Morning', 'amount': '${(perMeal * 0.25).toStringAsFixed(3)} kg', 'percentage': '25'},
          {'time': '04:00 PM', 'period': 'Evening', 'amount': '${(perMeal * 0.30).toStringAsFixed(3)} kg', 'percentage': '30'},
          {'time': '08:00 PM', 'period': 'Night', 'amount': '${(perMeal * 0.20).toStringAsFixed(3)} kg', 'percentage': '20'},
        ];
      } else {
        // Mature: 7:00, 13:00, 19:00
        schedule = [
          {'time': '07:00 AM', 'period': 'Morning', 'amount': '${(perMeal * 0.30).toStringAsFixed(3)} kg', 'percentage': '30'},
          {'time': '01:00 PM', 'period': 'Afternoon', 'amount': '${(perMeal * 0.40).toStringAsFixed(3)} kg', 'percentage': '40'},
          {'time': '07:00 PM', 'period': 'Evening', 'amount': '${(perMeal * 0.30).toStringAsFixed(3)} kg', 'percentage': '30'},
        ];
      }
      
      setState(() {
        _feedResult = {
          'dailyFeed': dailyFeed.toStringAsFixed(2),
          'frequency': feedingFrequency.toString(),
          'perMeal': perMeal.toStringAsFixed(3),
          'weeklyFeed': weeklyFeed.toStringAsFixed(2),
          'monthly': monthlyFeed.toStringAsFixed(2),
          'schedule': schedule,
          
          // Additional metrics
          'totalBiomass': totalBiomass.toStringAsFixed(2),
          'stockingDensity': stockingDensity.toStringAsFixed(1),
          'biomassPerArea': biomassPerArea.toStringAsFixed(2),
          'feedType': feedType,
          'feedingRate': (feedingRate * 100).toStringAsFixed(1),
          'estimatedFCR': estimatedFCR.toStringAsFixed(2),
          'weeklyGrowth': expectedWeeklyGain.toStringAsFixed(2),
          'survivalRate': survivalRate,
          'densityStatus': densityStatus,
          
          // Cost estimates (assuming ₹80/kg for feed)
          'dailyCost': (dailyFeed * 80).toStringAsFixed(2),
          'monthlyCost': (monthlyFeed * 80).toStringAsFixed(2),
          
          // Recommendations
          'recommendations': _generateRecommendations(
            stockingDensity, 
            avgSize, 
            biomassPerArea,
            feedingRate,
          ),
        };
        _isCalculating = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Feed calculation completed successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isCalculating = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error during calculation: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
  
  List<String> _generateRecommendations(
    double stockingDensity,
    double avgSize,
    double biomassPerArea,
    double feedingRate,
  ) {
    List<String> recommendations = [];
    
    // Stocking density recommendations
    if (stockingDensity > 100) {
      recommendations.add('⚠️ Very high stocking density (${stockingDensity.toStringAsFixed(0)} pcs/m²). Consider reducing population or increasing aeration.');
    } else if (stockingDensity > 60) {
      recommendations.add('⚡ High stocking density detected. Monitor water quality closely, especially DO levels.');
    } else if (stockingDensity < 20) {
      recommendations.add('✅ Low stocking density provides optimal growing conditions and disease resistance.');
    }
    
    // Size-based recommendations
    if (avgSize < 3) {
      recommendations.add('🦐 Juvenile stage: Use high-protein starter feed (38-40%). Feed frequently (6 times/day) in small amounts.');
      recommendations.add('💡 Monitor water temperature (28-31°C optimal) and maintain excellent water quality.');
    } else if (avgSize < 8) {
      recommendations.add('📈 Early growth stage: Gradually transition to grower feed. Monitor growth rate weekly.');
      recommendations.add('🔍 Check feed trays 1-2 hours after feeding to adjust quantities.');
    } else if (avgSize < 15) {
      recommendations.add('💪 Mid-growth stage: Focus on consistent feeding schedule. Good time to optimize FCR.');
    } else if (avgSize < 25) {
      recommendations.add('🎯 Late growth stage: Prepare for harvest in 2-4 weeks. Reduce feeding rate slightly.');
    } else {
      recommendations.add('🏆 Harvest size reached! Consider market prices and harvest planning.');
      recommendations.add('📊 Reduce feeding to 2-3 times per day. Focus on maintaining weight.');
    }
    
    // Biomass recommendations
    if (biomassPerArea > 3.0) {
      recommendations.add('⚠️ High biomass density (${biomassPerArea.toStringAsFixed(1)} kg/m²). Increase water exchange rate.');
      recommendations.add('💨 Ensure adequate aeration (>4 ppm dissolved oxygen at all times).');
    } else if (biomassPerArea > 2.0) {
      recommendations.add('📊 Moderate biomass. Maintain regular water exchange (10-15% daily).');
    }
    
    // Feeding efficiency
    recommendations.add('🎯 Target FCR: 1.2-1.5. Current estimate: 1.35 (Good)');
    recommendations.add('⏰ Feed during active periods: early morning, late afternoon, and evening for best results.');
    
    // Water quality
    recommendations.add('💧 Maintain water parameters: pH 7.5-8.5, Salinity 15-25 ppt, Temperature 28-31°C.');
    recommendations.add('🧪 Test water quality daily: Ammonia <0.1 ppm, Nitrite <0.1 ppm, DO >4 ppm.');
    
    // Feed management
    recommendations.add('📦 Store feed in cool, dry place. Use within 45 days of manufacturing.');
    recommendations.add('🍽️ Use feeding trays (check trays method) to monitor consumption and adjust quantities.');
    
    return recommendations;
  }
}
