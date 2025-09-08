import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class DateTimePickerWidget extends StatefulWidget {
  final DateTime? selectedDateTime;
  final Function(DateTime?) onDateTimeChanged;

  const DateTimePickerWidget({
    super.key,
    this.selectedDateTime,
    required this.onDateTimeChanged,
  });

  @override
  State<DateTimePickerWidget> createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  DateTime _currentDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.selectedDateTime != null) {
      _currentDateTime = widget.selectedDateTime!;
    } else {
      // Auto-populate with current date/time
      widget.onDateTimeChanged(_currentDateTime);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDateTime ?? _currentDateTime,
      firstDate: DateTime.now()
          .subtract(Duration(days: 30)), // Allow up to 30 days back
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.primaryColor,
                  onPrimary: Colors.white,
                  surface: AppTheme.lightTheme.colorScheme.surface,
                  onSurface: AppTheme.lightTheme.colorScheme.onSurface,
                ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final currentTime = widget.selectedDateTime ?? _currentDateTime;
      final newDateTime = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        currentTime.hour,
        currentTime.minute,
      );

      setState(() {
        _currentDateTime = newDateTime;
      });
      widget.onDateTimeChanged(newDateTime);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay.fromDateTime(widget.selectedDateTime ?? _currentDateTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.primaryColor,
                  onPrimary: Colors.white,
                  surface: AppTheme.lightTheme.colorScheme.surface,
                  onSurface: AppTheme.lightTheme.colorScheme.onSurface,
                ),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      final currentDate = widget.selectedDateTime ?? _currentDateTime;
      final newDateTime = DateTime(
        currentDate.year,
        currentDate.month,
        currentDate.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      setState(() {
        _currentDateTime = newDateTime;
      });
      widget.onDateTimeChanged(newDateTime);
    }
  }

  void _setCurrentDateTime() {
    final now = DateTime.now();
    setState(() {
      _currentDateTime = now;
    });
    widget.onDateTimeChanged(now);
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour == 0
        ? 12
        : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final displayDateTime = widget.selectedDateTime ?? _currentDateTime;
    final isCurrentTime =
        DateTime.now().difference(displayDateTime).abs().inMinutes < 2;

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Collection Date & Time',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (isCurrentTime) ...[
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.getSuccessColor(true).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Current',
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.getSuccessColor(true),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 12),

          Row(
            children: [
              // Date picker
              Expanded(
                child: GestureDetector(
                  onTap: _selectDate,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'calendar_today',
                              color: AppTheme.lightTheme.primaryColor,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Date',
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          _formatDate(displayDateTime),
                          style: AppTheme.dataTextStyle(
                            isLight: true,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12),

              // Time picker
              Expanded(
                child: GestureDetector(
                  onTap: _selectTime,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'access_time',
                              color: AppTheme.lightTheme.primaryColor,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Time',
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          _formatTime(displayDateTime),
                          style: AppTheme.dataTextStyle(
                            isLight: true,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Current time button
          Center(
            child: TextButton.icon(
              onPressed: _setCurrentDateTime,
              icon: CustomIconWidget(
                iconName: 'update',
                color: AppTheme.lightTheme.primaryColor,
                size: 18,
              ),
              label: Text('Set Current Date & Time'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          // Helper text
          SizedBox(height: 8),
          Text(
            'Collection date can be up to 30 days in the past',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
