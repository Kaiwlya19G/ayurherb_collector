import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/camera_capture_widget.dart';
import './widgets/collection_notes_widget.dart';
import './widgets/date_time_picker_widget.dart';
import './widgets/gps_location_widget.dart';
import './widgets/herb_species_selector.dart';
import './widgets/quantity_input_widget.dart';

class NewCollectionEntry extends StatefulWidget {
  const NewCollectionEntry({super.key});

  @override
  State<NewCollectionEntry> createState() => _NewCollectionEntryState();
}

class _NewCollectionEntryState extends State<NewCollectionEntry> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  // Form data
  List<XFile> _capturedPhotos = [];
  double? _latitude;
  double? _longitude;
  String? _selectedSpecies;
  double? _quantity;
  String? _notes;
  DateTime? _collectionDateTime;

  // Form validation
  String? _quantityError;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _capturedPhotos.isNotEmpty &&
        _latitude != null &&
        _longitude != null &&
        _selectedSpecies != null &&
        _quantity != null &&
        _quantity! >= 0.1 &&
        _quantity! <= 1000.0 &&
        _collectionDateTime != null;
  }

  void _validateQuantity() {
    setState(() {
      if (_quantity == null) {
        _quantityError = 'Quantity is required';
      } else if (_quantity! < 0.1) {
        _quantityError = 'Minimum quantity is 0.1 kg';
      } else if (_quantity! > 1000.0) {
        _quantityError = 'Maximum quantity is 1000 kg';
      } else {
        _quantityError = null;
      }
    });
  }

  Future<void> _saveCollection() async {
    if (!_isFormValid) {
      _showValidationDialog();
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Simulate blockchain transaction generation
      await Future.delayed(Duration(seconds: 2));

      // Generate mock collection ID and blockchain transaction ID
      final collectionId = 'COL${DateTime.now().millisecondsSinceEpoch}';
      final blockchainTxId =
          'TX${DateTime.now().millisecondsSinceEpoch.toRadixString(16).toUpperCase()}';

      // Show success dialog with blockchain details
      _showSuccessDialog(collectionId, blockchainTxId);
    } catch (e) {
      _showErrorDialog('Failed to save collection. Please try again.');
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  void _showValidationDialog() {
    final missingFields = <String>[];

    if (_capturedPhotos.isEmpty) missingFields.add('Photos');
    if (_latitude == null || _longitude == null)
      missingFields.add('GPS Location');
    if (_selectedSpecies == null) missingFields.add('Herb Species');
    if (_quantity == null || _quantityError != null)
      missingFields.add('Valid Quantity');
    if (_collectionDateTime == null)
      missingFields.add('Collection Date & Time');

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Incomplete Form'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Please complete the following required fields:'),
                SizedBox(height: 8),
                ...missingFields.map(
                  (field) => Padding(
                    padding: EdgeInsets.only(left: 16, top: 4),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'radio_button_unchecked',
                          color: AppTheme.lightTheme.colorScheme.error,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Text(field),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showSuccessDialog(String collectionId, String blockchainTxId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: AppTheme.getSuccessColor(true),
                  size: 24,
                ),
                SizedBox(width: 8),
                Text('Collection Saved'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your herb collection has been successfully recorded and submitted to the blockchain.',
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.getSuccessColor(
                      true,
                    ).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Collection ID:',
                        style: AppTheme.lightTheme.textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        collectionId,
                        style: AppTheme.dataTextStyle(
                          isLight: true,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Blockchain TX ID:',
                        style: AppTheme.lightTheme.textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        blockchainTxId,
                        style: AppTheme.dataTextStyle(
                          isLight: true,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/collection-dashboard',
                    (route) => false,
                  );
                },
                child: Text('View Dashboard'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pushNamed(context, '/qr-code-display');
                },
                child: Text('View QR Code'),
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                CustomIconWidget(
                  iconName: 'error',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text('Error'),
              ],
            ),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('New Collection Entry'),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        foregroundColor: AppTheme.lightTheme.appBarTheme.foregroundColor,
        elevation: 2,
        leading: IconButton(
          onPressed:
              () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/collection-dashboard',
                (route) => false,
              ),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.appBarTheme.foregroundColor!,
            size: 24,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: ElevatedButton.icon(
              onPressed: _isFormValid && !_isSaving ? _saveCollection : null,
              icon:
                  _isSaving
                      ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                      : CustomIconWidget(
                        iconName: 'save',
                        color: Colors.white,
                        size: 18,
                      ),
              label: Text(_isSaving ? 'Saving...' : 'Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isFormValid && !_isSaving
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.outline,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GPS Location Widget
              GpsLocationWidget(
                latitude: _latitude,
                longitude: _longitude,
                onLocationChanged: (lat, lng) {
                  setState(() {
                    _latitude = lat;
                    _longitude = lng;
                  });
                },
              ),

              SizedBox(height: 24),

              // Camera Capture Widget
              CameraCaptureWidget(
                capturedPhotos: _capturedPhotos,
                onPhotosChanged: (photos) {
                  setState(() {
                    _capturedPhotos = photos;
                  });
                },
              ),

              SizedBox(height: 24),

              // Herb Species Selector
              HerbSpeciesSelector(
                selectedSpecies: _selectedSpecies,
                onSpeciesChanged: (species) {
                  setState(() {
                    _selectedSpecies = species;
                  });
                },
              ),

              SizedBox(height: 24),

              // Quantity Input Widget
              QuantityInputWidget(
                quantity: _quantity,
                errorText: _quantityError,
                onQuantityChanged: (quantity) {
                  setState(() {
                    _quantity = quantity;
                  });
                  _validateQuantity();
                },
              ),

              SizedBox(height: 24),

              // Date Time Picker Widget
              DateTimePickerWidget(
                selectedDateTime: _collectionDateTime,
                onDateTimeChanged: (dateTime) {
                  setState(() {
                    _collectionDateTime = dateTime;
                  });
                },
              ),

              SizedBox(height: 24),

              // Collection Notes Widget
              CollectionNotesWidget(
                notes: _notes,
                onNotesChanged: (notes) {
                  setState(() {
                    _notes = notes;
                  });
                },
              ),

              SizedBox(height: 32),

              // Form completion status
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      _isFormValid
                          ? AppTheme.getSuccessColor(
                            true,
                          ).withValues(alpha: 0.1)
                          : AppTheme.getWarningColor(
                            true,
                          ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        _isFormValid
                            ? AppTheme.getSuccessColor(
                              true,
                            ).withValues(alpha: 0.3)
                            : AppTheme.getWarningColor(
                              true,
                            ).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: _isFormValid ? 'check_circle' : 'info',
                      color:
                          _isFormValid
                              ? AppTheme.getSuccessColor(true)
                              : AppTheme.getWarningColor(true),
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isFormValid
                            ? 'All required fields completed. Ready to save!'
                            : 'Please complete all required fields to save the collection.',
                        style: AppTheme.lightTheme.textTheme.bodyMedium
                            ?.copyWith(
                              color:
                                  _isFormValid
                                      ? AppTheme.getSuccessColor(true)
                                      : AppTheme.getWarningColor(true),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar.newEntry(),
    );
  }
}
