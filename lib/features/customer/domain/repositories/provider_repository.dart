import 'package:book_me_mobile_app/features/shared/domain/entities/provider.dart';

abstract class ProviderRepository {
  Future<List<Provider>> getProviders({
    String selectedCategory = 'All',
    String searchQuery = '',
  });
}
