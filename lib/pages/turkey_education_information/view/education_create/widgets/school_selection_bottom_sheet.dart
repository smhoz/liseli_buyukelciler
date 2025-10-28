import 'package:flutter/material.dart';
import 'package:sosyal_medya/flutter_flow/flutter_flow_theme.dart';
import 'package:sosyal_medya/pages/education_information/model/school_model/school_model.dart';

class SchoolSelectionBottomSheet extends StatefulWidget {
  final List<SchoolModel> schools;
  final SchoolModel? selectedSchool;
  final String title;

  const SchoolSelectionBottomSheet({
    Key? key,
    required this.schools,
    this.selectedSchool,
    required this.title,
  }) : super(key: key);

  @override
  State<SchoolSelectionBottomSheet> createState() =>
      _SchoolSelectionBottomSheetState();
}

class _SchoolSelectionBottomSheetState
    extends State<SchoolSelectionBottomSheet> {
  late TextEditingController searchController;
  late ScrollController scrollController;
  
  List<SchoolModel> displayedSchools = [];
  List<SchoolModel> filteredSchools = [];
  
  static const int itemsPerPage = 50;
  int currentPage = 0;
  bool isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    scrollController = ScrollController();
    
    filteredSchools = List.from(widget.schools);
    _loadMoreItems();
    
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      _loadMoreItems();
    }
  }

  void _loadMoreItems() {
    if (isLoadingMore) return;
    
    final startIndex = currentPage * itemsPerPage;
    if (startIndex >= filteredSchools.length) return;
    
    setState(() {
      isLoadingMore = true;
    });
    
    // Simulate a small delay for smooth loading
    Future.delayed(Duration(milliseconds: 100), () {
      if (!mounted) return;
      
      final endIndex = (startIndex + itemsPerPage).clamp(0, filteredSchools.length);
      final newItems = filteredSchools.sublist(startIndex, endIndex);
      
      setState(() {
        displayedSchools.addAll(newItems);
        currentPage++;
        isLoadingMore = false;
      });
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredSchools = List.from(widget.schools);
      } else {
        filteredSchools = widget.schools
            .where((school) =>
                school.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      
      // Reset pagination
      displayedSchools.clear();
      currentPage = 0;
      _loadMoreItems();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: FlutterFlowTheme.of(context).alternate,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).alternate,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Title
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                              fontFamily: 'Outfit',
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                // Search field
                TextField(
                  controller: searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Okul ara...',
                    hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                          fontFamily: 'Figtree',
                          letterSpacing: 0.0,
                        ),
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              _onSearchChanged('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).alternate,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                // Results count
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${filteredSchools.length} okul bulundu',
                    style: FlutterFlowTheme.of(context).bodySmall.override(
                          fontFamily: 'Figtree',
                          color: FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                        ),
                  ),
                ),
              ],
            ),
          ),
          // List
          Expanded(
            child: displayedSchools.isEmpty && !isLoadingMore
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        searchController.text.isEmpty
                            ? 'Okul bulunamadı'
                            : 'Arama sonucu bulunamadı',
                        style: FlutterFlowTheme.of(context).bodyLarge.override(
                              fontFamily: 'Figtree',
                              color: FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                            ),
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    itemCount: displayedSchools.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == displayedSchools.length) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final school = displayedSchools[index];
                      final isSelected = widget.selectedSchool?.id == school.id;

                      return InkWell(
                        onTap: () => Navigator.pop(context, school),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? FlutterFlowTheme.of(context).primary.withOpacity(0.1)
                                : Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                color: FlutterFlowTheme.of(context).alternate,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  school.name,
                                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                                        fontFamily: 'Figtree',
                                        letterSpacing: 0.0,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24,
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
    );
  }
}

