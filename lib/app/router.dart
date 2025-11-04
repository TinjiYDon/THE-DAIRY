import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/journal/journal_list_page.dart';
import '../features/settings/settings_page.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        name: 'journal',
        builder: (BuildContext context, GoRouterState state) => const JournalListPage(),
        routes: <RouteBase>[
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (BuildContext context, GoRouterState state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
}

