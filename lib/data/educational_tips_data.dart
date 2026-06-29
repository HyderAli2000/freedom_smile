import 'package:freedom_smile/utils/assets_images.dart';

class EducationalTip {
  const EducationalTip({
    required this.image,
    required this.title,
    required this.description,
    required this.category,
    this.fullContent,
  });

  final String image;
  final String title;
  final String description;
  final String category;
  final String? fullContent;

  String get body =>
      fullContent ??
      '$description\n\n'
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\n'
          'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\n'
          'Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.';
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
