import 'package:book_me_mobile_app/app/router/app_router.dart';
import 'package:book_me_mobile_app/features/auth/application/auth_controller.dart';
import 'package:book_me_mobile_app/features/customer/data/firestore_booking_repository.dart';
import 'package:book_me_mobile_app/features/customer/data/firestore_provider_repository.dart';
import 'package:book_me_mobile_app/features/customer/domain/repositories/provider_repository.dart';
import 'package:book_me_mobile_app/features/customer/presentation/customer_booking_history_screen.dart';
import 'package:book_me_mobile_app/features/customer/presentation/provider_profile_screen.dart';
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
  final ProviderRepository _repository = FirestoreProviderRepository();

  static const List<String> _categories = [
    'All',
    'Plumber',
    'Carpenter',
    'Electrician',
    'Cleaner',
  ];

  String _selectedCategory = _categories.first;
  String _searchQuery = '';
  late Future<List<Provider>> _providersFuture;

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Providers'),
        actions: [
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
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Signed in as ${state.phoneNumber ?? '-'}'),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => CustomerBookingHistoryScreen(
                          customerId: customerId,
                          repository: FirestoreBookingRepository(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.history_rounded),
                  label: const Text('My bookings'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search by skill, area, or provider id',
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _refreshProviders();
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = category == _selectedCategory;

                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category;
                      });
                      _refreshProviders();
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Provider>>(
                future: _providersFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const AppLoadingState(
                      message: 'Loading providers...',
                    );
                  }

                  if (snapshot.hasError) {
                    return AppErrorState(
                      message: 'Failed to load providers.',
                      onRetry: _refreshProviders,
                    );
                  }

                  final providers = snapshot.data ?? const <Provider>[];
                  if (providers.isEmpty) {
                    return AppEmptyState(
                      title: 'No providers found for current filters.',
                      subtitle: 'Try another category or search term.',
                      icon: Icons.search_off_rounded,
                      actionLabel: 'Reload',
                      onAction: _refreshProviders,
                    );
                  }

                  return ListView.separated(
                    itemCount: providers.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final provider = providers[index];

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
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
