import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aqa_shrimp_ai/l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import 'profile_page.dart';
import 'about_page.dart';

/// Settings Page
/// Manages app settings including account, notifications, language, and about sections
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Account Section
            _buildSectionCard(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_circle,
                    color: Color(0xFF4A90E2),
                    size: 28,
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context)!.account,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!.manageYourProfile,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Notifications Section
            _buildSectionCard(
              child: SwitchListTile(
                secondary: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.notifications_active,
                    color: Color(0xFF4A90E2),
                    size: 28,
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context)!.notifications,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  _notificationsEnabled
                      ? AppLocalizations.of(context)!.notificationsEnabled
                      : AppLocalizations.of(context)!.notificationsDisabled,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                value: _notificationsEnabled,
                activeColor: const Color(0xFF4A90E2),
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                  // TODO: Save notification preference to SharedPreferences
                },
              ),
            ),
            const SizedBox(height: 12),

            // Language Section
            _buildSectionCard(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.language,
                    color: Color(0xFF4A90E2),
                    size: 28,
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context)!.languageChange,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  localeProvider.getLanguageName(localeProvider.locale.languageCode),
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showLanguageDialog(context, localeProvider),
              ),
            ),
            const SizedBox(height: 12),

            // About Section
            _buildSectionCard(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90E2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.info,
                    color: Color(0xFF4A90E2),
                    size: 28,
                  ),
                ),
                title: Text(
                  AppLocalizations.of(context)!.about,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  AppLocalizations.of(context)!.appInfo,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutPage(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
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
      child: child,
    );
  }

  void _showLanguageDialog(BuildContext context, LocaleProvider localeProvider) {
    final languages = [
      {'name': 'English', 'code': 'en'},
      {'name': 'తెలుగు (Telugu)', 'code': 'te'},
      {'name': 'हिंदी (Hindi)', 'code': 'hi'},
      {'name': 'தமிழ் (Tamil)', 'code': 'ta'},
      {'name': 'ಕನ್ನಡ (Kannada)', 'code': 'kn'},
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.selectLanguage),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              itemBuilder: (context, index) {
                final language = languages[index];
                final isSelected = localeProvider.locale.languageCode == language['code'];
                
                return ListTile(
                  title: Text(
                    language['name']!,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? const Color(0xFF4A90E2) : Colors.black87,
                    ),
                  ),
                  leading: Radio<String>(
                    value: language['code']!,
                    groupValue: localeProvider.locale.languageCode,
                    activeColor: const Color(0xFF4A90E2),
                    onChanged: (value) {
                      if (value != null) {
                        localeProvider.setLocale(Locale(value));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.languageChanged,
                            ),
                            duration: const Duration(seconds: 2),
                            backgroundColor: const Color(0xFF4A90E2),
                          ),
                        );
                      }
                    },
                  ),
                  onTap: () {
                    localeProvider.setLocale(Locale(language['code']!));
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context)!.languageChanged,
                        ),
                        duration: const Duration(seconds: 2),
                        backgroundColor: const Color(0xFF4A90E2),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: const TextStyle(color: Color(0xFF4A90E2)),
              ),
            ),
          ],
        );
      },
    );
  }
}
