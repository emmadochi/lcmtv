import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AdminSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final String hintText;
  final String? initialValue;
  final bool showFilters;
  final List<String>? filterOptions;
  final String? selectedFilter;
  final Function(String)? onFilterChanged;

  const AdminSearchBar({
    super.key,
    required this.onSearchChanged,
    required this.hintText,
    this.initialValue,
    this.showFilters = false,
    this.filterOptions,
    this.selectedFilter,
    this.onFilterChanged,
  });

  @override
  State<AdminSearchBar> createState() => _AdminSearchBarState();
}

class _AdminSearchBarState extends State<AdminSearchBar> {
  late TextEditingController _controller;
  String _selectedFilter = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
    _selectedFilter = widget.selectedFilter ?? '';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(
          color: AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Search Icon
          const Padding(
            padding: EdgeInsets.only(left: AppTheme.spacingM),
            child: Icon(
              Icons.search,
              color: AppTheme.textLight,
              size: 20,
            ),
          ),
          
          // Search Field
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textLight,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingM,
                  vertical: AppTheme.spacingM,
                ),
              ),
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textDark,
              ),
              onChanged: (value) {
                widget.onSearchChanged(value);
              },
            ),
          ),
          
          // Filter Dropdown (if enabled)
          if (widget.showFilters && widget.filterOptions != null) ...[
            Container(
              height: 40,
              margin: const EdgeInsets.only(right: AppTheme.spacingS),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: AppTheme.borderLight,
                    width: 1,
                  ),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedFilter.isNotEmpty ? _selectedFilter : null,
                  hint: Text(
                    'Filter',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textLight,
                    ),
                  ),
                  items: widget.filterOptions!.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(
                        option,
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textDark,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedFilter = value ?? '';
                    });
                    if (widget.onFilterChanged != null) {
                      widget.onFilterChanged!(value ?? '');
                    }
                  },
                ),
              ),
            ),
          ],
          
          // Clear Button
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.clear,
                color: AppTheme.textLight,
                size: 20,
              ),
              onPressed: () {
                _controller.clear();
                widget.onSearchChanged('');
              },
            ),
        ],
      ),
    );
  }
}
