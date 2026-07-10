import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../sources/local/portfolio_local_source.dart';

// ─── Theme Provider ───────────────────────────────────────────────────────────
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.dark);
  void toggle() => state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
}

// ─── Language Provider ────────────────────────────────────────────────────────
final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('en');
  void toggle() => state = state == 'en' ? 'my' : 'en';
}

// ─── Active Section Provider ──────────────────────────────────────────────────
final activeSectionProvider = StateProvider<String>((ref) => 'hero');

// ─── Mobile Nav Provider ──────────────────────────────────────────────────────
final mobileNavProvider = StateProvider<bool>((ref) => false);

// ─── Scroll Provider ──────────────────────────────────────────────────────────
final scrollProgressProvider = StateProvider<double>((ref) => 0.0);

// ─── Data Providers ──────────────────────────────────────────────────────────
final profileProvider = Provider<ProfileModel>((ref) {
  return PortfolioLocalSource.getProfile();
});

final projectsProvider = Provider<List<ProjectModel>>((ref) {
  return PortfolioLocalSource.getProjects();
});

final servicesProvider = Provider<List<ServiceModel>>((ref) {
  return PortfolioLocalSource.getServices();
});

final skillsProvider = Provider<List<SkillModel>>((ref) {
  return PortfolioLocalSource.getSkills();
});

final appsProvider = Provider<List<AppModel>>((ref) {
  return PortfolioLocalSource.getApps();
});

// ─── GitHub Accounts Provider ────────────────────────────────────────────────
final githubAccountsProvider = Provider<List<String>>((ref) {
  return PortfolioLocalSource.getGithubAccounts();
});

final lovableAppsProvider = Provider<List<String>>((ref) {
  return PortfolioLocalSource.getLovableApps();
});

// ─── Filter Providers ─────────────────────────────────────────────────────────
final projectFilterProvider = StateProvider<String>((ref) => 'All');
final skillCategoryProvider  = StateProvider<String>((ref) => 'All');

final filteredProjectsProvider = Provider<List<ProjectModel>>((ref) {
  final all    = ref.watch(projectsProvider);
  final filter = ref.watch(projectFilterProvider);
  if (filter == 'All') return all;
  return all.where((p) => p.category == filter).toList();
});

final filteredSkillsProvider = Provider<List<SkillModel>>((ref) {
  final all    = ref.watch(skillsProvider);
  final filter = ref.watch(skillCategoryProvider);
  if (filter == 'All') return all;
  return all.where((s) => s.category == filter).toList();
});
