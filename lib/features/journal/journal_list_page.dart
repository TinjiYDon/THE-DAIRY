import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../data/providers/entry_provider.dart';
import 'journal_edit_page.dart';

class JournalListPage extends ConsumerWidget {
  const JournalListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(entriesProvider);
    
    return Scaffold(
      appBar: AppBar(title: const Text('THE-DAIRY')),
      body: entriesAsync.when(
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('还没有记录', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final date = DateTime.fromMillisecondsSinceEpoch(entry.date);
              final dateStr = DateFormat('yyyy-MM-dd').format(date);
              
              return ListTile(
                title: Text(entry.text ?? '无内容'),
                subtitle: Text(dateStr),
                trailing: entry.moodScore != null
                    ? Icon(Icons.mood, color: _getMoodColor(entry.moodScore!))
                    : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JournalEditPage(entry: entry),
                    ),
                  ).then((_) {
                    ref.read(entryNotifierProvider.notifier).refresh();
                  });
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('加载失败: $error'),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const JournalEditPage(),
            ),
          ).then((_) {
            ref.read(entryNotifierProvider.notifier).refresh();
          });
        },
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
  
  Color _getMoodColor(int score) {
    switch (score) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

