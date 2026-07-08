import 'package:get/get.dart';

class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

class FaqsData {
  FaqsData._();

  static String get _faqQuestion1 => 'faq_question_1'.tr;
  static String get _faqAnswer1 => 'faq_answer_1'.tr;
  static String get _faqQuestion2 => 'faq_question_2'.tr;
  static String get _faqAnswer2 => 'faq_answer_2'.tr;
  static String get _faqQuestion3 => 'faq_question_3'.tr;
  static String get _faqAnswer3 => 'faq_answer_3'.tr;
  static String get _faqQuestion4 => 'faq_question_4'.tr;
  static String get _faqAnswer4 => 'faq_answer_4'.tr;
  static String get _faqQuestion5 => 'faq_question_5'.tr;
  static String get _faqAnswer5 => 'faq_answer_5'.tr;

  static List<FaqItem> get items => [
    FaqItem(question: _faqQuestion1, answer: _faqAnswer1),
    FaqItem(question: _faqQuestion2, answer: _faqAnswer2),
    FaqItem(question: _faqQuestion3, answer: _faqAnswer3),
    FaqItem(question: _faqQuestion4, answer: _faqAnswer4),
    FaqItem(question: _faqQuestion5, answer: _faqAnswer5),
  ];
}
