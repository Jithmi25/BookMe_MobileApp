import 'package:book_me_mobile_app/features/shared/domain/entities/provider.dart';

class LocalMockProviderRepository {
  const LocalMockProviderRepository();

  static const List<String> categories = [
    'All',
    'Plumber',
    'Carpenter',
    'Electrician',
    'Cleaner',
  ];

  List<Provider> getProviders({
    String selectedCategory = 'All',
    String searchQuery = '',
  }) {
    final normalizedQuery = searchQuery.trim().toLowerCase();

    return _providers
        .where((provider) {
          final skills = provider.skills
              .map((skill) => skill.toLowerCase())
              .toList();
          final areas = provider.serviceAreas
              .map((area) => area.toLowerCase())
              .toList();

          final matchesCategory =
              selectedCategory == 'All' ||
              provider.skills.any(
                (skill) =>
                    skill.toLowerCase() == selectedCategory.toLowerCase(),
              );

          if (!matchesCategory) {
            return false;
          }

          if (normalizedQuery.isEmpty) {
            return true;
          }

          return provider.id.toLowerCase().contains(normalizedQuery) ||
              skills.any((skill) => skill.contains(normalizedQuery)) ||
              areas.any((area) => area.contains(normalizedQuery));
        })
        .toList(growable: false);
  }
}

const List<Provider> _providers = [
  Provider(
    id: 'provider_nimal',
    userId: 'user_provider_nimal',
    skills: ['Plumber'],
    serviceAreas: ['Colombo 05', 'Colombo 07'],
    experienceYears: 6,
    availability: 'Mon-Sat',
    priceMin: 2500,
    priceMax: 4500,
    ratingAvg: 4.6,
    ratingCount: 48,
    nicVerified: true,
    photoVerified: true,
  ),
  Provider(
    id: 'provider_kasun',
    userId: 'user_provider_kasun',
    skills: ['Electrician'],
    serviceAreas: ['Nugegoda', 'Maharagama'],
    experienceYears: 4,
    availability: 'Mon-Fri',
    priceMin: 3000,
    priceMax: 5200,
    ratingAvg: 4.4,
    ratingCount: 33,
    nicVerified: true,
    photoVerified: false,
  ),
  Provider(
    id: 'provider_sajini',
    userId: 'user_provider_sajini',
    skills: ['Cleaner'],
    serviceAreas: ['Dehiwala', 'Mount Lavinia'],
    experienceYears: 5,
    availability: 'Daily',
    priceMin: 1800,
    priceMax: 3200,
    ratingAvg: 4.8,
    ratingCount: 76,
    nicVerified: true,
    photoVerified: true,
  ),
  Provider(
    id: 'provider_dinesh',
    userId: 'user_provider_dinesh',
    skills: ['Carpenter'],
    serviceAreas: ['Kandy City', 'Peradeniya'],
    experienceYears: 8,
    availability: 'Tue-Sun',
    priceMin: 3500,
    priceMax: 7000,
    ratingAvg: 4.7,
    ratingCount: 59,
    nicVerified: false,
    photoVerified: true,
  ),
  Provider(
    id: 'provider_tharindu',
    userId: 'user_provider_tharindu',
    skills: ['Plumber', 'Electrician'],
    serviceAreas: ['Galle', 'Unawatuna'],
    experienceYears: 7,
    availability: 'Daily',
    priceMin: 2800,
    priceMax: 5600,
    ratingAvg: 4.5,
    ratingCount: 41,
    nicVerified: true,
    photoVerified: true,
  ),
];
