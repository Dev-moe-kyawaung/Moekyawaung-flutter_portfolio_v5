import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/shell/presentation/pages/portfolio_shell_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PortfolioShellPage(),
    ),
    GoRoute(
      path: '/#:section',
      builder: (context, state) {
        final section = state.pathParameters['section'] ?? 'hero';
        return PortfolioShellPage(initialSection: section);
      },
    ),
  ],
  errorBuilder: (context, state) => const PortfolioShellPage(),
);
