class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

class FaqsData {
  FaqsData._();

  static const items = <FaqItem>[
    FaqItem(
      question: 'Lorem ipsum dolor sit amet consectetur ?',
      answer:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    ),
    FaqItem(
      question: 'How do I care for my retainers daily?',
      answer:
          'Rinse your retainers with lukewarm water after each use, brush gently with a soft toothbrush, and store them in their case when not wearing them. Avoid hot water, which can warp the material.',
    ),
    FaqItem(
      question: 'What should I do if my retainer feels tight?',
      answer:
          'Mild tightness can be normal if you have not worn your retainer for a short period. Wear it as directed and contact your orthodontist if discomfort persists or worsens.',
    ),
    FaqItem(
      question: 'Can I eat while wearing my retainers?',
      answer:
          'No. Remove your retainers before eating or drinking anything other than plain water to prevent damage, staining, and bacterial buildup.',
    ),
    FaqItem(
      question: 'How often should I replace my retainer?',
      answer:
          'Replacement timing depends on wear and fit. Check the Retainers tab for usage insights and order a replacement when your retainer shows signs of wear or no longer fits comfortably.',
    ),
  ];
}
