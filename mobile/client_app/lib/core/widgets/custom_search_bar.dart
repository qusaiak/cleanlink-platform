import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/styles.dart';
import '../../l10n/app_localizations.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.searchController,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.leading,
    this.focusNode,
  });

  final TextEditingController searchController;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Widget? leading;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: TextFormField(
            controller: searchController,
            focusNode: focusNode,
            onChanged: onChanged,
            onFieldSubmitted:
                onSubmitted ?? (_) => FocusScope.of(context).unfocus(),
            textInputAction: TextInputAction.search,
            style: Styles.textStyle14.copyWith(
              color: theme.onSurface,
              fontWeight: FontWeight.w500,
              overflow: TextOverflow.visible,
            ),
            cursorColor: theme.primary,
            decoration: InputDecoration(
              counterText: '',
              hintText: hintText ?? l10n.search,
              hintStyle: Styles.textStyle14.copyWith(
                color: theme.onSurfaceVariant,
              ),
              prefixIcon:
                  leading ??
                  Icon(
                    Icons.search_outlined,
                    color: theme.onSurfaceVariant,
                    size: 20.sp,
                  ),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: theme.onSurfaceVariant,
                        size: 20.sp,
                      ),
                      onPressed: () {
                        searchController.clear();
                        onChanged?.call('');
                      },
                    )
                  : null,
              isDense: true,
              filled: true,
              fillColor: theme.surfaceContainerLow,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 12.h,
              ),
              border: _border(theme.onSurfaceVariant),
              enabledBorder: _border(theme.onSurfaceVariant),
              focusedBorder: _border(theme.onSurfaceVariant),
              errorBorder: _border(theme.error),
              focusedErrorBorder: _border(theme.error),
              errorStyle: Styles.textStyle11.copyWith(
                color: theme.error,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1.5}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30.r),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
