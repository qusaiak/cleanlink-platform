import 'package:client_app/config/theme/styles.dart';
import 'package:client_app/core/widgets/custom_image_view.dart';
import 'package:client_app/features/home/data/models/offer_model.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/custom_elevated_button.dart';

class OfferCard extends StatelessWidget {
  final OfferModel offer;

  const OfferCard({super.key, required this.offer});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context)!.colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        children: [
          CustomImageView(
            imagePath: offer.image,
            fit: BoxFit.cover,
            width: double.infinity,
          ),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.05),
                  Colors.black.withOpacity(0.8),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offer.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    offer.subtitle,
                    style: const TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 10),

                  CustomElevatedButton(
                    width: 120.w,
                    text: AppLocalizations.of(context)!.book_now,
                    buttonTextStyle: Styles.textStyle12.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    buttonStyle: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(theme.primary),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
