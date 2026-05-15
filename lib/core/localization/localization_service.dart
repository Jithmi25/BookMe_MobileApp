import 'package:flutter/widgets.dart';

class LocalizationService {
  LocalizationService._internal();

  static final LocalizationService instance = LocalizationService._internal();

  final ValueNotifier<Locale> locale = ValueNotifier(const Locale('en'));

  static const Map<String, Map<String, String>> _translations = {
    'en': {
      'home_title': 'Find Providers',
      'wanted_title': 'Wanted',
      'activities_title': 'Your Activities',
      'account_title': 'Account',
      'book_request': 'Request booking',
      'post_wanted': 'Post wanted ad',
      'footer_home': 'Home',
      'footer_activities': 'Activities',
      'footer_account': 'Account',
      'footer_notifications': 'Notifications',
      'favorites': 'Favourite workers',
      'chat': 'Chat',
      'rebook': 'Re-book',
      'wallet': 'Secure wallet',
      'price_estimator': 'Price estimate',
      'calendar_slots': 'Calendar booking slots',
      'sos': 'SOS / Panic',
      'emergency_alert': 'Send emergency alert',
      'ongoing': 'Ongoing',
      'completed': 'Completed',
      'disputed': 'Disputed',
      'complaints': 'Complaints',
      'cancelled': 'Cancelled',
      'post_success': 'Your wanted ad was posted',
    },
    'si': {
      'home_title': 'සැපයුම්කරුවන් සොයන්න',
      'wanted_title': 'වන්ටඩ්',
      'activities_title': 'ඔබේ ක්‍රියාකාරකම්',
      'account_title': 'ගිණුම',
      'book_request': 'බුකින් ඉල්ලීම',
      'post_wanted': 'අවශ්‍ය විජ්ඡාපනය පළ කරන්න',
      'footer_home': 'මුල් පිටුව',
      'footer_activities': 'සංචාර',
      'footer_account': 'ගිණුම',
      'footer_notifications': 'නිවේදන',
      'favorites': 'ප්‍රියතම සේවාකරුවන්',
      'chat': 'කතාබහ',
      'rebook': 'නැවත බුක් කරන්න',
      'wallet': 'ආරක්ෂිත පසුම්බිය',
      'price_estimator': 'මිල ඇස්තමේන්තුව',
      'calendar_slots': 'කාල පටිත්ත බුකින්',
      'sos': 'SOS / ආපදා',
      'emergency_alert': 'හදිසි අනතුරු හැරීම',
      'ongoing': 'දැන් සිදුවන',
      'completed': 'සම්පූර්ණ',
      'disputed': 'ගැටළු සහිත',
      'complaints': 'පැමිණිලි',
      'cancelled': 'අවලංගු',
      'post_success': 'ඔබගේ වන්ටඩ් දැන් පළ වී ඇත',
    },
    'ta': {
      'home_title': 'சேவையாளர் தேடு',
      'wanted_title': 'விரும்பப்படுகிறது',
      'activities_title': 'உங்கள் செயல்பாடுகள்',
      'account_title': 'கணக்கு',
      'book_request': 'புக்கிங் கோரிக்கை',
      'post_wanted': 'வேண்டும் விளம்பரம் இடுங்கள்',
      'footer_home': 'முகப்பு',
      'footer_activities': 'செயல்கள்',
      'footer_account': 'கணக்கு',
      'footer_notifications': 'அறிவிப்புகள்',
      'favorites': 'பிடித்த பணியாளர்கள்',
      'chat': 'அரட்டை',
      'rebook': 'மீண்டும் பதிவு',
      'wallet': 'பாதுகாப்பான பணப்பை',
      'price_estimator': 'விலை மதிப்பீடு',
      'calendar_slots': 'கால அட்டவணை நேரங்கள்',
      'sos': 'SOS / அவசரம்',
      'emergency_alert': 'அவசர எச்சரிக்கை அனுப்பு',
      'ongoing': 'நடப்பு',
      'completed': 'முடிந்தது',
      'disputed': 'விவாதம்',
      'complaints': 'புகார்கள்',
      'cancelled': 'ரத்து',
      'post_success': 'உங்கள் விளம்பரம் பதிக்கப்பட்டது',
    },
  };

  String t(String key) {
    final lang = locale.value.languageCode;
    return _translations[lang]?[key] ?? _translations['en']![key] ?? key;
  }

  void setLocale(Locale newLocale) {
    locale.value = newLocale;
  }
}
