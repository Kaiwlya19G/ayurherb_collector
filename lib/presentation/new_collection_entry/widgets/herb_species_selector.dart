import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class HerbSpeciesSelector extends StatefulWidget {
  final String? selectedSpecies;
  final Function(String?) onSpeciesChanged;

  const HerbSpeciesSelector({
    super.key,
    this.selectedSpecies,
    required this.onSpeciesChanged,
  });

  @override
  State<HerbSpeciesSelector> createState() => _HerbSpeciesSelectorState();
}

class _HerbSpeciesSelectorState extends State<HerbSpeciesSelector> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredHerbs = [];

  // Mock herb species database with multilingual support
  final List<Map<String, dynamic>> _herbDatabase = [
    {
      "id": "1",
      "scientific": "Withania somnifera",
      "english": "Ashwagandha",
      "hindi": "अश्वगंधा",
      "marathi": "आश्वगंधा",
      "category": "Root",
      "description": "Adaptogenic herb used for stress relief and vitality"
    },
    {
      "id": "2",
      "scientific": "Bacopa monnieri",
      "english": "Brahmi",
      "hindi": "ब्राह्मी",
      "marathi": "ब्राह्मी",
      "category": "Leaf",
      "description": "Memory enhancing herb for cognitive function"
    },
    {
      "id": "3",
      "scientific": "Centella asiatica",
      "english": "Gotu Kola",
      "hindi": "मंडूकपर्णी",
      "marathi": "कर्कटशृंगी",
      "category": "Leaf",
      "description": "Brain tonic and wound healing herb"
    },
    {
      "id": "4",
      "scientific": "Tinospora cordifolia",
      "english": "Giloy",
      "hindi": "गिलोय",
      "marathi": "गुडुची",
      "category": "Stem",
      "description": "Immunity booster and fever reducer"
    },
    {
      "id": "5",
      "scientific": "Ocimum tenuiflorum",
      "english": "Holy Basil",
      "hindi": "तुलसी",
      "marathi": "तुळस",
      "category": "Leaf",
      "description": "Sacred herb for respiratory and immune health"
    },
    {
      "id": "6",
      "scientific": "Curcuma longa",
      "english": "Turmeric",
      "hindi": "हल्दी",
      "marathi": "हळद",
      "category": "Rhizome",
      "description": "Anti-inflammatory and antioxidant spice"
    },
    {
      "id": "7",
      "scientific": "Azadirachta indica",
      "english": "Neem",
      "hindi": "नीम",
      "marathi": "कडुनिंब",
      "category": "Leaf",
      "description": "Natural antiseptic and skin purifier"
    },
    {
      "id": "8",
      "scientific": "Aloe barbadensis",
      "english": "Aloe Vera",
      "hindi": "घृतकुमारी",
      "marathi": "कोरफड",
      "category": "Leaf",
      "description": "Healing and moisturizing succulent"
    },
    {
      "id": "9",
      "scientific": "Terminalia chebula",
      "english": "Haritaki",
      "hindi": "हरड़",
      "marathi": "हिरडा",
      "category": "Fruit",
      "description": "Digestive and detoxifying fruit"
    },
    {
      "id": "10",
      "scientific": "Phyllanthus emblica",
      "english": "Amla",
      "hindi": "आंवला",
      "marathi": "आवळा",
      "category": "Fruit",
      "description": "Vitamin C rich immunity booster"
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredHerbs = _herbDatabase;
  }

  void _filterHerbs(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredHerbs = _herbDatabase;
      } else {
        _filteredHerbs = _herbDatabase.where((herb) {
          final searchLower = query.toLowerCase();
          return (herb["scientific"] as String)
                  .toLowerCase()
                  .contains(searchLower) ||
              (herb["english"] as String).toLowerCase().contains(searchLower) ||
              (herb["hindi"] as String).contains(query) ||
              (herb["marathi"] as String).contains(query) ||
              (herb["category"] as String).toLowerCase().contains(searchLower);
        }).toList();
      }
    });
  }

  void _showHerbSelectionBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: 80.h,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Text(
                      'Select Herb Species',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: CustomIconWidget(
                        iconName: 'close',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Search field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    _filterHerbs(value);
                    setModalState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Search herbs by name, category...',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12),
                      child: CustomIconWidget(
                        iconName: 'search',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              _filterHerbs('');
                              setModalState(() {});
                            },
                            icon: CustomIconWidget(
                              iconName: 'clear',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppTheme.lightTheme.primaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),

              // Herb list
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: _filteredHerbs.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final herb = _filteredHerbs[index];
                    final isSelected =
                        widget.selectedSpecies == herb["english"];

                    return GestureDetector(
                      onTap: () {
                        widget.onSpeciesChanged(herb["english"] as String);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.1)
                              : AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    herb["english"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? AppTheme.lightTheme.primaryColor
                                          : null,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.lightTheme.primaryColor
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    herb["category"] as String,
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              herb["scientific"] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                  'हिंदी: ${herb["hindi"]}',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                ),
                                SizedBox(width: 16),
                                Text(
                                  'मराठी: ${herb["marathi"]}',
                                  style:
                                      AppTheme.lightTheme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              herb["description"] as String,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _showHerbSelectionBottomSheet,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.selectedSpecies != null
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
            width: widget.selectedSpecies != null ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'grass',
              color: widget.selectedSpecies != null
                  ? AppTheme.lightTheme.primaryColor
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Herb Species',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.selectedSpecies ?? 'Select herb species',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: widget.selectedSpecies != null
                          ? AppTheme.lightTheme.colorScheme.onSurface
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: widget.selectedSpecies != null
                          ? FontWeight.w500
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'keyboard_arrow_down',
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
