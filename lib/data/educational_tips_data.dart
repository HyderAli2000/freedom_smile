import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/utils/assets_images.dart';

class EducationalTip {
  const EducationalTip({
    required this.image,
    required this.title,
    required this.description,
    required this.category,
    this.fullContent,
    this.id,
    this.imageUrl,
  });

  final String? id;
  final String? imageUrl;
  final String image;
  final String title;
  final String description;
  final String category;
  final String? fullContent;

  bool get hasNetworkImage => ApiMap.isNetworkImage(imageUrl);

  String get body =>
      fullContent ??
      '$description\n\n'
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\n'
          'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\n'
          'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.';

  factory EducationalTip.fromJson(Map<String, dynamic> json) {
    final rawImage = ApiMap.str(json['imageUrl'] ?? json['image']);
    final resolved = ApiMap.resolveMediaUrl(rawImage);
    final isNetwork = resolved != null;
    String category = '';
    final cat = json['category'];
    if (cat is Map) {
      category = ApiMap.str(cat['name'] ?? cat['slug']);
    } else {
      category = ApiMap.str(
        json['categoryName'] ?? json['category'] ?? json['categorySlug'],
      );
    }

    final content =
        ApiMap.str(json['content'] ?? json['body'] ?? json['fullContent']);

    return EducationalTip(
      id: ApiMap.id(json).isEmpty ? null : ApiMap.id(json),
      imageUrl: resolved,
      image: isNetwork
          ? AssetImages.pc1
          : (rawImage.isEmpty ? AssetImages.pc1 : rawImage),
      title: ApiMap.str(json['title'], 'Tip'),
      description: ApiMap.str(
        json['description'] ?? json['summary'] ?? json['excerpt'],
      ),
      category: category.isEmpty ? 'All' : category,
      fullContent: content.isEmpty ? null : content,
    );
  }
}

class TipCategoryItem {
  const TipCategoryItem({
    required this.name,
    required this.slug,
    this.id,
  });

  final String name;
  final String slug;
  final String? id;

  factory TipCategoryItem.fromJson(Map<String, dynamic> json) {
    return TipCategoryItem(
      id: ApiMap.id(json).isEmpty ? null : ApiMap.id(json),
      name: ApiMap.str(json['name'], 'Category'),
      slug: ApiMap.str(json['slug'] ?? json['name']),
    );
  }
}

class EducationalTipsData {
  EducationalTipsData._();

  static const categories = [
    'All',
    'Gum health',
    'Teeth cleaning',
    'Retainer hygiene',
    'long-term oral health',
  ];

  static const tips = [
    EducationalTip(
      image: AssetImages.pc1,
      title: 'Lorem ipsum dolor sit amet, consectetur.',
      description:
          'Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing Elit, Sed Do Eiusmod Tempor Incididunt Ut Labore Et Dolore Magna Aliqua.',
      category: 'Gum health',
    ),
    EducationalTip(
      image: AssetImages.pc2,
      title: 'Lorem ipsum dolor sit amet, consectetur.',
      description:
          'Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing Elit, Sed Do Eiusmod Tempor Incididunt Ut Labore Et Dolore Magna Aliqua.',
      category: 'Retainers',
    ),
    EducationalTip(
      image: AssetImages.p1,
      title: 'Lorem ipsum dolor sit amet, consectetur.',
      description:
          'Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing Elit, Sed Do Eiusmod Tempor Incididunt Ut Labore Et Dolore Magna Aliqua.',
      category: 'Teeth cleaning',
    ),
  ];
}
