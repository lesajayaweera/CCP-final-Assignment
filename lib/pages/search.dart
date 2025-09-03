import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/model/SearchService.dart';
// Import your SearchService

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedFilter = 'All';
  bool showFilters = false;
  bool isLoading = false;
  List<Map<String, dynamic>> searchResults = [];
  bool hasSearched = false;

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

  

  

  List<Map<String, dynamic>> get filteredSearchResults {
    if (selectedFilter == 'All') {
      return searchResults;
    }
    
    String filterCollection = '';
    switch (selectedFilter) {
      case 'Athletes':
        filterCollection = 'athlete';
        break;
      case 'Sponsors':
        filterCollection = 'sponsor';
        break;
      case 'Users':
        filterCollection = 'user';
        break;
      default:
        return searchResults;
    }
    
    return searchResults
        .where((result) => result['collection'] == filterCollection)
        .toList();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        searchResults = [];
        hasSearched = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      hasSearched = true;
    });

    try {
      final results = await SearchService.searchAllUsers(query.trim());
      setState(() {
        searchResults = results;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        searchResults = [];
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error searching: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    String collection = user['collection'] ?? 'user';
    IconData icon;
    Color iconColor;
    String subtitle = collection.toUpperCase();

    switch (collection) {
      case 'athlete':
        icon = Icons.sports;
        iconColor = Colors.orange;
        break;
      case 'sponsor':
        icon = Icons.business;
        iconColor = Colors.green;
        break;
      default:
        icon = Icons.person;
        iconColor = Colors.blue;
        subtitle = 'USER';
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        title: Text(
          user['name'] ?? 'Unknown',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subtitle,
              style: TextStyle(
                color: iconColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (user['email'] != null) ...[
              SizedBox(height: 2),
              Text(
                user['email'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        onTap: () {
          // Handle user selection
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selected: ${user['name']}'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
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
              hintText: 'Search users, athletes, sponsors...',
              hintStyle: TextStyle(color: Colors.grey[600]),
              prefixIcon: Icon(Icons.search, color: Colors.blue[600], size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[600], size: 20),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            style: TextStyle(fontSize: 16),
            onChanged: (value) {
              setState(() {});
              // Debounce search - you might want to implement proper debouncing
              Future.delayed(Duration(milliseconds: 500), () {
                if (_searchController.text == value) {
                  _performSearch(value);
                }
              });
            },
            onSubmitted: _performSearch,
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
          
          // Content area
          Expanded(
            child: hasSearched
                ? _buildSearchResults()
                : SizedBox.shrink()
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.blue[600]),
            SizedBox(height: 16),
            Text(
              'Searching...',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    final displayResults = filteredSearchResults;

    if (displayResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No results found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '${displayResults.length} result${displayResults.length == 1 ? '' : 's'} found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: displayResults.length,
            itemBuilder: (context, index) {
              return _buildUserCard(displayResults[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Search for users',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Type in the search box to find athletes, sponsors, and users',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
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