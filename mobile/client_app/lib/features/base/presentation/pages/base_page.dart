import 'package:client_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/constants/constants.dart';
import '../../../../config/theme/colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../chat/presentation/widgets/chat_floating_button.dart';
import '../bloc/base_bloc.dart';

class BasePage extends StatefulWidget {
  const BasePage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> with WidgetsBindingObserver {
  final GlobalKey _navBarKey = GlobalKey();
  double? measuredNavBarHeight;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(_measureNavBarHeight);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _measureNavBarHeight(Duration _) {
    debugPrint('Measuring nav bar height...');
    if (_navBarKey.currentContext != null) {
      final RenderBox renderBox =
          _navBarKey.currentContext!.findRenderObject() as RenderBox;
      debugPrint('Measured height: ${renderBox.size.height}');
      setState(() {
        measuredNavBarHeight = renderBox.size.height;
        Constants.bottomNavigationBarHeight = measuredNavBarHeight!;
      });
    }
  }

  void _goToBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
      //initialLocation: true,
    );
  }

  String get _badgeStyle => 'text';

  Widget _buildBadgeIndicator() {
    switch (_badgeStyle) {
      case 'text':
        return _buildTextBadge();
      case 'dot':
      default:
        return _buildDotBadge();
    }
  }

  // Style 1: Simple red dot
  Widget _buildDotBadge() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
    );
  }

  // Style 2: Text badge (NEW/OFFER)
  Widget _buildTextBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        AppLocalizations.of(context)!.new_badge,
        style: TextStyle(
          color: Colors.white,
          fontSize: 5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      'Building with height: ${measuredNavBarHeight ?? Constants.bottomNavigationBarHeight}',
    );
    var theme = Theme.of(context).colorScheme;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // if (state.authStatus == AuthStatus.successLogout) {
        //   GoRouter.of(context).go(AppRouter.kLoginPage);
        // }
      },
      child: BlocConsumer<BaseBloc, BaseState>(
        listener: (context, state) {
          if (state.baseStatus == BaseStatus.changeBottomNavBarIndex) {
            _goToBranch(state.currentIndex!);
          }
        },
        builder: (context, state) {
          final currentIndex = widget.navigationShell.currentIndex;
          return Scaffold(
            extendBody: true,
            backgroundColor: AppColor.transparent,
            resizeToAvoidBottomInset: false,
            body: PopScope(
              canPop: currentIndex == 0,
              onPopInvokedWithResult: (val, object) {
                BlocProvider.of<BaseBloc>(
                  context,
                ).add(const ChangeBottomNavBarIndex(0));
              },
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: widget.navigationShell,
              ),
            ),
            floatingActionButton: const ChatFloatingButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: Container(
                key: _navBarKey,
                //height: Constants.bottomNavigationBarHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      theme.surface,
                      theme.surface.withValues(alpha: 0.98),
                      theme.surface.withValues(alpha: 0.95),
                      theme.surface.withValues(alpha: 0.9),
                    ],
                  ),
                ),
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  type: BottomNavigationBarType.fixed,
                  elevation: 0.0,
                  currentIndex: currentIndex,
                  onTap: (newIndex) {
                    if (newIndex == 3) {
                      context.read<ProfileBloc>().add(
                        GetDashboardSummaryEvent(),
                      );
                    }
                    if (currentIndex == newIndex) {
                      widget.navigationShell.goBranch(
                        newIndex,
                        initialLocation: true,
                      );
                    } else {
                      context.read<BaseBloc>().add(
                        ChangeBottomNavBarIndex(newIndex),
                      );
                      widget.navigationShell.goBranch(newIndex);
                    }
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.home),
                      label: AppLocalizations.of(context)!.home,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.search),
                      label: AppLocalizations.of(context)!.search,
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.calendar_month),
                      label: AppLocalizations.of(context)!.bookings,
                    ),
                    BottomNavigationBarItem(
                      icon: state.isOfferBadgeShown!
                          ? Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(Icons.person),
                                Positioned(
                                  left: 20.0,
                                  bottom: 5,
                                  child: _buildBadgeIndicator(),
                                ),
                              ],
                            )
                          : const Icon(Icons.person),
                      label: AppLocalizations.of(context)!.profile,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
