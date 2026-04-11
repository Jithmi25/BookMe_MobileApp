import 'package:book_me_mobile_app/app/constants/constants.dart';
import 'package:book_me_mobile_app/features/customer/data/local_mock_provider_repository.dart';
import 'package:book_me_mobile_app/features/customer/domain/repositories/provider_repository.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreProviderRepository implements ProviderRepository {
  FirestoreProviderRepository({
    FirebaseFirestore? firestore,
    LocalMockProviderRepository? fallbackRepository,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _fallbackRepository = fallbackRepository ?? const LocalMockProviderRepository();

  final FirebaseFirestore _firestore;
  final LocalMockProviderRepository _fallbackRepository;

  @override
  Future<List<Provider>> getProviders({
    String selectedCategory = 'All',
    String searchQuery = '',
  }) async {
    if (Firebase.apps.isEmpty) {
      return _fallbackRepository.getProviders(
        selectedCategory: selectedCategory,
        searchQuery: searchQuery,
      );
    }

    Query<Map<String, dynamic>> query = _firestore.collection(
      FirestoreCollections.providers,
    );

    if (selectedCategory != 'All') {
      query = query.where('skills', arrayContains: selectedCategory);
    }

    final snapshot = await query.get();

    final providers = snapshot.docs
        .map((doc) {
          final data = doc.data();
          if ((data['id'] as String?)?.isEmpty ?? true) {
            data['id'] = doc.id;
          }
          return Provider.fromJson(data);
        })
        .where((provider) => provider.id.isNotEmpty)
        .toList(growable: false);

    final normalizedQuery = searchQuery.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return providers;
    }

    return providers
        .where((provider) {
          final skills = provider.skills
              .map((skill) => skill.toLowerCase())
              .toList(growable: false);
          final areas = provider.serviceAreas
              .map((area) => area.toLowerCase())
              .toList(growable: false);

          return provider.id.toLowerCase().contains(normalizedQuery) ||
              skills.any((skill) => skill.contains(normalizedQuery)) ||
              areas.any((area) => area.contains(normalizedQuery));
        })
        .toList(growable: false);
  }
}
