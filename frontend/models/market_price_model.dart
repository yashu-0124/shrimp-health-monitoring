class MarketPriceModel {
  final String market;
  final String size;
  final String price;
  final String unit;
  final String trend;
  final String change;
  final DateTime timestamp;

  MarketPriceModel({
    required this.market,
    required this.size,
    required this.price,
    required this.unit,
    required this.trend,
    required this.change,
    required this.timestamp,
  });

  factory MarketPriceModel.fromAgmarknetData(
    Map<String, dynamic> json,
    Map<String, dynamic>? previousData,
  ) {
    final modalPrice = json['modal_price'];
    final minPrice = json['min_price'];
    final maxPrice = json['max_price'];
    final market = json['market'] ?? json['mandi'] ?? 'Unknown';
    final commodity = json['commodity'] ?? '';

    // Extract shrimp count from commodity name
    String size = _extractShrimpCount(commodity);

    // Calculate average price
    double currentPrice = 0;
    if (modalPrice != null && modalPrice != '' && modalPrice != '-') {
      currentPrice = double.tryParse(modalPrice.toString()) ?? 0;
    } else if (minPrice != null && maxPrice != null) {
      final min = double.tryParse(minPrice.toString()) ?? 0;
      final max = double.tryParse(maxPrice.toString()) ?? 0;
      currentPrice = (min + max) / 2;
    }

    // Calculate trend and change
    String trend = 'stable';
    String change = '0%';

    if (previousData != null) {
      final prevModalPrice = previousData['modal_price'];
      double previousPrice = 0;

      if (prevModalPrice != null && prevModalPrice != '' && prevModalPrice != '-') {
        previousPrice = double.tryParse(prevModalPrice.toString()) ?? 0;
      }

      if (previousPrice > 0 && currentPrice > 0) {
        final diff = currentPrice - previousPrice;
        final percentChange = (diff / previousPrice) * 100;

        if (percentChange > 0.5) {
          trend = 'up';
          change = '+${percentChange.toStringAsFixed(1)}%';
        } else if (percentChange < -0.5) {
          trend = 'down';
          change = '${percentChange.toStringAsFixed(1)}%';
        } else {
          trend = 'stable';
          change = '0%';
        }
      }
    }

    return MarketPriceModel(
      market: market,
      size: size,
      price: '₹${currentPrice.toStringAsFixed(0)}',
      unit: 'per kg',
      trend: trend,
      change: change,
      timestamp: DateTime.now(),
    );
  }

  static String _extractShrimpCount(String commodity) {
    final lower = commodity.toLowerCase();

    if (lower.contains('30') || lower.contains('thirty')) {
      return '30 count';
    } else if (lower.contains('40') || lower.contains('forty')) {
      return '40 count';
    } else if (lower.contains('50') || lower.contains('fifty')) {
      return '50 count';
    } else if (lower.contains('60') || lower.contains('sixty')) {
      return '60 count';
    } else if (lower.contains('70') || lower.contains('seventy')) {
      return '70 count';
    } else if (lower.contains('80') || lower.contains('eighty')) {
      return '80 count';
    } else if (lower.contains('100') || lower.contains('hundred')) {
      return '100 count';
    } else if (lower.contains('large') || lower.contains('jumbo')) {
      return '30 count';
    } else if (lower.contains('medium')) {
      return '50 count';
    } else if (lower.contains('small')) {
      return '70 count';
    }

    // Default classification based on typical market sizes
    return '40 count';
  }

  Map<String, dynamic> toJson() {
    return {
      'market': market,
      'size': size,
      'price': price,
      'unit': unit,
      'trend': trend,
      'change': change,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MarketPriceModel.fromJson(Map<String, dynamic> json) {
    return MarketPriceModel(
      market: json['market'],
      size: json['size'],
      price: json['price'],
      unit: json['unit'],
      trend: json['trend'],
      change: json['change'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'market': market,
      'size': size,
      'price': price,
      'unit': unit,
      'trend': trend,
      'change': change,
    };
  }
}
