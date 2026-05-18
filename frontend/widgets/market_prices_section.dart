import 'package:flutter/material.dart';
import 'package:aqa_shrimp_ai/l10n/app_localizations.dart';
import '../services/market_price_service.dart';

/// Market Prices Widget - Responsive Design
/// Displays current shrimp market prices by location
/// Adapts layout based on screen size: Mobile (horizontal scroll), Tablet (2 columns), Desktop (4 columns)
class MarketPricesSection extends StatefulWidget {
  const MarketPricesSection({super.key});

  @override
  State<MarketPricesSection> createState() => _MarketPricesSectionState();
}

class _MarketPricesSectionState extends State<MarketPricesSection> {
  String _selectedState = 'Andhra Pradesh';
  bool _isLoading = false;
  List<Map<String, dynamic>> _prices = [];
  final MarketPriceService _priceService = MarketPriceService();

  @override
  void initState() {
    super.initState();
    _loadPrices();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1024;
    
    // Responsive padding and sizing
    final horizontalPadding = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);
    final titleFontSize = isDesktop ? 24.0 : (isTablet ? 22.0 : 20.0);
    final iconSize = isDesktop ? 32.0 : (isTablet ? 30.0 : 28.0);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 12),
          child: Row(
            children: [
              Icon(Icons.currency_rupee, color: const Color(0xFF4A90E2), size: iconSize),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  AppLocalizations.of(context)!.marketPrices,
                  style: TextStyle(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF333333),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // State Selector
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 400 : double.infinity,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF4A90E2).withOpacity(0.3)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedState,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF4A90E2)),
                items: [
                  'Andhra Pradesh',
                  'Tamil Nadu',
                  'Odisha',
                  'West Bengal',
                  'Gujarat',
                ].map((String state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedState = newValue;
                    });
                    _loadPrices();
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Prices List - Responsive Layout
        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_prices.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Icon(
                    Icons.cloud_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No real-time data available',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'API rate limit reached.\nPlease register at data.gov.in for a new API key.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          LayoutBuilder(
            builder: (context, constraints) {
              // Determine layout based on screen size
              if (isDesktop) {
                // Desktop: 4 column grid
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.85,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _prices.length,
                    itemBuilder: (context, index) {
                      return _PriceCard(price: _prices[index], isMobile: false);
                    },
                  ),
                );
              } else if (isTablet) {
                // Tablet: 2 column grid
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.0,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _prices.length,
                    itemBuilder: (context, index) {
                      return _PriceCard(price: _prices[index], isMobile: false);
                    },
                  ),
                );
              } else {
                // Mobile: horizontal scroll
                return SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _prices.length,
                    itemBuilder: (context, index) {
                      return _PriceCard(price: _prices[index], isMobile: true);
                    },
                  ),
                );
              }
            },
          ),
      ],
    );
  }

  Future<void> _loadPrices() async {
    if (!mounted) return;

    print('\n🔄 === MARKET PRICES LOADING START ===');
    print('📍 Selected State: $_selectedState');

    setState(() {
      _isLoading = true;
    });

    try {
      print('⏳ Calling MarketPriceService...');
      final priceModels = await _priceService.fetchMarketPrices(_selectedState);

      print('📊 Received ${priceModels.length} price models');
      
      for (var i = 0; i < priceModels.length && i < 3; i++) {
        final model = priceModels[i];
        print('   Price $i: ${model.market} - ${model.size} - ${model.price}');
      }

      if (!mounted) return;

      setState(() {
        _prices = priceModels.map((model) => model.toMap()).toList();
        _isLoading = false;
      });

      print('✅ UI Updated with ${_prices.length} prices');
      print('🔄 === MARKET PRICES LOADING COMPLETE ===\n');
    } catch (e) {
      print('❌ Error loading prices: $e');
      print('Stack: ${StackTrace.current}');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
      
      print('⚠️ === MARKET PRICES LOADING FAILED ===\n');
    }
  }
}

// Responsive Price Card Widget
class _PriceCard extends StatelessWidget {
  final Map<String, dynamic> price;
  final bool isMobile;

  const _PriceCard({
    required this.price,
    this.isMobile = true,
  });

  @override
  Widget build(BuildContext context) {
    Color trendColor;
    IconData trendIcon;

    switch (price['trend']) {
      case 'up':
        trendColor = Colors.green;
        trendIcon = Icons.trending_up;
        break;
      case 'down':
        trendColor = Colors.red;
        trendIcon = Icons.trending_down;
        break;
      default:
        trendColor = Colors.grey;
        trendIcon = Icons.trending_flat;
    }

    return Container(
      width: isMobile ? 200 : null,
      margin: isMobile 
          ? const EdgeInsets.symmetric(horizontal: 4, vertical: 8)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Size and Trend Badge Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      price['size'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A90E2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: trendColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(trendIcon, size: 14, color: trendColor),
                      const SizedBox(width: 4),
                      Text(
                        price['change'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: trendColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Market Name
            Text(
              price['market'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            
            const Spacer(),
            
            // Price and Unit Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    price['price'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A90E2),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    price['unit'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            
            // Timestamp
            Text(
              'Updated: ${DateTime.now().toString().substring(0, 10)}',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
