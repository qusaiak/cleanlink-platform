import 'package:client_app/config/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/row_title.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../companies/presentation/widgets/reviews_section.dart';
import '../../../bookings/presentation/pages/booking_details_page.dart';

class ServiceDetailsPage extends StatefulWidget {
  const ServiceDetailsPage({super.key});

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  int selectedPackageIndex = 0;

  final List<ServicePackage> packages = [
    ServicePackage(
      name: "Studio",
      price: 75,
      duration: "2 hours",
      features: [
        "Dusting all surfaces",
        "Vacuuming floors",
        "Mopping",
        "Bathroom cleaning",
        "Kitchen wipe-down",
      ],
    ),
    ServicePackage(
      name: "2 Bedroom",
      price: 95,
      duration: "2.5 hours",
      features: [
        "Everything in Studio",
        "All bedrooms included",
        "Closet organization",
        "Window sill cleaning",
      ],
    ),
    ServicePackage(
      name: "3 Bedroom",
      price: 115,
      duration: "3 hours",
      features: [
        "Everything in 2BR",
        "Deep bathroom scrub",
        "Appliance exterior",
        "Baseboard dusting",
      ],
    ),
    ServicePackage(
      name: "Villa",
      price: 150,
      duration: "4+ hours",
      features: [
        "Full house cleaning",
        "Outdoor patio sweep",
        "Garage floor clean",
        "Premium eco‑products",
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedPackage = packages[selectedPackageIndex];
    var theme = Theme.of(context)!.colorScheme;
    return Scaffold(
      bottomNavigationBar: ServiceBookingBar(
        packageName: selectedPackage.name,
        price: selectedPackage.price,
        onBook: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BookingDetailsPage(
                packageName: selectedPackage.name,
                price: selectedPackage.price,
              ),
            ),
          );
        },
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 300.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.images.test.test.path),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 40.h,
                      left: 16.w,
                      child: BackButton(color: theme.onSurface),
                    ),
                  ],
                ),

                Transform.translate(
                  offset: Offset(0, -70.h),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: ServiceSummaryCard(),
                  ),
                ),

                // SizedBox(height: 40.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== FLOATING SUMMARY CARD ====================
class ServiceSummaryCard extends StatelessWidget {
  ServiceSummaryCard({super.key});
  final List<ServicePackage> packages = [
    ServicePackage(
      name: "Studio",
      price: 75,
      duration: "2 hours",
      features: [
        "Dusting all surfaces",
        "Vacuuming floors",
        "Mopping",
        "Bathroom cleaning",
        "Kitchen wipe-down",
      ],
    ),
    ServicePackage(
      name: "2 Bedroom",
      price: 95,
      duration: "2.5 hours",
      features: [
        "Everything in Studio",
        "All bedrooms included",
        "Closet organization",
        "Window sill cleaning",
      ],
    ),
    ServicePackage(
      name: "3 Bedroom",
      price: 115,
      duration: "3 hours",
      features: [
        "Everything in 2BR",
        "Deep bathroom scrub",
        "Appliance exterior",
        "Baseboard dusting",
      ],
    ),
    ServicePackage(
      name: "Villa",
      price: 150,
      duration: "4+ hours",
      features: [
        "Full house cleaning",
        "Outdoor patio sweep",
        "Garage floor clean",
        "Premium eco‑products",
      ],
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Residential Cleaning",
                  style: Styles.textStyle18.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  "Top rated",
                  style: Styles.textStyle11.copyWith(color: theme.primary),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(Icons.business, size: 14.sp, color: theme.primary),
              SizedBox(width: 4.w),
              Text(
                "SparkleClean",
                style: Styles.textStyle12.copyWith(color: theme.primary),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                size: 14,
                color: theme.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Text(
                "New York City",
                style: Styles.textStyle11.copyWith(
                  color: theme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  icon: Icons.star_rounded,
                  value: "4.8",
                  label: "Rating",
                ),
              ),
              Expanded(
                child: _InfoTile(
                  icon: Icons.reviews_rounded,
                  value: "1.2k",
                  label: "Reviews",
                ),
              ),
              Expanded(
                child: _InfoTile(
                  icon: Icons.schedule_rounded,
                  value: "2-4h",
                  label: "Duration",
                ),
              ),
              Expanded(
                child: _InfoTile(
                  icon: Icons.location_on_outlined,
                  value: "5 km",
                  label: "Away",
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ServiceOverviewSection(),
          SizedBox(height: 16.h),
          ServicePackagesSection(packages: packages),
          SizedBox(height: 16.h),
          BeforeAfterGallery(),
          SizedBox(height: 16.h),
          ReviewsSection(),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  const _InfoTile({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Icon(icon, size: 20.sp, color: theme.primary),
        SizedBox(height: 6.h),
        Text(
          value,
          style: Styles.textStyle14.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Styles.textStyle11.copyWith(
            color: theme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

// ==================== SERVICE OVERVIEW ====================
class ServiceOverviewSection extends StatelessWidget {
  const ServiceOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RowTitle(iconData: Icons.description_outlined, title: "Overview"),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            "Professional residential cleaning service including dusting, vacuuming, floor mopping, bathroom sanitization and kitchen cleaning. Our team uses eco‑friendly products and follows a strict 30‑point checklist to ensure your home sparkles.",
            maxLines: 50,
            style: Styles.textStyle12,
          ),
        ),
      ],
    );
  }
}

// ==================== PACKAGE MODEL & SELECTION ====================
class ServicePackage {
  final String name;
  final int price;
  final String duration;
  final List<String> features;
  const ServicePackage({
    required this.name,
    required this.price,
    required this.duration,
    required this.features,
  });
}

class ServicePackagesSection extends StatefulWidget {
  final List<ServicePackage> packages;
  const ServicePackagesSection({super.key, required this.packages});

  @override
  State<ServicePackagesSection> createState() => _ServicePackagesSectionState();
}

class _ServicePackagesSectionState extends State<ServicePackagesSection> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final selectedPackage = widget.packages[_selectedIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RowTitle(iconData: Icons.home_work_outlined, title: "Choose a package"),
        SizedBox(height: 16.h),
        // Package chips / selector
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Wrap(
            spacing: 5.w,
            runSpacing: 10.h,
            children: List.generate(widget.packages.length, (index) {
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? theme.primary : theme.surface,
                    borderRadius: BorderRadius.circular(15.r),
                    border: Border.all(
                      color: isSelected
                          ? theme.primary
                          : theme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    widget.packages[index].name,
                    style: Styles.textStyle12.copyWith(
                      color: isSelected ? Colors.white : theme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        SizedBox(height: 24.h),
        // Package details card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(color: theme.outline.withOpacity(0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedPackage.name,
                    style: Styles.textStyle16.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: theme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      "\$${selectedPackage.price}",
                      style: Styles.textStyle14.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14.sp,
                    color: theme.onSurface.withOpacity(0.7),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    selectedPackage.duration,
                    style: Styles.textStyle12.copyWith(
                      color: theme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Divider(height: 1, color: theme.outline.withOpacity(0.2)),
              SizedBox(height: 16.h),
              Text(
                "What's included:",
                style: Styles.textStyle12.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12.h),
              ...selectedPackage.features.map(
                (feature) => Padding(
                  padding: EdgeInsets.only(bottom: 8.h),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 16.sp,
                        color: theme.primary,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(child: Text(feature, style: Styles.textStyle12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== BEFORE / AFTER GALLERY ====================
class BeforeAfterGallery extends StatelessWidget {
  const BeforeAfterGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RowTitle(
          iconData: Icons.compare_arrows,
          title: "Before & After",
          onTap: () {},
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 160.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Stack(
                  children: [
                    Image.asset(
                      Assets.images.test.test.path,
                      width: 140.w,
                      height: 160.h,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        color: Colors.black.withOpacity(0.6),
                        child: Text(
                          index == 0
                              ? "Living Room"
                              : index == 1
                              ? "Kitchen"
                              : "Bathroom",
                          textAlign: TextAlign.center,
                          style: Styles.textStyle11.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ==================== COVERAGE AREA ====================
class CoverageAreaSection extends StatelessWidget {
  const CoverageAreaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RowTitle(iconData: Icons.map_outlined, title: "Coverage Area"),
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.r),
            child: Image.asset(
              Assets.images.test.test.path,
              height: 160.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== BOTTOM BOOKING BAR ====================
class ServiceBookingBar extends StatelessWidget {
  final String packageName;
  final int price;
  final VoidCallback onBook;

  const ServiceBookingBar({
    super.key,
    required this.packageName,
    required this.price,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: theme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\$$price",
                  style: Styles.textStyle22.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primary,
                  ),
                ),
                Text(
                  "$packageName package",
                  style: Styles.textStyle11.copyWith(
                    color: theme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: CustomElevatedButton(
                text: AppLocalizations.of(context)!.book_now,
                buttonTextStyle: Styles.textStyle12.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(theme.primary),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                  elevation: WidgetStateProperty.all(0),
                ),
                onPressed: onBook,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
