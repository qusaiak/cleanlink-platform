import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_decoration.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/search_query.dart';

/// A single search field that lets the worker switch between a **general**
/// search (free-text across everything) and a **custom** search (by service
/// name / client name / location / time) — all in the same field.
///
/// Emits a [SearchQuery] through [onSearch] when the user submits (keyboard
/// "search" action or the trailing button). Reused in the top bar (where
/// [onSearch] navigates to the results screen) and on the results screen
/// itself (where it dispatches to the bloc).
class ServiceSearchField extends StatefulWidget {
  final SearchQuery initialQuery;
  final ValueChanged<SearchQuery> onSearch;

  /// When true the field grabs focus on mount (used on the results screen).
  final bool autofocus;

  const ServiceSearchField({
    super.key,
    this.initialQuery = const SearchQuery(),
    required this.onSearch,
    this.autofocus = false,
  });

  @override
  State<ServiceSearchField> createState() => _ServiceSearchFieldState();
}

class _ServiceSearchFieldState extends State<ServiceSearchField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialQuery.term);
  late SearchMode _mode = widget.initialQuery.mode;
  late SearchField _field = widget.initialQuery.field;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    widget.onSearch(
      SearchQuery(mode: _mode, field: _field, term: _controller.text.trim()),
    );
  }

  String _fieldLabel(AppLocalizations l, SearchField field) {
    switch (field) {
      case SearchField.serviceName:
        return l.search_by_service_name;
      case SearchField.clientName:
        return l.search_by_client_name;
      case SearchField.location:
        return l.search_by_location;
      case SearchField.time:
        return l.search_by_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    final isCustom = _mode == SearchMode.custom;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // General / Custom toggle (the "choose between general and custom"
        // control, kept attached to the field).
        Container(
          padding: EdgeInsets.all(3.r),
          decoration: BoxDecoration(
            color: theme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Row(
            children: [
              _modeChip(theme, l.search_mode_general, SearchMode.general),
              _modeChip(theme, l.search_mode_custom, SearchMode.custom),
            ],
          ),
        ),
        SizedBox(height: 10.h),

        // The input itself.
        TextField(
          controller: _controller,
          autofocus: widget.autofocus,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _submit(),
          style: Styles.textStyle14,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: theme.surface,
            hintText: isCustom
                ? l.search_custom_hint(_fieldLabel(l, _field))
                : l.search_general_hint,
            hintStyle:
                Styles.textStyle12.copyWith(color: theme.onSurfaceVariant),
            prefixIcon: Icon(Icons.search_rounded, color: theme.primary),
            suffixIcon: IconButton(
              icon: Icon(Icons.arrow_forward_rounded, color: theme.primary),
              onPressed: _submit,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: AppRadius.input,
              borderSide: BorderSide(
                color: theme.primary.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadius.input,
              borderSide: BorderSide(
                color: theme.primary.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppRadius.input,
              borderSide: BorderSide(color: theme.primary, width: 1.5),
            ),
          ),
        ),

        // Field selector (only meaningful for custom search).
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.topCenter,
          child: isCustom
              ? Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: SearchField.values.map((field) {
                      final selected = field == _field;
                      return ChoiceChip(
                        label: Text(_fieldLabel(l, field)),
                        selected: selected,
                        showCheckmark: false,
                        labelStyle: Styles.textStyle12.copyWith(
                          color: selected ? Colors.white : theme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: theme.primary.withValues(alpha: 0.08),
                        selectedColor: theme.primary,
                        side: BorderSide(
                          color: theme.primary.withValues(alpha: 0.2),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.chip,
                        ),
                        onSelected: (_) => setState(() => _field = field),
                      );
                    }).toList(),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _modeChip(ColorScheme theme, String label, SearchMode mode) {
    final selected = _mode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _mode = mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: selected ? theme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Styles.textStyle12.copyWith(
              color: selected ? Colors.white : theme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
