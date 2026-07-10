// ─── profile_model.dart ───────────────────────────────────────────────────────
class ProfileModel {
  final String name;
  final String nameMyanmar;
  final String title;
  final String location;
  final String bio;
  final String avatarUrl;
  final String phone1;
  final String phone2;
  final List<String> emails;
  final Map<String, String> socialLinks;

  const ProfileModel({
    required this.name,
    required this.nameMyanmar,
    required this.title,
    required this.location,
    required this.bio,
    required this.avatarUrl,
    required this.phone1,
    required this.phone2,
    required this.emails,
    required this.socialLinks,
  });
}

// ─── project_model.dart ──────────────────────────────────────────────────────
class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String githubUrl;
  final String? liveUrl;
  final String? imageUrl;
  final List<String> tags;
  final bool isFeatured;
  final String category;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.githubUrl,
    this.liveUrl,
    this.imageUrl,
    required this.tags,
    this.isFeatured = false,
    required this.category,
  });
}

// ─── service_model.dart ───────────────────────────────────────────────────────
class ServiceModel {
  final String icon;
  final String title;
  final String description;
  final List<String> features;
  final String badge;

  const ServiceModel({
    required this.icon,
    required this.title,
    required this.description,
    required this.features,
    required this.badge,
  });
}

// ─── social_link_model.dart ───────────────────────────────────────────────────
class SocialLinkModel {
  final String platform;
  final String url;
  final String icon;
  final String handle;

  const SocialLinkModel({
    required this.platform,
    required this.url,
    required this.icon,
    required this.handle,
  });
}

// ─── app_model.dart ───────────────────────────────────────────────────────────
class AppModel {
  final String emoji;
  final String title;
  final String? url;
  final String? githubUrl;
  final String description;
  final String type; // 'lovable' | 'github' | 'native'

  const AppModel({
    required this.emoji,
    required this.title,
    this.url,
    this.githubUrl,
    required this.description,
    required this.type,
  });
}

// ─── skill_model.dart ─────────────────────────────────────────────────────────
class SkillModel {
  final String name;
  final double level; // 0.0 - 1.0
  final String category;
  final String emoji;

  const SkillModel({
    required this.name,
    required this.level,
    required this.category,
    required this.emoji,
  });
}
