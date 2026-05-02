import 'dart:async';
import 'package:client_app/features/home/data/models/offer_model.dart';
import 'package:client_app/features/home/presentation/widgets/offer_card.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/gen/assets.gen.dart';

class OffersSection extends StatefulWidget {
  const OffersSection({super.key});

  @override
  State<OffersSection> createState() => _OffersSectionState();
}

class _OffersSectionState extends State<OffersSection> {
  final PageController _controller = PageController(viewportFraction: 0.85);
  int _current = 0;
  Timer? _timer;

  final List<OfferModel> offers = [
    OfferModel(
      title: "20% Off Deep Cleaning",
      subtitle: "First booking discount",
      image: Assets.images.test.test.path,
    ),
    OfferModel(
      title: "Home Cleaning Experts",
      subtitle: "Trusted professionals",
      image: Assets.images.test.test.path,
    ),
    OfferModel(
      title: "Fast Booking",
      subtitle: "Book in seconds",
      image: Assets.images.test.test.path,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;

      _current = (_current + 1) % offers.length;

      _controller.animateToPage(
        _current,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PageView.builder(
        controller: _controller,
        itemCount: offers.length,
        onPageChanged: (i) => setState(() => _current = i),
        itemBuilder: (_, i) {
          final offer = offers[i];

          return AnimatedScale(
            duration: const Duration(milliseconds: 300),
            scale: _current == i ? 1 : 0.92,
            child: OfferCard(offer: offer),
          );
        },
      ),
    );
  }
}
