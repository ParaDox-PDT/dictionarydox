import 'package:dictionarydox/src/core/providers/initialization_provider.dart';
import 'package:dictionarydox/src/core/services/auth_service.dart';
import 'package:dictionarydox/src/core/utils/responsive_utils.dart';
import 'package:dictionarydox/src/injector_container.dart';
import 'package:dictionarydox/src/presentation/pages/admin_page/admin_page.dart';
import 'package:dictionarydox/src/presentation/pages/home_page/home_page.dart';
import 'package:dictionarydox/src/presentation/pages/profile_page/profile_page.dart';
import 'package:dictionarydox/src/presentation/pages/units_page/units_page.dart';
import 'package:flutter/material.dart';

/// Bottom navigation shell with persistent navigation using IndexedStack
class BottomNavShell extends StatefulWidget {
  const BottomNavShell({super.key});

  @override
  State<BottomNavShell> createState() => _BottomNavShellState();
}

class _BottomNavShellState extends State<BottomNavShell> {
  int _currentIndex = 0;
  bool _isDrawerExpanded = true; // Web drawer expanded state
  late final AuthService _authService;

  @override
  void initState() {
    super.initState();
    _authService = sl<AuthService>();
  }

  /// Check if current user is admin
  bool get _isAdmin {
    final email = _authService.email;
    return email == 'doniyorjorabekov@gmail.com';
  }

  /// Get list of screens based on admin status
  List<Widget> get _screens {
    if (_isAdmin) {
      return [
        const HomePage(),
        const UnitsPage(),
        const ProfilePage(),
        const AdminPage(),
      ];
    }
    return [
      const HomePage(),
      const UnitsPage(),
      const ProfilePage(),
    ];
  }

  /// Get navigation destinations for mobile
  List<NavigationDestination> get _mobileDestinations {
    final destinations = [
      const NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home, color: Colors.blue),
        label: 'Home',
      ),
      const NavigationDestination(
        icon: Icon(Icons.folder_outlined),
        selectedIcon: Icon(Icons.folder, color: Colors.blue),
        label: 'Units',
      ),
      const NavigationDestination(
        icon: Icon(Icons.person_outline),
        selectedIcon: Icon(Icons.person, color: Colors.blue),
        label: 'Profile',
      ),
    ];

    if (_isAdmin) {
      destinations.add(
        const NavigationDestination(
          icon: Icon(Icons.admin_panel_settings_outlined),
          selectedIcon: Icon(Icons.admin_panel_settings, color: Colors.blue),
          label: 'Admin',
        ),
      );
    }

    return destinations;
  }

  @override
  Widget build(BuildContext context) {
    // Wait for initialization before building screens
    return FutureBuilder(
      future: InitializationProvider.of(context).initialization,
      builder: (context, snapshot) {
        // Show loading while initializing
        if (snapshot.connectionState != ConnectionState.done) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.white,
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Loading DictionaryDox...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Show error if initialization failed
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to initialize app',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Error: ${snapshot.error}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          );
        }

        // Initialization complete - build normal navigation
        return _buildNavigation();
      },
    );
  }

  Widget _buildNavigation() {
    final isMobile = ResponsiveUtils.isMobile(context);

    // Get screens based on admin status
    final screens = _screens;

    if (isMobile) {
      // Mobile: Bottom Navigation Bar
      return Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          elevation: 8,
          backgroundColor: Theme.of(context).colorScheme.surface,
          indicatorColor: Colors.blue.withOpacity(0.2),
          destinations: _mobileDestinations,
        ),
      );
    } else {
      // Web: Drawer Navigation
      return Scaffold(
        body: Row(
          children: [
            // Drawer
            _buildWebDrawer(),
            // Main Content
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: screens,
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildWebDrawer() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: _isDrawerExpanded ? 280 : 80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(2, 0),
            spreadRadius: 0,
          ),
        ],
        border: Border(
          right: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Drawer Header
          _buildDrawerHeader(),
          // Navigation Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: _buildDrawerItem(
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home_rounded,
                    label: 'Home',
                    index: 0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: _buildDrawerItem(
                    icon: Icons.folder_outlined,
                    selectedIcon: Icons.folder_rounded,
                    label: 'Units',
                    index: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: _buildDrawerItem(
                    icon: Icons.person_outline_rounded,
                    selectedIcon: Icons.person_rounded,
                    label: 'Profile',
                    index: 2,
                  ),
                ),
                if (_isAdmin)
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 8),
                    child: _buildDrawerItem(
                      icon: Icons.admin_panel_settings_outlined,
                      selectedIcon: Icons.admin_panel_settings_rounded,
                      label: 'Admin',
                      index: 3,
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 2, bottom: 8),
                    child: Container(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    // Fixed height for both expanded and collapsed states
    const double headerHeight = 90;

    return Container(
      height: headerHeight,
      padding: EdgeInsets.all(_isDrawerExpanded ? 20 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
      ),
      child: _isDrawerExpanded
          ? Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    'assets/images/app_logo.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white,
                        size: 24,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AnimatedOpacity(
                    opacity: _isDrawerExpanded ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeIn,
                    child: Visibility(
                      visible: _isDrawerExpanded,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'DictionaryDox',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Vocabulary Trainer',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isDrawerExpanded = false;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isDrawerExpanded = true;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    // Fixed hex colors to avoid Brave CSS mapping bugs
    // Using explicit colors instead of Colors.grey[700] prevents Brave from
    // invalidating layers during color lookups
    const Color unselectedIconColor =
        Color(0xFF616161); // Equivalent to Colors.grey[700]
    const Color unselectedTextColor = Color(0xFF616161);

    // Get primary color once to avoid repeated Theme lookups
    final primaryColor = Theme.of(context).primaryColor;

    // Determine icon and colors once per build to prevent switching
    // This prevents layer invalidation in Brave when icon changes
    final currentIcon = isSelected ? selectedIcon : icon;
    final iconColor = isSelected ? primaryColor : unselectedIconColor;
    final textColor = isSelected ? primaryColor : unselectedTextColor;
    final iconBgColor = isSelected
        ? primaryColor.withOpacity(0.15)
        : const Color(0xFFF5F5F5)
            .withOpacity(0.1); // Fixed grey instead of Colors.grey

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _isDrawerExpanded ? 12 : 6,
      ),
      child: RepaintBoundary(
        // Isolate repaints to prevent Brave from invalidating parent layers
        child: Material(
          color: Colors.transparent,
          clipBehavior: Clip.hardEdge, // Prevents layer invalidation in Brave
          child: InkWell(
            onTap: () {
              setState(() {
                _currentIndex = index;
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 48,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: _isDrawerExpanded ? 16 : 10,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? primaryColor.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? Border(
                        left: BorderSide(
                          color: primaryColor,
                          width: 3,
                        ),
                      )
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Simplified container - removed AnimatedContainer to reduce rebuilds
                  // Using Container with explicit values prevents Brave from invalidating
                  // layers during animation state changes
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // Single Icon widget with stable properties prevents font reloading
                    // Using key to ensure icon doesn't get recreated unnecessarily
                    child: Icon(
                      currentIcon,
                      color: iconColor,
                      size: 22,
                      // Explicitly set text direction to prevent Brave font loading issues
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                  if (_isDrawerExpanded) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: textColor,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
