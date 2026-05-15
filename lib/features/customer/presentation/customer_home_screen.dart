import 'package:book_me_mobile_app/app/router/app_router.dart';
import 'package:book_me_mobile_app/core/localization/localization_service.dart';
import 'package:book_me_mobile_app/features/auth/application/auth_controller.dart';
import 'package:book_me_mobile_app/features/customer/application/favorite_workers_service.dart';
import 'package:book_me_mobile_app/features/customer/data/firestore_provider_repository.dart';
import 'package:book_me_mobile_app/features/customer/domain/repositories/provider_repository.dart';
import 'package:book_me_mobile_app/features/customer/presentation/activities_screen.dart';
import 'package:book_me_mobile_app/features/customer/presentation/booking_request_screen.dart';
import 'package:book_me_mobile_app/features/customer/presentation/customer_notifications_screen.dart';
import 'package:book_me_mobile_app/features/customer/presentation/customer_profile_screen.dart';
import 'package:book_me_mobile_app/features/customer/presentation/provider_profile_screen.dart';
import 'package:book_me_mobile_app/features/customer/presentation/secure_chat_screen.dart';
import 'package:book_me_mobile_app/features/customer/presentation/wanted_screen.dart';
import 'package:book_me_mobile_app/features/customer/presentation/widgets/provider_card.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/provider.dart';
import 'package:book_me_mobile_app/features/shared/presentation/widgets/async_state_widgets.dart';
import 'package:flutter/material.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({required this.authController, super.key});

  final AuthController authController;

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  static const List<_ServiceCategory> _categories = [
    _ServiceCategory('All', Icons.grid_view_rounded),
    _ServiceCategory('Plumber', Icons.plumbing_rounded),
    _ServiceCategory('Carpenter', Icons.handyman_rounded),
    _ServiceCategory('Electrician', Icons.electrical_services_rounded),
    _ServiceCategory('Cleaner', Icons.cleaning_services_rounded),
  ];

  final ProviderRepository _repository = FirestoreProviderRepository();

  String _selectedCategory = 'All';
  String _searchQuery = '';
  late Future<List<Provider>> _providersFuture;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _providersFuture = _loadProviders();
  }

  Future<List<Provider>> _loadProviders() {
    return _repository.getProviders(
      selectedCategory: _selectedCategory,
      searchQuery: _searchQuery,
    );
  }

  void _refreshProviders() {
    setState(() {
      _providersFuture = _loadProviders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.authController.state;
    final customerId = state.phoneNumber ?? 'customer_guest';
    final loc = LocalizationService.instance;

    return ValueListenableBuilder<Locale>(
      valueListenable: loc.locale,
      builder: (_, __, ___) {
        final title = switch (_currentIndex) {
          1 => loc.t('activities_title'),
          2 => loc.t('account_title'),
          3 => loc.t('footer_notifications'),
          _ => loc.t('home_title'),
        };

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.translate_rounded),
                onSelected: (value) {
                  final localeCode = switch (value) {
                    'si' => const Locale('si'),
                    'ta' => const Locale('ta'),
                    _ => const Locale('en'),
                  };
                  loc.setLocale(localeCode);
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'en', child: Text('English')),
                  PopupMenuItem(value: 'si', child: Text('සිංහල')),
                  PopupMenuItem(value: 'ta', child: Text('தமிழ்')),
                ],
              ),
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.customerProfile);
                },
                icon: const Icon(Icons.person_outline),
                tooltip: loc.t('footer_account'),
              ),
              IconButton(
                onPressed: () {
                  widget.authController.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.roleSelection,
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: SafeArea(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                _HomeTab(
                  customerId: customerId,
                  providersFuture: _providersFuture,
                  onSearchChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                    _refreshProviders();
                  },
                  selectedCategory: _selectedCategory,
                  categories: _categories,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                    _refreshProviders();
                  },
                  onRefresh: _refreshProviders,
                  onOpenBooking: (provider) {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => BookingRequestScreen(
                          provider: provider,
                          customerId: customerId,
                        ),
                      ),
                    );
                  },
                  onOpenChat: (provider) {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => SecureChatScreen(
                          provider: provider,
                          customerId: customerId,
                        ),
                      ),
                    );
                  },
                ),
                ActivitiesScreen(customerId: customerId, loc: loc),
                _AccountTab(
                  customerId: customerId,
                  authController: widget.authController,
                ),
                const CustomerNotificationsScreen(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                label: loc.t('footer_home'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.work_history_rounded),
                label: loc.t('footer_activities'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                label: loc.t('footer_account'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.notifications_outlined),
                label: loc.t('footer_notifications'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({
    required this.customerId,
    required this.providersFuture,
    required this.onSearchChanged,
    required this.selectedCategory,
    required this.categories,
    required this.onCategorySelected,
    required this.onRefresh,
    required this.onOpenBooking,
    required this.onOpenChat,
  });

  final String customerId;
  final Future<List<Provider>> providersFuture;
  final ValueChanged<String> onSearchChanged;
  final String selectedCategory;
  final List<_ServiceCategory> categories;
  final ValueChanged<String> onCategorySelected;
  final VoidCallback onRefresh;
  final ValueChanged<Provider> onOpenBooking;
  final ValueChanged<Provider> onOpenChat;

  @override
  Widget build(BuildContext context) {
    final loc = LocalizationService.instance;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Signed in as $customerId',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => WantedScreen(
                          onPosted: onRefresh,
                          loc: LocalizationService.instance,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.campaign_outlined),
                  label: Text(loc.t('post_wanted')),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search_rounded),
              hintText: 'Search by skill, area, or provider id',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: 16),
          Text(
            'Browse by category',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.9,
            children: categories
                .map((category) {
                  final isSelected = selectedCategory == category.label;

                  return InkWell(
                    onTap: () => onCategorySelected(category.label),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          CircleAvatar(child: Icon(category.icon)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              category.label,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
                .toList(growable: false),
          ),
          const SizedBox(height: 16),
          FutureBuilder<List<Provider>>(
            future: providersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const AppLoadingState(message: 'Loading providers...');
              }

              if (snapshot.hasError) {
                return AppErrorState(
                  message: 'Failed to load providers.',
                  onRetry: onRefresh,
                );
              }

              final providers = snapshot.data ?? const <Provider>[];
              final estimator = _estimatePrice(providers);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.t('price_estimator'),
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(estimator),
                          const SizedBox(height: 8),
                          Text(
                            'Escrow-backed card or wallet payments are held securely until the job is completed.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Top service providers',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (providers.isEmpty)
                    AppEmptyState(
                      title: 'No providers found for current filters.',
                      subtitle: 'Try another category or search term.',
                      icon: Icons.search_off_rounded,
                      actionLabel: 'Reload',
                      onAction: onRefresh,
                    )
                  else
                    ListView.separated(
                      itemCount: providers.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final provider = providers[index];
                        final favoriteService = FavoriteWorkersService.instance;

                        return ProviderCard(
                          provider: provider,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => ProviderProfileScreen(
                                  provider: provider,
                                  customerId: customerId,
                                ),
                              ),
                            );
                          },
                          actions: [
                            OutlinedButton.icon(
                              onPressed: () {
                                favoriteService.toggle(provider);
                                onRefresh();
                              },
                              icon: Icon(
                                favoriteService.isFavorite(provider.id)
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                              ),
                              label: Text(
                                favoriteService.isFavorite(provider.id)
                                    ? 'Saved'
                                    : 'Favourite',
                              ),
                            ),
                            OutlinedButton.icon(
                              onPressed: () => onOpenChat(provider),
                              icon: const Icon(
                                Icons.chat_bubble_outline_rounded,
                              ),
                              label: Text(loc.t('chat')),
                            ),
                            FilledButton.icon(
                              onPressed: () => onOpenBooking(provider),
                              icon: const Icon(Icons.calendar_month_rounded),
                              label: Text(loc.t('book_request')),
                            ),
                          ],
                        );
                      },
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _estimatePrice(List<Provider> providers) {
    if (providers.isEmpty) {
      return 'Select a category to view a transparent price range estimate.';
    }

    final low = providers
        .map((provider) => provider.priceMin)
        .reduce((a, b) => a < b ? a : b);
    final high = providers
        .map((provider) => provider.priceMax)
        .reduce((a, b) => a > b ? a : b);
    return 'Estimated range for this filter: LKR ${low.toStringAsFixed(0)} - ${high.toStringAsFixed(0)}.';
  }
}

class _AccountTab extends StatelessWidget {
  const _AccountTab({required this.customerId, required this.authController});

  final String customerId;
  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    final favoritesService = FavoriteWorkersService.instance;

    return ValueListenableBuilder<List<Provider>>(
      valueListenable: favoritesService.favorites,
      builder: (context, favorites, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account summary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Phone: ${authController.state.phoneNumber ?? '-'}'),
                    Text('Customer ID: $customerId'),
                    const SizedBox(height: 8),
                    Text(
                      'Secure card and wallet payments are supported for confirmed bookings.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => CustomerProfileScreen(
                              authController: authController,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_outline),
                      label: const Text('Open profile'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Favourite workers',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            if (favorites.isEmpty)
              const AppEmptyState(
                title: 'No favourite workers yet.',
                subtitle: 'Tap Favourite on a provider to save them here.',
                icon: Icons.favorite_border_rounded,
              )
            else
              ...favorites.map(
                (provider) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: ListTile(
                      title: Text(provider.id),
                      subtitle: Text(provider.skills.join(', ')),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => SecureChatScreen(
                                    provider: provider,
                                    customerId: customerId,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Chat'),
                          ),
                          FilledButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => BookingRequestScreen(
                                    provider: provider,
                                    customerId: customerId,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Re-book'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Security and support',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'In-job SOS and secure chat are available from the activity and profile screens.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ServiceCategory {
  const _ServiceCategory(this.label, this.icon);

  final String label;
  final IconData icon;
}
