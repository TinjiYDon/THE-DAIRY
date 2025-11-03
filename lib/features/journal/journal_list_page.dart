import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class JournalListPage extends StatelessWidget {
  const JournalListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('THE-DAIRY')),
      body: const Center(child: Text('Journal List (placeholder)')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('New'),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.book_outlined), label: 'Journal'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
        onDestinationSelected: (index) {
          if (index == 1) {
            context.go('/settings');
          } else {
            context.go('/');
          }
        },
        selectedIndex: 0,
      ),
    );
  }
}

