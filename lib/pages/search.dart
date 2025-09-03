import 'package:flutter/material.dart';
import 'package:sport_ignite/config/essentials.dart';
import 'package:sport_ignite/model/SearchService.dart';


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
    'Users',
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
    String name = user['name'] ?? user['fullName'] ?? 'Unknown';
    String email = user['email'] ?? '';
    String profileImage = user['profile'] ?? '';

    // Collection specific data
    String subtitle = '';
    String extraInfo = '';
    IconData icon;
    Color primaryColor;
    Color backgroundColor;

    switch (collection) {
      case 'athlete':
        icon = Icons.sports_basketball;
        primaryColor = Colors.orange[600]!;
        backgroundColor = Colors.orange[50]!;
        subtitle = user['sport'] ?? 'Athlete';
        
        List<String> infoParts = [];
        if (user['positions'] != null) infoParts.add(user['positions']);
        if (user['experience'] != null) infoParts.add('${user['experience']} years exp');
        if (user['city'] != null) infoParts.add(user['city']);
        extraInfo = infoParts.join(' • ');
        break;
        
      case 'sponsor':
        icon = Icons.business_center;
        primaryColor = Colors.blue[600]!;
        backgroundColor = Colors.blue[50]!;
        subtitle = user['company'] ?? 'Sponsor';
        
        List<String> infoParts = [];
        if (user['sportIntrested'] != null) infoParts.add(user['sportIntrested']);
        if (user['orgStructure'] != null) infoParts.add(user['orgStructure']);
        if (user['city'] != null) infoParts.add(user['city']);
        extraInfo = infoParts.join(' • ');
        break;
        
      default:
        icon = Icons.person;
        primaryColor = Colors.grey[600]!;
        backgroundColor = Colors.grey[50]!;
        subtitle = 'User';
        if (user['city'] != null) extraInfo = user['city'];
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            // Handle user selection
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Selected: $name'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Profile Image or Icon
                Container(
                  width: 56,
                  height: 56,
                  child: profileImage.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Image.network(
                            profileImage,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildDefaultAvatar(icon, primaryColor, backgroundColor);
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return _buildDefaultAvatar(icon, primaryColor, backgroundColor);
                            },
                          ),
                        )
                      : _buildDefaultAvatar(icon, primaryColor, backgroundColor),
                ),
                
                SizedBox(width: 16),
                
                // User Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      SizedBox(height: 4),
                      
                      // Role/Company with badge
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: primaryColor.withOpacity(0.3)),
                            ),
                            child: Text(
                              subtitle,
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 8),
                      
                      // Email
                      if (email.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                email,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                      ],
                      
                      // Extra info
                      if (extraInfo.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                extraInfo,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Arrow icon
                Container(
                  padding: EdgeInsets.all(8),
                  child: Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(IconData icon, Color primaryColor, Color backgroundColor) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: primaryColor.withOpacity(0.2), width: 2),
      ),
      child: Icon(
        icon,
        color: primaryColor,
        size: 28,
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