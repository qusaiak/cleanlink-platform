import 'package:flutter/material.dart';

import '../widgets/onboarding_body.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: OnboardingBody(),
    );
  }
}
