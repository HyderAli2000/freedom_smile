import 'package:flutter/material.dart';
import 'package:freedom_smile/select_orthodontist_screen.dart';

/// Kept for older navigation; forwards to API-backed clinic picker.
class ReEvaluationMapUser extends StatelessWidget {
  const ReEvaluationMapUser({super.key});

  @override
  Widget build(BuildContext context) {
    return const SelectOrthodontistScreen(appointmentSource: 'reevaluation');
  }
}
