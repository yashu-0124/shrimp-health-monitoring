import 'package:flutter/material.dart';
import 'package:aqa_shrimp_ai/l10n/app_localizations.dart';

/// Disease Info Widget
/// Displays common shrimp diseases with expandable information
class DiseaseInfoSection extends StatelessWidget {
  const DiseaseInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final diseases = _getDiseases(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.coronavirus, color: Color(0xFF4A90E2), size: 28),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.commonDiseases,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: diseases.length,
            itemBuilder: (context, index) {
              final disease = diseases[index];
              return _DiseaseCard(disease: disease);
            },
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getDiseases(BuildContext context) {
    return [
      {
        'name': 'White Spot Syndrome (WSSV)',
        'icon': Icons.circle,
        'color': const Color(0xFFE74C3C),
        'symptoms': AppLocalizations.of(context)!.wssvSymptoms,
        'prevention': AppLocalizations.of(context)!.wssvPrevention,
      },
      {
        'name': 'EMS / AHPND',
        'icon': Icons.warning,
        'color': const Color(0xFFF39C12),
        'symptoms': AppLocalizations.of(context)!.emsSymptoms,
        'prevention': AppLocalizations.of(context)!.emsPrevention,
      },
      {
        'name': 'IHHNV',
        'icon': Icons.bug_report,
        'color': const Color(0xFF9B59B6),
        'symptoms': AppLocalizations.of(context)!.ihhnvSymptoms,
        'prevention': AppLocalizations.of(context)!.ihhnvPrevention,
      },
      {
        'name': 'Yellow Head Disease',
        'icon': Icons.science,
        'color': const Color(0xFFF1C40F),
        'symptoms': AppLocalizations.of(context)!.yhdSymptoms,
        'prevention': AppLocalizations.of(context)!.yhdPrevention,
      },
    ];
  }
}

class _DiseaseCard extends StatelessWidget {
  final Map<String, dynamic> disease;

  const _DiseaseCard({required this.disease});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showDiseaseDetails(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: disease['color'].withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        disease['icon'],
                        color: disease['color'],
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        disease['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.symptoms + ':',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Expanded(
                  child: Text(
                    disease['symptoms'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                      height: 1.3,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.learnMore,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: disease['color'],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: disease['color'],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDiseaseDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(disease['icon'], color: disease['color']),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                disease['name'],
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.symptoms + ':',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                disease['symptoms'],
                style: const TextStyle(fontSize: 13, height: 1.5),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.prevention + ':',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                disease['prevention'],
                style: const TextStyle(fontSize: 13, height: 1.5),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.close,
              style: const TextStyle(color: Color(0xFF4A90E2)),
            ),
          ),
        ],
      ),
    );
  }
}
