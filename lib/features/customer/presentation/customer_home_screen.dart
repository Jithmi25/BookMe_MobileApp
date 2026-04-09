import 'package:book_me_mobile_app/app/router/app_router.dart';
import 'package:book_me_mobile_app/features/auth/application/auth_controller.dart';
import 'package:book_me_mobile_app/features/customer/data/local_mock_provider_repository.dart';
import 'package:book_me_mobile_app/features/customer/presentation/provider_profile_screen.dart';
import 'package:book_me_mobile_app/features/customer/presentation/widgets/provider_card.dart';
import 'package:book_me_mobile_app/features/shared/domain/entities/provider.dart';
import 'package:flutter/material.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({required this.authController, super.key});

  final AuthController authController;

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final LocalMockProviderRepository _repository =
      const LocalMockProviderRepository();

  String _selectedCategory = LocalMockProviderRepository.categories.first;
  String _searchQuery = '';

  List<Provider> get _providers {
    return _repository.getProviders(
      selectedCategory: _selectedCategory,
      searchQuery: _searchQuery,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.authController.state;

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
            Text('Signed in as ${state.phoneNumber ?? '-'}'),
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
              },
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: LocalMockProviderRepository.categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category =
                      LocalMockProviderRepository.categories[index];
                  final isSelected = category == _selectedCategory;

                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _providers.isEmpty
                  ? const Center(
                      child: Text('No providers found for current filters.'),
                    )
                  : ListView.separated(
                      itemCount: _providers.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final provider = _providers[index];

                        return ProviderCard(
                          provider: provider,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    ProviderProfileScreen(provider: provider),
                              ),
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
