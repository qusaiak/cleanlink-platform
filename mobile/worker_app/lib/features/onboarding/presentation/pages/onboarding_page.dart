import 'package:flutter/material.dart';

import '../widgets/onboarding_body.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Follows the theme so onboarding isn't a white flash in dark mode.
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: null,
      body: const OnboardingBody(),
    );
  }
}
