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
    profilePhoto: 'https://i.pravatar.cc/300?img=12',
    skills: ['Plumber'],
    serviceAreas: ['Colombo 05', 'Colombo 07', 'Rajagiriya'],
    experienceYears: 6,
    availability: 'Mon-Sat | 08:00-18:00',
    priceMin: 2500,
    priceMax: 4500,
    ratingAvg: 4.9,
    ratingCount: 148,
    nicVerified: true,
    photoVerified: true,
  ),
  Provider(
    id: 'provider_kasun',
    userId: 'user_provider_kasun',
    profilePhoto: 'https://i.pravatar.cc/300?img=32',
    skills: ['Electrician'],
    serviceAreas: ['Nugegoda', 'Maharagama', 'Kohuwala'],
    experienceYears: 4,
    availability: 'Mon-Fri | 09:00-17:00',
    priceMin: 3000,
    priceMax: 5200,
    ratingAvg: 4.8,
    ratingCount: 96,
    nicVerified: true,
    photoVerified: true,
  ),
  Provider(
    id: 'provider_sajini',
    userId: 'user_provider_sajini',
    profilePhoto: 'https://i.pravatar.cc/300?img=47',
    skills: ['Cleaner'],
    serviceAreas: ['Dehiwala', 'Mount Lavinia', 'Bambalapitiya'],
    experienceYears: 5,
    availability: 'Daily | 07:00-19:00',
    priceMin: 1800,
    priceMax: 3200,
    ratingAvg: 5.0,
    ratingCount: 182,
    nicVerified: true,
    photoVerified: true,
  ),
  Provider(
    id: 'provider_dinesh',
    userId: 'user_provider_dinesh',
    profilePhoto: 'https://i.pravatar.cc/300?img=15',
    skills: ['Carpenter'],
    serviceAreas: ['Kandy City', 'Peradeniya', 'Katugastota'],
    experienceYears: 8,
    availability: 'Tue-Sun | 08:30-17:30',
    priceMin: 3500,
    priceMax: 7000,
    ratingAvg: 4.9,
    ratingCount: 111,
    nicVerified: true,
    photoVerified: true,
  ),
  Provider(
    id: 'provider_tharindu',
    userId: 'user_provider_tharindu',
    profilePhoto: 'https://i.pravatar.cc/300?img=3',
    skills: ['Plumber', 'Electrician'],
    serviceAreas: ['Galle', 'Unawatuna', 'Hikkaduwa'],
    experienceYears: 7,
    availability: 'Daily | Emergency 24/7',
    priceMin: 2800,
    priceMax: 5600,
    ratingAvg: 4.9,
    ratingCount: 87,
    nicVerified: true,
    photoVerified: true,
  ),
];
