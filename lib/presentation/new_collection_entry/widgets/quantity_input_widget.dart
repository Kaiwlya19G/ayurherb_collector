import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class QuantityInputWidget extends StatefulWidget {
  final double? quantity;
  final Function(double?) onQuantityChanged;
  final String? errorText;

  const QuantityInputWidget({
    super.key,
    this.quantity,
    required this.onQuantityChanged,
    this.errorText,
  });

  @override
  State<QuantityInputWidget> createState() => _QuantityInputWidgetState();
}

class _QuantityInputWidgetState extends State<QuantityInputWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.quantity != null) {
      _controller.text = widget.quantity!.toStringAsFixed(2);
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
    if (text.isEmpty) {
      widget.onQuantityChanged(null);
      return;
    }

    final value = double.tryParse(text);
    widget.onQuantityChanged(value);
  }

  void _incrementQuantity() {
    final currentValue = widget.quantity ?? 0.0;
    final newValue = (currentValue + 0.1).clamp(0.1, 1000.0);
    _controller.text = newValue.toStringAsFixed(1);
  }

  void _decrementQuantity() {
    final currentValue = widget.quantity ?? 0.1;
    final newValue = (currentValue - 0.1).clamp(0.1, 1000.0);
    _controller.text = newValue.toStringAsFixed(1);
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Quantity is required';
    }

    final quantity = double.tryParse(value);
    if (quantity == null) {
      return 'Please enter a valid number';
    }

    if (quantity < 0.1) {
      return 'Minimum quantity is 0.1 kg';
    }

    if (quantity > 1000.0) {
      return 'Maximum quantity is 1000 kg';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quantity (kg) *',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasError
                    ? AppTheme.lightTheme.colorScheme.error
                    : _focusNode.hasFocus
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                width: hasError || _focusNode.hasFocus ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Decrement button
                GestureDetector(
                  onTap: _decrementQuantity,
                  child: Container(
                    width: 48,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(12)),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'remove',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),

                // Text input
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}')),
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      hintText: '0.0',
                      hintStyle:
                          AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    style: AppTheme.dataTextStyle(
                      isLight: true,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    validator: _validateQuantity,
                  ),
                ),

                // Increment button
                GestureDetector(
                  onTap: _incrementQuantity,
                  child: Container(
                    width: 48,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(12)),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: 'add',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Error text or helper text
          SizedBox(height: 8),
          if (hasError)
            Text(
              widget.errorText!,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            )
          else
            Text(
              'Enter quantity in kilograms (0.1 - 1000 kg)',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),

          // Quick quantity buttons
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [0.5, 1.0, 2.0, 5.0, 10.0].map((value) {
              final isSelected = widget.quantity == value;
              return GestureDetector(
                onTap: () {
                  _controller.text = value.toStringAsFixed(1);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '${value.toStringAsFixed(1)} kg',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? Colors.white
                          : AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
