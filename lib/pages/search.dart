import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';



class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedFilter = 'All';
  bool showFilters = false;

   List<String> filters = [
    'All',
    'Athletes',
    'Sponsors',
  ];

  @override
  void initState() {
    super.initState();
    filters.addAll(sports);
  }
  final List<Map<String, dynamic>> searchSuggestions = [
    {
      'title': 'Qualified Athletes',
      'icon': Icons.run_circle_outlined,
      'category': 'Athletes'
    },
    {
      'title': 'Sponsors',
      'icon': Icons.smart_toy_outlined,
      'category': 'Sponsors'
    },
    {
      'title': 'balancing work and personal life',
      'icon': Icons.balance_outlined,
      'category': 'Cricket'
    },
    {
      'title': 'remote work',
      'icon': Icons.home_work_outlined,
      'category': 'Work'
    },
    {
      'title': 'when\'s the best time to switch jobs',
      'icon': Icons.swap_horiz_outlined,
      'category': 'Career'
    },
    {
      'title': 'productivity hacks',
      'icon': Icons.trending_up_outlined,
      'category': 'Tips'
    },
    {
      'title': 'machine learning trends',
      'icon': Icons.psychology_outlined,
      'category': 'Technology'
    },
    {
      'title': 'work life balance strategies',
      'icon': Icons.self_improvement_outlined,
      'category': 'Lifestyle'
    },
  ];

  List<Map<String, dynamic>> get filteredSuggestions {
    if (selectedFilter == 'All') {
      return searchSuggestions;
    }
    return searchSuggestions
        .where((suggestion) => suggestion['category'] == selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey[600]),
              prefixIcon: Icon(Icons.search, color: Colors.blue[600], size: 20),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            style: TextStyle(fontSize: 16),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              showFilters ? Icons.filter_list : Icons.tune,
              color: Colors.blue[600],
            ),
            onPressed: () {
              setState(() {
                showFilters = !showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter chips
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: showFilters ? 60 : 0,
            child: showFilters
                ? Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: filters.map((filter) {
                          final isSelected = selectedFilter == filter;
                          return Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey[700],
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  selectedFilter = filter;
                                });
                              },
                              selectedColor: Colors.blue[600],
                              backgroundColor: Colors.grey[200],
                              elevation: isSelected ? 2 : 0,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),
          
          // Search suggestions header
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Try searching for',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (selectedFilter != 'All') ...[
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      selectedFilter,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Search suggestions list
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = filteredSuggestions[index];
                  return InkWell(
                    onTap: () {
                      _searchController.text = suggestion['title'];
                      // Handle search action here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Searching for: ${suggestion['title']}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey[200]!,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              suggestion['icon'],
                              color: Colors.grey[600],
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  suggestion['title'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  suggestion['category'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_outward,
                            color: Colors.grey[400],
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}