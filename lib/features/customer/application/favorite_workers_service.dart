import 'package:book_me_mobile_app/features/shared/domain/entities/provider.dart';
import 'package:flutter/foundation.dart';

class FavoriteWorkersService {
  FavoriteWorkersService._();

  static final FavoriteWorkersService instance = FavoriteWorkersService._();

  final ValueNotifier<List<Provider>> favorites = ValueNotifier(<Provider>[]);

  bool isFavorite(String providerId) {
    return favorites.value.any((provider) => provider.id == providerId);
  }

  void toggle(Provider provider) {
    final current = List<Provider>.from(favorites.value);
    final index = current.indexWhere((item) => item.id == provider.id);

    if (index >= 0) {
      current.removeAt(index);
    } else {
      current.add(provider);
    }

    favorites.value = current;
  }
}
