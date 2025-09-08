import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class CollectionNotesWidget extends StatefulWidget {
  final String? notes;
  final Function(String?) onNotesChanged;

  const CollectionNotesWidget({
    super.key,
    this.notes,
    required this.onNotesChanged,
  });

  @override
  State<CollectionNotesWidget> createState() => _CollectionNotesWidgetState();
}

class _CollectionNotesWidgetState extends State<CollectionNotesWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  static const int _maxCharacters = 500;

  @override
  void initState() {
    super.initState();
    if (widget.notes != null) {
      _controller.text = widget.notes!;
    }
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final text = _controller.text;
    widget.onNotesChanged(text.isEmpty ? null : text);
  }

  @override
  Widget build(BuildContext context) {
    final characterCount = _controller.text.length;
    final isNearLimit = characterCount > (_maxCharacters * 0.8);

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'note_alt',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Collection Notes',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                ' (Optional)',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _focusNode.hasFocus
                    ? AppTheme.lightTheme.primaryColor
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                width: _focusNode.hasFocus ? 2 : 1,
              ),
            ),
            child: TextFormField(
              controller: _controller,
              focusNode: _focusNode,
              maxLines: 4,
              maxLength: _maxCharacters,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText:
                    'Add notes about collection conditions, quality, location details...',
                hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                contentPadding: EdgeInsets.all(16),
                counterText: '', // Hide default counter
              ),
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ),

          // Character counter and helper text
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Optional: Weather conditions, plant quality, harvesting method, etc.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                '$characterCount/$_maxCharacters',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: isNearLimit
                      ? AppTheme.getWarningColor(true)
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: isNearLimit ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),

          // Quick note suggestions
          if (_controller.text.isEmpty) ...[
            SizedBox(height: 12),
            Text(
              'Quick suggestions:',
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Good quality plants',
                'Morning collection',
                'Dry weather',
                'Wild harvested',
                'Organic source',
                'Fresh specimens',
              ].map((suggestion) {
                return GestureDetector(
                  onTap: () {
                    final currentText = _controller.text;
                    final newText = currentText.isEmpty
                        ? suggestion
                        : '$currentText, $suggestion';

                    if (newText.length <= _maxCharacters) {
                      _controller.text = newText;
                      _controller.selection = TextSelection.fromPosition(
                        TextPosition(offset: newText.length),
                      );
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'add',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          suggestion,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}
